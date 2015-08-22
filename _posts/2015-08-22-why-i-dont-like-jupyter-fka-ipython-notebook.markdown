---
layout: post
title: Why I Don't Like Jupyter (FKA IPython Notebook)
modified:
categories: article
excerpt: 
tags: []
published: false
comment: true
author:
image:
  feature:
  credit:
  creditlink:
share: true
date: 2015-08-22T16:30:21+02:00
---


<span class = "dropcap">D</span>on't get me wrong, it's certainly a great tool for presenting your code or even reporting, but everytime I use it for explorative, interactive data science, I keep switching to other tools quite quickly and wonder why I am still even trying to use it. I just mostly end up with messy, broken, "un*git*able" and unreadable analyses and I refuse to accept that this is my fault, but rather believe it is caused by the design of Jupyter/IPython.

#### It messes with your version control.

The Jupyter Notebook format it just a big json, which contains your code and the outputs of the code. Thus version control is difficult, because every time you make minimal changes to the code or rerun it with updated data, you will have to commit the code and all new results or outputs of it. This will unnecessarily blow up your repos used disk memory and make the diffs difficult to read (which would give a whole new meaning to the abbreviation *diff*). Yeah, I know, you also can export your code to a script (in my case .R script with the code), but then, why the overhead of using the code in two formats?
  
### Code can only be run in chunks.
	

