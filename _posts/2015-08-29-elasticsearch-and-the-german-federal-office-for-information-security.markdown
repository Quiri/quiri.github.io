---
layout: post
title: Elasticsearch & the German Federal Office for Information Security
modified:
categories: articles
excerpt:
tags: []
published: false
comments: true
author: jess
image:
  feature:
  credit:
  creditlink:
share: true
date: 2015-08-29T18:36:05+02:00
---

<span class = "dropcap">T</span>o me, coding has always been trial and error. And by trial and error, I mean a considerable amount of errors. Today, I would like to share with you one of the mistakes I made when seting up Elasticsearch and how I solved it. This one is particularly remarcable because I got an email from the german Federal Office for Information Security (sounds scary, huh?) which totally freaked me out in the beginning and turned out to be just a friendly remainder at the end of the day.

## Short story long
So, I´ve been working on seting up my server to run an R code that would basically open up a twitter stream and have the tweets stored into a database. I choose Elasticsearch for that purpose because it came in handy in combination with Logstash, which parses the tweets in order to push them into the database. And Kibana, the super good looking user interface for my Elasticsearch database, didn´t hurt either ;) Many use Elasticsearch, Logstash and Kibana as a trio, have a look at their [website](https://www.elastic.co/de/) for further information. 
 
Elasticsearch per default comes with no security settings at all, as the whole config file consists of a bunch of comments. **If you just plan to play around with Elasticsearch, it´s perfectly fine to keep the default settings, but if you´re serious about it, you definitely need to secure it properly.** 
 
Because if you don´t and if you happen to have a server based in Germany, sooner rather than later you´ll get an abuse notification from the german Federal Office for Information Security. Take that.
While in the US the first though when confronted to new apps, webapps and other services seems to be "Awesome! It´ll be so much fun to try it out!", in Germany things are different. The first though on a German´s mind is rather "Holy crap, how about data privacy? Where are their servers hosted? Do they moneterize my data?". Anyways, it took their bot a couple of hours to figure out that my Elasticsearch had a potential security flaw. I´ve spent the next couple of hours panicking about my server´s security and trying to find out if someone had hacked it by studying an insane amount of logs. It was so much fun! Not. 

![No fun at all](http://i.imgur.com/Dz3nk.jpg)
{: .center}

Buttom line here is that the german Federal Office for Information Security takes its job seriously and seems to have a service that automatically detects potential security gaps. Thank you guys for the friendly remainder! I keep on thinking it should not be named "abuse notification", though.
 
## Where you should start
Once you have Elasticsearch installed, open the elasticsearch.yml file in an editor (on my server it´s located under /etc/elasticsearch/) and scroll down to the Network And HTTP-section. You´ll see that per default, Elasticsearch binds itself to the 0.0.0.0 ip address which can be a security concern. You can uncomment the `network.host` variable and change the value to either localhost or 127.0.0.1 or whatever other address your localhost maps to. I prefer the second one as one can change their localhost to map to other addresses. So, the setting in question would look like this: `network.host: 127.0.0.1`.
 
If you´re using Elasticsearch together with Logstash, don´t forget to change your Logstash config file, too! The output part should look something like that: 

{% highlight ruby %}
output {
    elasticsearch {
        bind_host => "127.0.0.1"
        index => "whatever"
        document_type => "whatever"
    }
}
{% endhighlight %}
 
Note: bindhost is what does the magic here. 

Also, if you´re using Elasticsearch as a service, don´t forget to restart it with:

{% highlight bash %}
sudo service elasticsearch restart
{% endhighlight %}

to make sure it´s using the new setting. 
 
 
I´m wondering: Is there another country providing such a security service to their citizens?
