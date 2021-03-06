---
layout: post
title: "Emoticons decoder for social media sentiment analysis in R"
excerpt: "A workaround to handle emoticons"
categories: articles
tags: [R, Twitter, Emoticons, Social Media]
published: yes
comments: true
author: jess
date: 2015-10-16T07:00:00+02:00
share: true
---

<span class = "dropcap">I</span>f you have ever retrieved data from Twitter, Facebook or Instagram with R, you might have noticed a strange phenomenon. While R seems to be able to display some emoticons properly, many other times it doesn't, making any further analysis impossible unless you get rid of them. With a little hack, I decoded these emoticons and put them all in a dictionary for further use. I'll explain how I did it and share the [decoder](https://github.com/today-is-a-good-day/Emoticons/blob/master/emDict.csv) with you.  

## The meaning of Emoticons and why you should analyze them
As far as I remember, all the sentiment analysis codes I came across dealt with emoticons by simply getting rid of them. Now, it might be ok if you're interested in analyzing someone's vocabulary or do some fancy wordclouds. But if you want to perform sentiment analysis, than these emoticons are probably the most meaningful part of your data! Sentiments, emotions, emoticons, you know, there's a link ;) Not only are they full of meaning by themselves, they also have the virtue to change the meaning of the sentences they are appended to. Think of a tweet like "I'm going to bed". It has a dramatically different meaning, depending on whether a happy smiley or a sad smiley is associated to it. Long story short: **If you're interested in sentiment, you MUST capture emoticons!**

## Emoticons and R
As mentioned earlier, R seems to be totally capable of properly displaying some emoticons, while it fails displayng others. Try inputing `\xE2\x9D\xA4` (heavy black heart) to the console and this is how the output will look like: 

{% highlight text %}
## [1] "❤"
{% endhighlight text %}
 
Just as expected. So far, so good. 

Now try inputing this `\xF0\x9F\x98\x8A` (smiling face with smiling eyes) and R won't display it as an emoticon:

{% highlight text %}
## [1] "\U0001f60a"
{% endhighlight text %}

The display problem seems related to the length of the code. Apparently, if an emoticon's UTF-8 code is longer then 12 characters, it won't be displayed properly. Find a list of emoticons with their respective encodings [here](http://apps.timwhitlock.info/emoji/tables/unicode). 

Now, the real problem occurs when you retrieve data from social media. This is how tweets look like when retrieved with the `userTimeline()` function and parsed to a data frame with the `twListToDF()` function from the twitteR package: 

![]({{ site.url }}/images/jessica/tweetsdf.png)

For demonstration purposes, I needed to find a twitter user who integrates a lot of different emoticons in his or her tweets. And who is better suited than emoticons queen [Paris Hilton](https://twitter.com/parishilton) herself? Exactly, nobody :D As you can see, many emoticons aren't displayed correctly but appear as strange question marks symbols instead, while others are displayed as emoticons. 

Printed to the console, the strange question marks symbols aka emoticons look like unicode except that it is not unicode and doesn't match the actual, right UTF-8 encoding I expected. Take this tweet, for example:   

{% highlight text %}
## [1] "At sound check last night for the ports1961womenswear After Party. 
\xed\xa0\xbc\xed\xbe\xb6\xed\xa0\xbd\xed\xb1\xb8\xed\xa0\xbc\xed\xbf\xbc\
xed\xa0\xbc\xed\xbe\xb6 @ Shanghai, China https://t.co/Y9lE9mXjIL"
{% endhighlight text %}
 
The first emoticon consists of multiple musical notes, it's corresponding UTF-8 encoding is `\xF0\x9F\x8E\xB6` but it is being rendered as `\xed\xa0\xbc\xed\xbe\xb6\`.

Also, try to pass the tweet to the `str()` function and you will get an error message: 
{% highlight text %}
## Error in strtrim(e.x, nchar.max): invalid multibyte string at 
'<a0><bc>\x<65>d<b7><a8>\xed<a0><bc>\xed<b7><b3> https://t.co/0p90p8Rrhu"'
{% endhighlight text %}

If you don't need the emoticons, the most reasonable thing to do is to get rid of them. But given that I wanted to include them in my analysis, I was facing two problems: First, it was difficult to handle the tweets because their format messed up with some functions and lead to error messages. I needed to change their encoding. Second, I couldn't identify the emoticons as the way R encodes them doesn't correspond to their actual UTF-8 encoding. It's a real pain in the neck, especially (but not only) if you're analyzing Paris Hilton's tweets, because she just LOVES her musical notes emoticons ;) The solution that came to my mind was to decode them. 

First things first, I used the `iconv()` function with the following parameters to be able to further handle the tweets. As you can see, the multiple musical notes emoticon `\xF0\x9F\x8E\xB6` now appears as `<ed><a0><bc><ed><be><b6>`. This is an encoding I could work with and this was going to be the basis of the decoder.

{% highlight R %}
tweets2 <- data.frame(text = iconv(tweets$text, "latin1", "ASCII", "byte"), 
                          stringsAsFactors = FALSE)
{% endhighlight R %}
 
{% highlight text %}
## [1] "At sound check last night for the ports1961womenswear After Party. 
<ed><a0><bc><ed><be><b6><ed><a0><bd><ed><b1><b8><ed><a0><bc><ed><bf><bc>
<ed><a0><bc><ed><be><b6> @ Shanghai, China https://t.co/Y9lE9mXjIL"
{% endhighlight text %}

 
## Building an emoticons decoder for R
This is how I did it. 

**1. Scrape the code**
 
The first step consisted of scraping the emoticons, their UTF-8 code and the description from [this website](http://apps.timwhitlock.info/emoji/tables/unicode). I believe this is a more or less full list of them. [Here](https://github.com/today-is-a-good-day/Emoticons/blob/master/scrapeEmoticons.R) is the R code I used to do so. No problem thanks to the [rvest](https://cran.r-project.org/web/packages/rvest/rvest.pdf) package :)

**2. Post code** 
 
Now that I had a list of the emoticons and their codes, I could post them on twitter. I first created a [twitter account](https://twitter.com/remoticons) for this purpose and then posted the emoticons in batches until I reached the rate limit. I continued the procedure the next days until I had posted them all. I used [this code](https://github.com/today-is-a-good-day/Emoticons/blob/master/postEmoticons.R) to post to twitter. 

**3. Retrieve tweets**
 
The third step consisted of retrieving the tweets to get this strange encoding of R for every emoticon on the list. 

**4. Build the decoder**
 
The last step consisted of matching the emoticons list from step 1 with the retrieved emoticons from step 3 based on their description. And ready was my (R)emoticons decoder! It includes the image, UTF-8 code, description and the encoding R gives to every emoticon. You will find the decoder as a csv file [here](https://github.com/today-is-a-good-day/Emoticons/blob/master/emDict.csv). 


With this decoder, I'm finally able to identify and match emoticons retrieved with R from social media. Possible use cases could be to give them a score for sentiment analysis (e.g. +1 for positive emoticons, -1 for negative emoticons or even weighted scores according to their level of positivity and negativity) or to put them into categories for semantic analysis (animals, activities, emotions, etc.). There are no boundaries to your imagination.

**Let me know if you find an easier way to decode emotions in R or to solve this problem!** 

