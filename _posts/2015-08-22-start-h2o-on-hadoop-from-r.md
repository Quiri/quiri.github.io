---
layout: post
title: Ofuro, start H2O on Hadoop from R
excerpt: and stop and clean it up afterward
categories: articles
tags: [R, H2O, machine learning, big data]
comments: true
share: true
published: true
author: yuki
---

## tl;dr
I made a simple functionality to start H2O on hadoop from R.
You can easily start H2O on hadoop, run your analytics and close all the processes without occuppying Hadoop nodes and memory all the time.

<hr>
<span class = "dropcap">I </span> like to take a bath. Fill a bath and warm up in there is a perfect refreshment after a hard working day. I like it so much so I decided to do it even at work. I'm running `H2O` in the huge bathtub called `hadoop`. I'm lazy to do any hadoop side setting (and don't wanna bother my super data engineer team), but I wanted to have a button that starts and finishes everything from R. Now I have it and name it `ofuro`, bathing in Japanese, which starts H2O on hadoop from R and finishes it after your awesome works.

![ofuro]({{ site.url }}/images/ofuro.jpg)


## H2O
`H2O` is a big data machine learning platform. `H2O` can easily cook big data that R or Python can't and provides many machine learning solutions like neural network, GBM and random forest. There is a standalone version and an on-hadoop one if you like to crunch hundreds of gigabytes. And this is easily controlable from R or Python through an API.

The download is super easy. Get the right one for your system from [here](http://h2o.ai/download/) and follow the instructions.

## Starting H2O
Starting H2O standalone version is just one line.
```h2o.init()```

But starting it on hadoop is a bit tricky and currently there doesn't seem to be a one click solution.
In my case, presumably the same for many data scientists, hadoop is a shared asset at work and it's not cool to keep it running and occupy nodes.
But no worries, the snippet below is everything you need!

## Ofuro
{% highlight r %}
system("
  cd YOUR_H2O_DIRECTORY/h2o-3.1.0.3098-cdh5.4.2 # Your H2O version should be different
  hadoop jar h2odriver.jar -output h2o -timeout 6000 > YOUR_WORKING_DIR/h2o_msg.txt
",wait=F) 

#timeout: timeout duration. See here for more H2O parameters

h2o_ip <- NA; h2o_port <- NA
while(is.na(h2o_ip)&is.na(h2o_port)){
f <- tryCatch(read.table('h2o_msg.txt',header=F,sep='\n'),error = function(c) data.table(NA))
firstNode <- as.character(f[grep('H2O node',f$V1),][1])
firstNodeSplit <- strsplit(firstNode,' ')[[1]][3]
h2o_ip <- strsplit(firstNodeSplit,':')[[1]][1]
h2o_port <- as.numeric(strsplit(firstNodeSplit,':')[[1]][2])
}
h2o = h2o.init(ip=h2o_ip,port=h2o_port,startH2O=F)

YOUR_AWESOME_H2O_JOBS

applicationNo <- strsplit(as.character(f[grep('application_',f$V1),]),' ')[[1]][10]
system(paste0('yarn application -kill ',applicationNo))
system('hadoop fs -rm -r h2o')
system('rm YOUR_WORKING_DIR/h2o_msg.txt')
{% endhighlight %}


This is basically three-parter codes.

### Chunk 1
{% highlight r %}
system("
cd YOUR_H2O_DIRECTORY/h2o-3.1.0.3098-cdh5.4.2 # Your H2O version should be different
hadoop jar h2odriver.jar -output h2o -timeout 6000 > YOUR_WORKING_DIR/h2o_msg.txt
",wait=F) 
#timeout: timeout duration. See here for more H2O parameters
{% endhighlight %}

This just goes to your H2O folder and starts H2O server on hadoop.
Make sure to change `YOUR_H2O_DIRECTORY`,`h2o-3.1.0.3098-cdh5.4.2` and `YOUR_WORKING_DIR` to appropriate ones.

`system('COMMAND_LINE_CODE',wait=F)` runs your COMMAND_LINE_CODE without waiting for the results. So you can basically do something else before your bath is ready.
All the server log is stored in `YOUR_WORKING_DIR/h2o_msg.txt`

My `h2o_msg.txt` looks like this (and yours should look different)
  
>Determining driver host interface for mapper->driver callback...  
>    [Possible callback IP address: 148.251.41.166]  
>    [Possible callback IP address: 127.0.0.1]  
>Using mapper->driver callback IP address and port: 148.251.41.166:26129  
>(You can override these with -driverif and -driverport.)  
>Memory Settings:  
>    mapreduce.map.java.opts:     -Xms60g -Xmx60g -Dlog4j.defaultInitOverride=true  
>    Extra memory percent:        10  
>    mapreduce.map.memory.mb:     67584  
>Job name 'H2O_10763' submitted  
>JobTracker job ID is 'job_1439400060928_7854'  
>For YARN users, logs command is 'yarn logs -applicationId application_1439400060928_7854'  
>Waiting for H2O cluster to come up...  
>H2O node 172.22.60.96:54321 requested flatfile  
>H2O node 172.22.60.93:54321 requested flatfile  
>H2O node 172.22.60.92:54321 requested flatfile  
>H2O node 172.22.60.94:54321 requested flatfile  
>Sending flatfiles to nodes...  
>    [Sending flatfile to node 172.22.60.96:54321]  
>    [Sending flatfile to node 172.22.60.93:54321]  
>    [Sending flatfile to node 172.22.60.92:54321]  
>    [Sending flatfile to node 172.22.60.94:54321]  
>H2O node 172.22.60.96:54321 reports H2O cluster size 1  
>H2O node 172.22.60.94:54321 reports H2O cluster size 1  
>H2O node 172.22.60.93:54321 reports H2O cluster size 1  
>H2O node 172.22.60.92:54321 reports H2O cluster size 1  
>H2O node 172.22.60.94:54321 reports H2O cluster size 4  
>H2O node 172.22.60.96:54321 reports H2O cluster size 4  
>H2O node 172.22.60.92:54321 reports H2O cluster size 4  
>H2O node 172.22.60.93:54321 reports H2O cluster size 4  
>H2O cluster (4 nodes) is up  
>(Note: Use the -disown option to exit the driver after cluster formation)  
>Open H2O Flow in your web browser: http://172.22.60.93:54321  
>(Press Ctrl-C to kill the cluster)  
>Blocking until the H2O cluster shuts down...


### Chunk 2
{% highlight r %}
h2o_ip <- NA; h2o_port <- NA
while(is.na(h2o_ip)&is.na(h2o_port)){
f <- tryCatch(read.table('h2o_msg.txt',header=F,sep='\n'),error = function(c) data.table(NA))
firstNode <- as.character(f[grep('H2O node',f$V1),][1])
firstNodeSplit <- strsplit(firstNode,' ')[[1]][3]
h2o_ip <- strsplit(firstNodeSplit,':')[[1]][1]
h2o_port <- as.numeric(strsplit(firstNodeSplit,':')[[1]][2])
}
h2o = h2o.init(ip=h2o_ip,port=h2o_port,startH2O=F)
{% endhighlight %}

Chunk 2 iterates a `while` loop till it reaches the first H2O node and get its IP and port.
This captures the very first one of randomly allocated IPs and ports so R knows where to connect.

### Chunk 3
{% highlight r %}
applicationNo <- strsplit(as.character(f[grep('application_',f$V1),]),' ')[[1]][10]
system(paste0('yarn application -kill ',applicationNo))
system('hadoop fs -rm -r h2o')
system('rm YOUR_WORKING_DIR/h2o_msg.txt')
{% endhighlight %}

Chunk 3 does let the water out of your bath and clean it. 
`yarn application -kill ` may vary depending on your system.
This also deletes h2o hdfs derectory and h2o_msg.txt for the next time.

### Codes
The full codes are available from [here](https://github.com/yukiegosapporo/2015-08-22-start-h2o-on-hadoop-from-r) 
