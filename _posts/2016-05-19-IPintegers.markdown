---
layout: post
title: IP string to integer conversion with Rcpp
excerpt: happily hacking along in Rcpp without a clue
categories: articles
tags: [R, Rcpp, boost, IP addresses]
comments: true
share: true
published: true
author: safferli
date: 2016-05-19T08:30:21+02:00 
---

## IP address conversion

<span class = "dropcap">A</span>t work I recently had to match data on IP addresses and some fuzzy timestamp matching -- a mess, to say the least. But before I could even tackle that problem, one dataset had the IPs stored as a character (e.g. `10.0.0.0`), while the other dataset had the IP addresses converted as integers (e.g. `167772160`). 

Storing IPs as integers has the advantage of saving some space and making calculations easier. [This page](http://www.aboutmyip.com/AboutMyXApp/IP2Integer.jsp?ipAddress=10.0.0.0) goes into detail on how this conversion is made. You split the IP address into the four octets and then shift each octet by sets of 8 bit: 

 	(first octet * 256³) + (second octet * 256²) + (third octet * 256) + (fourth octet)

Using `10.0.0.0` as an example: 

`(10*256^3) + (0*256^2) + (0*256^1) + (0*256^0) = 167772160`


## Converting in R

Since it's a simple mathematical conversion, it's easy to write a function that will convert the IP to integer, and also back. Stackoverflow has [an answer here](http://stackoverflow.com/questions/21610147/convert-ip-address-ipv4-itno-an-integer-in-r). 


## Converting in Rcpp

During my googleing, I stumbled across [this blogpost](http://datadrivensecurity.info/blog/posts/2014/May/speeding-up-ipv4-address-conversion-in-r/), which solved the problem with some CPP code using the magic of [boost](http://www.boost.org/), a CPP library with lots of nice functions.

Since my data had several millions of rows, generally anything that speeds up conversions is a good idea! I tried the code available at their site which threw some errors on comment characters. After removing the comments, everything worked nicely (don't forget to install the boost libraries! `sudo apt-get install libboost-dev`):

```cpp
#include <Rcpp.h> 
#include <boost/asio/ip/address_v4.hpp>

using namespace Rcpp;

// [[Rcpp::export]]
unsigned long rinet_pton (CharacterVector ip) { 
  return(boost::asio::ip::address_v4::from_string(ip[0]).to_ulong());
}

// [[Rcpp::export]]
CharacterVector rinet_ntop (unsigned long addr) {
  return(boost::asio::ip::address_v4(addr).to_string());
}
```

Running the code in R is simple, and you'll get the result without any problems: 

```R
library(Rcpp)
library(inline)
Rcpp::sourceCpp("iputils.cpp")

# test convert an IPv4 string to integer
rinet_pton("10.0.0.0")
#[1] 167772160

# test conversion back
rinet_ntop(167772160)
#[1] "10.0.0.0"
```

Unfortunately, the result returned is a scalar. Running the command in a `mutate()` only returns the first IP for all rows. 
So, I took to vectorising the code. Time to grab the excellent [advanced R](http://adv-r.had.co.nz/) website/book by Hadley. Specifically, the [Rcpp section](http://adv-r.had.co.nz/Rcpp.html). Checking the cpp code, I noticed that `rinet_pton` returns a scalar (`unsigned long`), even though a vector is used as an input (`CharacterVector`). Moreover, it will always pick the first IP from the character vector input to return: `from_string(ip[0])`. 

Going by the Rcpp documentation, I changed the inputs and returns to vectors always, and wrote a quick cpp loop to vectorise the functions. 

```cpp
// [[Rcpp::export]]
IntegerVector rinet_pton (CharacterVector ip) { 
  int n = ip.size();
  IntegerVector out(n);
  
  for(int i = 0; i < n; ++i) {
    out[i] = boost::asio::ip::address_v4::from_string(ip[i]).to_ulong();
  }
  return out;
}


// [[Rcpp::export]]
CharacterVector rinet_ntop (IntegerVector addr) {
  int n = addr.size();
  CharacterVector out(n);
  
  for(int i = 0; i < n; ++i) {
    out[i] = boost::asio::ip::address_v4(addr[i]).to_string();
  }
  return out;
}
```

With the functions now vectorised, it's easy to pass vectors, and run the function on a dataframe column. 

```R
rinet_pton(c("10.0.0.0", "192.168.0.1"))
# [1]   167772160 -1062731775
```

I should note that I know nothing of cpp programming, and this was fully hacked by following the Rcpp examples. The `rinet_ntop()` function throws an error on passing negative numbers (it expects an unsigned long), so you can't reconvert the `192.168.0.1` IP to integer and back. This was not a problem for me, since all I needed was to match the IPs, and my integer IPs in the one dataset were created via boost in the first place. 

The code is available on github as [a gist](https://gist.github.com/safferli/70a858a460c0a084e35bcb71bc214273).
