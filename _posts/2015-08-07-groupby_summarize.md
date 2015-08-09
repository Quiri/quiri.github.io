---
layout: post
title: "Pay attention with group_by and summarise"
excerpt:
categories: articles
tags: [R, dplyr]
comments: false
share: true
published: true
author: "kirill"
modified: 2015-08-07
---

As a experienced dplyr user since almost day 0, I thought I knew almost every aspect of it. But when my new colleague, who is learning dplyr from scratch, asked me to explain the peeling of group layers with summarize, I was like, what?
Turns out this *is* actually a thing. Let me show a the example from the [dplyr introduction](https://cran.rstudio.com/web/packages/dplyr/vignettes/introduction.html):


{% highlight r %}
library(dplyr)
library(nycflights13)
daily <- flights %>% 
  group_by(year, month, day) %>%
  summarise(flights = n())
daily
{% endhighlight %}



{% highlight text %}
## Source: local data frame [365 x 4]
## Groups: year, month
## 
##    year month day flights
## 1  2013     1   1     842
## 2  2013     1   2     943
## 3  2013     1   3     914
## 4  2013     1   4     915
## 5  2013     1   5     720
## 6  2013     1   6     832
## 7  2013     1   7     933
## 8  2013     1   8     899
## 9  2013     1   9     902
## 10 2013     1  10     932
## ..  ...   ... ...     ...
{% endhighlight %}

Pay atttention, that the newly generated data.frame is only grouped by `year` and `month` only, not by `date` anymore, which is effect of the forementioned peeling. The idea is, that if you want to

