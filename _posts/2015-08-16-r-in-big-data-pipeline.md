---
layout: post
title: R in big data pipeline
excerpt: Bring your awesome R research outputs to production
categories: articles
tags: [R, python, luigi, big data]
comments: true
share: true
published: true
author: yuki
---

<span class = "dropcap">R</span> is still my fabovite tool for research. There are still quite a few things that only R can do or quicker/easier with R.

But unfortunately R becomes less powerful at production stage where you really need to make sure all the functionalities run as you planned against incoming big data.

{% highlight R %} library(ggplot2) hour_plot <- ggplot(df, aes(x = factor(hour), y = value, fill = period)) + geom_bar(stat = "identity", position = "dodge") hour_plot {% endhighlight %}

In this post I address how to use R stably in big data pipeline without introducing .


with `summarise`, I was like, what?
Turns out this actually *is* a thing. Let me show the example from the [dplyr introduction](https://cran.rstudio.com/web/packages/dplyr/vignettes/introduction.html):
