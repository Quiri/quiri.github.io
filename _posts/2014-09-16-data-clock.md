---
layout: post
title: Rock around the data clock
excerpt:
date: 2014-10-21 20:25:13.000000000 +02:00
categories: articles
tags: [R]
type: post
published: true
comments: true
share: true
author: kirill
---

<span class = "dropcap">I</span> had to visualize an hourly distribution of some KPI (assume logins / registrations / purchases per hour), so the idea was, why not build a clock? It's a nice and intuitive way to present this data. The problem is, that the clock has only 12 hours which are used twice a day, so I will have to assign two data points to every "hour" (am/pm). So assume our data is something like this:

{% highlight R %}
df <- expand.grid(hour = c(12,1:11), period = c("am", "pm"))
df$value <- dnorm(c(seq(0.6,1.1,0.1),seq(-1.1,0.6,0.1)) ,0,0.5)
{% endhighlight %}

So with [ggplot](http://ggplot2.org/) we can start with some bar plots:

{% highlight R %}
library(ggplot2)
hour_plot <- ggplot(df, aes(x = factor(hour), y = value, fill = period)) +
  geom_bar(stat = "identity", position = "dodge")
hour_plot
{% endhighlight %}

![bars_only]({{ site.url }}/images/bars_only-1024x365.png)

Neat, but doesn't look like a clock to me, so let's change the coordinates to polar:

{% highlight R %}
hour_plot <- hour_plot + coord_polar(theta = "x")
hour_plot
{% endhighlight %}

![hour_ugly]({{ site.url }}/images/hour_ugly-1024x826.png)

Well, better, looks like a clock, but won't win any beauty contests. Let's skew it and remove some junk.

{% highlight R %}
hour_plot <- hour_plot + coord_polar(theta = "x", start = 0.26)+
 xlab("")+ylab("")+
 theme(axis.ticks = element_blank(), axis.text.y = element_blank(), 
 panel.background = element_blank(), panel.grid.major.x = element_line(colour="grey"),
 axis.text.x = element_text(size = 25), legend.title=element_blank())
hour_plot
{% endhighlight %}

![hour_better]({{ site.url }}/images/hour_better-e1410863358284-1024x881.png)

Nice! That's the data clock. From a design and readability point of view the transition from a.m to p.m (left bar to right bar) and p.m. to a.m. (right bar to left bar) at 11-12 o'clock could be misleading or counterintuitive. My suggestion here is to guide the viewer with color transitions, instead of binary a.m./ p.m. (red / blue) colors. One way to do this is by adding a new variable to the data, to which we then can bind our color to.

{% highlight R %}
df$fill <- c(1:13,12:2)
{% endhighlight %}

Now we have to adjust the aesthetics of ggplot a bit and we're done.

{% highlight R %}
hour_plot <- ggplot(df, aes(x = factor(hour), y = value, fill =fill, group = period))+
 geom_bar(stat = "identity", position = "dodge")+
 coord_polar(theta = "x", start = 0.26)+
 xlab("")+ylab("")+
 theme(axis.ticks = element_blank(), axis.text.y = element_blank(), 
 panel.background = element_blank(), panel.grid.major.x = element_line(colour="grey"),
 axis.text.x = element_text(size = 25), legend.title=element_blank())
hour_plot
{% endhighlight %}

![hour_even_better]({{ site.url }}/images/hour_even_better-e1410865953526-1024x885.png)

Delete the useless legend et voilà!

{% highlight R %}
hour_plot <- hour_plot + guides(fill=FALSE)
{% endhighlight %}

![hour_best]({{ site.url }}/images/hour_best-e1410865915965-1024x912.png)

One has to mention, that p.m. is on the right side and a.m. is on the left. Sure, it's still not perfect, because the transition between a.m./p.m. is still rough, so I would be delighted to read your suggestions for improvement in the comments ;) 
