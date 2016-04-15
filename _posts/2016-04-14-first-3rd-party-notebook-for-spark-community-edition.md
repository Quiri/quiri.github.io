---
layout: post
title: First 3rd party notebook for Databricks Community Edition
categories: articles
excerpt: "Golden State Warriors pass analysis"
tags: [Python, Spark, GraphX, GraphFrames, scala, networkD3, Databricks Community Edition]
published: false
comments: true
author: yuki
share: true
date: 2016-04-14T15:00:00+02:00
---


# GSW on Databricks Community Edition

<span class = "dropcap">I</span>'m happy to announce that [__my analysis about Golden State Warriors passing network__](https://docs.cloud.databricks.com/docs/latest/sample_applications/index.html#Sample%20Analysis/GraphFrame%20based%20Analysis%20(new)/GSW%20Passing%20Analysis.html) is featured as the first 3rd party notebook to [__Databricks Community Edition__](http://go.databricks.com/databricks-community-edition-beta-waitlist) in the [__latest databricks blog post__](https://databricks.com/blog/2016/04/12/new-content-in-databricks-community-edition.html).  


![sublimedemo]({{ site.url }}/images/dce.gif)

Databricks Community Edition is 

> a free version of the Databricks service that allows everyone to learn and explore Spark by providing a simple, integrated development environment for data scientists and engineers with high quality training materials and sample applications.

The notebook is based on [__my previous post__](http://opiateforthemass.es/articles/analyzing-golden-state-warriors-passing-network-using-graphframes-in-spark/) and this time utilizes some great functionalities of Databricks Community Edition including:

- Free 6GB clusters on AWS
- Interactive workspace
- GraphFrames library
- Data registration as a SQL table
- D3 visualization
- Multiple language support

in a single notebook!

I personally found Databricks Community Edition is a graet platform to test your ideas easily without cluster management hassle and cloud cost.  

If you want to try this out, you can join the waiting list from [here](http://go.databricks.com/databricks-community-edition-beta-waitlist).

