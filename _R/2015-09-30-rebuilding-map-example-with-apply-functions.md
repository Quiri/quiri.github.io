---
layout: post
title: Rebuilding Map Example With Apply Functions
modified:
categories: articles
excerpt: First look at purrr package
tags: [R, purrr]
published: true
comments: true
author: kirill
image:
  feature:
  credit:
  creditlink:
share: true
date: 2015-09-30T11:10:16+02:00
---

<span class = "dropcap">Y</span>esterday Hadley's functional programming package [purrr](https://github.com/hadley/purrr) was published to [CRAN](https://cran.r-project.org/web/packages/purrr/index.html). It is designed to bring convenient functional programming paradigma and add another data manipulation framework for R.

>"Where dplyr focusses on data frames, purrr focusses on vectors" -- Hadley Wickham in a [blogpost](http://blog.rstudio.org/2015/09/29/purrr-0-1-0/)

The core of the package consists of map functions, which operate similar to base apply functions. So I tried to rebuild the first example used to present the map function in the [blog](http://blog.rstudio.org/2015/09/29/purrr-0-1-0/) and [Github repo](https://github.com/hadley/purrr) with apply. The example looks like this:


{% highlight r %}
library(purrr)

mtcars %>%
  split(.$cyl) %>%
  map(~ lm(mpg ~ wt, data = .)) %>%
  map(summary) %>%
  map_dbl("r.squared")
{% endhighlight %}



{% highlight text %}
##         4         6         8 
## 0.5086326 0.4645102 0.4229655
{% endhighlight %}

Let's do it with apply now:


{% highlight r %}
mtcars %>% 
  split(.$cyl) %>% 
  lapply(function(x) lm(mpg~wt, data = x)) %>% 
  lapply(summary) %>% 
  sapply(function(x) x$r.squared)
{% endhighlight %}



{% highlight text %}
##         4         6         8 
## 0.5086326 0.4645102 0.4229655
{% endhighlight %}

As you can see, map works with 3 different inputs - function names (exactly like apply), anonymous function as formula and character to select elements. Apply on the other hand only accepts functions, but with a little piping voodoo we can also shortcut the anonymous functions like this:


{% highlight r %}
mtcars %>% 
  split(.$cyl) %>% 
  lapply(. %>% lm(mpg~wt, data = .)) %>% 
  lapply(summary) %>% 
  sapply(. %>% .$r.squared)
{% endhighlight %}



{% highlight text %}
##         4         6         8 
## 0.5086326 0.4645102 0.4229655
{% endhighlight %}

Which is almost as appealing as the map alternative. Checking the speed of both approaches also reveals no significant time differences:


{% highlight r %}
library(microbenchmark)

map <- function() {mtcars %>% split(.$cyl) %>% map(~ lm(mpg ~ wt, data = .)) %>% map(summary) %>% map_dbl("r.squared")}
apply <- function() {mtcars %>% split(.$cyl) %>% lapply(. %>% lm(mpg~wt, data = .)) %>% lapply(summary) %>% sapply(. %>% .$r.squared)}

microbenchmark(map, apply)
{% endhighlight %}



{% highlight text %}
## Unit: nanoseconds
##   expr min lq   mean median uq   max neval
##    map  14 27  31.69     27 27   513   100
##  apply  14 27 281.34     27 27 24556   100
{% endhighlight %}

Now don't get me wrong, I don't want to say, that purrr is worthless or reduntant. I just picked the most basic function of the package and explained what it does by rewriting with apply functions. The map function and their derivatives are convenient alternatives to apply in my eyes without computational overhead. Furthermore the package offers very interesting functions like `zip_n` and `lift`. If you love apply and word with lists, you definitely should check out `purrr`.
