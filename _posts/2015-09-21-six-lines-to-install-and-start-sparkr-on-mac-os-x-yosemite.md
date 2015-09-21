---
layout: post
title: Six lines to install and start SparkR on Mac OS X Yosemite
excerpt: for both  and command line
categories: articles
tags: [R, Spark, SparkR, Hadoop, big data]
comments: true
share: true
published: true
author: yuki
---

<span class = "dropcap">I</span> know there are many R users who like to test out SparkR without all the configuration hassle. Just these six lines and you can start SparkR from both RStudio and command line. 

![luigi-workflow]({{ site.url }}/images/spark-logo.png)


# One line for Spark and SparkR for each

> Apache Spark is a fast and general-purpose cluster computing system

and


> SparkR is an R package that provides a light-weight frontend to use Apache Spark from R

# Six lines to start SparkR
The first three lines should be called in your command line.
{% highlight sh %}
brew update # If you don't have homebrew, get it from here (http://brew.sh/)
brew install hadoop # Install Hadoop
brew install apache-spark # Install Spark
{% endhighlight %}

You can already start SparkR shell by typing this in your command line;

```
SparkR
```

If you like to call it from RStudio, execute the rest in R
{% highlight r %}
spark_path <- strsplit(system("brew info apache-spark",intern=T)[4],' ')[[1]][1] # Get your spark path
.libPaths(c(file.path(spark_path,"libexec", "R", "lib"), .libPaths())) # Navigate to SparkR folder
library(SparkR) # Load the library
{% endhighlight %}

That's all.  
Now this should run in your RStudio
{% highlight r %}
sc <- sparkR.init()
sqlContext <- sparkRSQL.init(sc)
df <- createDataFrame(sqlContext, iris) 
head(df)
{% endhighlight %}

{% highlight text %}
# Sepal_Length Sepal_Width Petal_Length Petal_Width Species
# 1          5.1         3.5          1.4         0.2  setosa
# 2          4.9         3.0          1.4         0.2  setosa
# 3          4.7         3.2          1.3         0.2  setosa
# 4          4.6         3.1          1.5         0.2  setosa
# 5          5.0         3.6          1.4         0.2  setosa
# 6          5.4         3.9          1.7         0.4  setosa
{% endhighlight %}
Enjoy!

## Codes
The full codes are available from [here](https://github.com/yukiegosapporo/2015-09-21-six-lines-to-install-and-start-sparkr-on-mac-os-x-yosemite).
