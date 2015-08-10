---
layout: post
title: "Peeling of group layers."
excerpt: "Pay attention with group_by and summarise"
categories: articles
tags: [R, dplyr, data manipulation]
comments: false
share: true
published: true
author: "kirill"
modified: 2015-08-07
---

<span class = "dropcap">A</span>s an experienced dplyr user since almost day one, I thought I knew almost every aspect of it. But when my new colleague, who is learning dplyr from scratch, asked me to explain the peeling of group layers with `summarise`, I was like, what?
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

Pay atttention, that the newly generated data.frame is only grouped by `year` and `month` only, not by `date` anymore, which is effect of the forementioned peeling. The idea is, that if you want to aggregate your data further, in most cases you would aggregate it with one layer off, because you already exploited the initial grouping already.

So if want to calculate the amount of flights per month and year and then per year, you don't have to regroup anymore.


{% highlight r %}
monthly <- daily %>% 
  summarise(flights = sum(flights))
monthly
{% endhighlight %}



{% highlight text %}
## Source: local data frame [12 x 3]
## Groups: year
## 
##    year month flights
## 1  2013     1   27004
## 2  2013     2   24951
## 3  2013     3   28834
## 4  2013     4   28330
## 5  2013     5   28796
## 6  2013     6   28243
## 7  2013     7   29425
## 8  2013     8   29327
## 9  2013     9   27574
## 10 2013    10   28889
## 11 2013    11   27268
## 12 2013    12   28135
{% endhighlight %}

And finally:

{% highlight r %}
yearly <- monthly %>% 
  summarise(flights = sum(flights))
yearly
{% endhighlight %}



{% highlight text %}
## Source: local data frame [1 x 2]
## 
##   year flights
## 1 2013  336776
{% endhighlight %}

How does dplyr determine which layer to peel off? Well it seems to depend of the order of the groups:


{% highlight r %}
daily <- flights %>% 
  group_by(day, month, year) %>%
  summarise(flights = n())
daily
{% endhighlight %}



{% highlight text %}
## Source: local data frame [365 x 4]
## Groups: day, month
## 
##    day month year flights
## 1    1     1 2013     842
## 2    1     2 2013     926
## 3    1     3 2013     958
## 4    1     4 2013     970
## 5    1     5 2013     964
## 6    1     6 2013     754
## 7    1     7 2013     966
## 8    1     8 2013    1000
## 9    1     9 2013     718
## 10   1    10 2013     965
## .. ...   ...  ...     ...
{% endhighlight %}

This produces the same results like in the first daily computation, but obviously now year got peeled off.

Although it might help you write code faster (by saving you a group_by-clause) it deteriorates readability, in my humble opinion. Or would you directly know what to expect from this code, which is just the summary of the ones above:


{% highlight r %}
result <- flights %>% 
  group_by(year, month, day) %>%
  summarise(flights = n()) %>%
  summarise(flights = sum(flights)) %>%
  summarise(flights = sum(flights))
result
{% endhighlight %}



{% highlight text %}
## Source: local data frame [1 x 2]
## 
##   year flights
## 1 2013  336776
{% endhighlight %}

To understand the result, you have to count the peeled off layers, and see which ones are affected. You can't simple rely on the `group_by` anymore, while reading the code. Now imagine you are reviewing code or looking at old code of yours. Everytime you see a wild `summarise` without a directly preceeding `group_by` you will have to go through the whole code looking for the previous `group_by` and then search all `summarise` statement and count the peeling. ![Peeling onions]({{ site.url }}/images/spencer-peeling-onions.jpg)
{: .pull-right}
*Peeling of onions isn't fun either. Lilly Martin Spencer, Peeling Onions, ca. 1852.*

While it might be a convenient behaviour for quick and dirty analysis, I would not use it in production code and my best practice is to always explicitly use a `group_by` statement right before a `summarise`. Keeping in mind that the behaviour of `group_by` already changed from adding groups to overiding groups completely in dplyr 2.0, safest thing you can do is even to add an `ungroup` statement right before grouping.

Another problem is that some user might not be aware of this behaviour (I wasn't, therefore the blog post) and might be surprised by the somewhat counterintuitive results.

So be aware with this behaviour and you can keep on enjoying dplyr!
