---
layout: post
title: R in big data pipeline
excerpt: Bring your awesome R research outputs to production
categories: articles
tags: [R, python, data management, big data]
comments: true
share: true
published: true
author: yuki
---

<span class = "dropcap">R</span> is my fabovite tool for research. There are still quite a few things that only R can do or quicker/easier with R.

But unfortunately a lot of people think R becomes less powerful at production stage where you really need to make sure all the functionalities run as you planned against incoming big data.

Personally, what makes R special in the data field is its ability to become friend with many other tools. R can easily ask `JavaScript` for data visualization, `node.js` for interactive web app and data pipeline tools/databases for production ready big data system.

In this post I address how to use R stably combined with other tools in big data pipeline without losing its awesomeness.

## tl;dr
You'll find how to include R into `luigi`, light weight python data workflow management library. You can still use R's awesomeness in complex big data pipeline while handling big data tasks by other appropriate tools.

I'm not covering luigi basics in this post. Please refer to [luigi website](http://luigi.readthedocs.org/en/latest/index.html) if necesary.

## Simple pipeline
Here is a very simple example;

* HiveTask1: Wait for external hive data task (table named "externaljob" partitioned by timestamp)

* RTask: Run awesome R code as soon as pre-aggregation finishes

* HiveTask2: Upload it back to Hive as soon as the above job finishes (table names "awesome" partitioned by timestamp)

and you wanna do this job everyday in an easily debuggable fashion with fancy workflow UI.

That's super easy, just run 
  
```
python awesome.py --HiveTask1-timestamp 2015-08-20
```


This runs `python` file called `awesome.py`. `--HiveTask1-timestamp 2015-08-20` sets 2015-08-20 as timestamp argument in HiveTask1 class.




Yay, all the above tasks are now connected in the luigi task UI!  
Notice our workflow goes from bottom to top.  
You can see there is an error in the very first HiveTask2 but this is just by design.

![luigi-workflow]({{ site.url }}/images/luigi-workflow.png)


## Codes
Let's take a look at `awesome.py`:  

{% highlight python %}
import luigi
from luigi.file import LocalTarget
from luigi.hive import HiveTableTarget
from luigi.contrib.hdfs import HdfsTarget
import subprocess
import sys

class HiveTask1(luigi.ExternalTask):
    timestamp = luigi.DateParameter(is_global=True)
    def output(self):
        return HdfsTarget('/user/storage/externaljob/timestamp=%s' % self.timestamp.strftime('%Y%m%d'))

class RTask(luigi.Task):
    timestamp = HiveTask1.timestamp
    def requires(self):
        return HiveTask1()
    def run(self):
        subprocess.call('Rscript awesome.R %s' % self.timestamp.strftime('%Y%m%d'),shell=True)
    def output(self):
        return LocalTarget('awesome_is_here_%s.txt' % self.timestamp.strftime('%Y%m%d'))

class HiveTask2(luigi.Task):
    timestamp=HiveTask1.timestamp
    def requires(self):
        return RTask()
    def run(self):
        subprocess.call('Rscript update2hive.R %s' % self.timestamp.strftime('%Y%m%d'),shell=True)
    def output(self):
        return HdfsTarget('/user/hive/warehouse/awesome/timestamp=%s' % self.timestamp.strftime('%Y%m%d'))


if __name__ == '__main__':
    luigi.run()
{% endhighlight %}


Basically the file only contains three classes (HiveTask1, RTask and HiveTask2) and their dependency is specified by
{% highlight python %}
def requires(self):
        return TASKNAME
{% endhighlight %}
luigi checks dependencies and outputs of each step so it checks existense of;

- `'/user/storage/externaljob/timestamp=%s' % self.timestamp.strftime('%Y%m%d')`
- `'awesome_is_here_%s.txt' % self.timestamp.strftime('%Y%m%d')`
- `'/user/hive/warehouse/awesome/timestamp=%s' % self.timestamp.strftime('%Y%m%d')`

The most important thing here is using python's subprocess module with `shell=True`, so you can run your R file
{% highlight python %}
def run(self):
        subprocess.call('Rscript YOUR_R_FILE',shell=True)
{% endhighlight %}

The timestamp argument you gave at the very beginning is stored as global variable `timestamp` (well, this is not necessarily the coolest option)
{% highlight python %}
timestamp = luigi.DateParameter(is_global=True)
{% endhighlight %}
and can be used in other tasks by
{% highlight python %}
timestamp = HiveTask1.timestamp
{% endhighlight %}
Moreover, you can pass `timestamp` to R file by
{% highlight python %}
'Rscript awesome.R %s' % self.timestamp.strftime('%Y%m%d')
{% endhighlight %}


Then let's take a look at awesome.R
{% highlight r %}
library(infuser)
args <- commandArgs(TRUE)
X <- as.character(args[1])
timestamp <- format(as.Date(X,"%Y-%m-%d"),"%Y%m%d")

DO AWESOME THINGS

write.csv(YOUREAWESOME,file=paste0('awesome_is_here_',timestamp,'.txt'),row.names=F)
{% endhighlight %}

In R side, you can receive `timestamp` argument you passed from python by
{% highlight r %}
args <- commandArgs(TRUE)
X <- as.character(args[1])
{% endhighlight %}

Similarly, `update2hive.R` can look like
{% highlight r %}
library(infuser)
args <- commandArgs(TRUE)
X <- as.character(args[1])
temp <- list.files(pattern='TEMPLATE.hql')
Q <- infuse(temp, timestamp=timestamp,verbose=T)
fileConn<-file("FINALHQL.hql")
writeLines(Q, fileConn)
close(fileConn)
system('hive -f FINALHQL.hql')
#this file updates 
{% endhighlight %}


One last thing you might like to do is to set a cronjob.

```
0 1 * * * python awesome.py --HiveTask1-timestamp `date --date='+1 days' +\%Y-\%m-\%d`
```

This one for example runs the whole thing at 1 a.m everyday.

## Conclusion

In this post I've shown simple example of how to quickly convert your research R project into solid deployable product.
This is not limited to simple R-hive integration but you can let R, spark, databases, stan/bugs, H2O, vowpal wabbit and millions of other data tools dance together as you wish. and you'll recognize R still plays a central role in the play.

## Codes
The full codes are available from [here](https://github.com/yukiegosapporo/2015-08-16-r-in-big-data-pipeline).
