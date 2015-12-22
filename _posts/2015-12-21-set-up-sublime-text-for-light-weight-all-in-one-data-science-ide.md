---
layout: post
title: Set up Sublime Text for light-weight all-in-one data science IDE for OS X
excerpt: R, Python, Scala, Spark on remote and local
categories: articles
tags: [R, Spark, Python, Hadoop, Scala, Sublime Text, Hive]
comments: true
share: true
published: false 
author: yuki
---

# tl;dr

Sublimerepl extended for SSH remote R, Python, Scala, Spark, Hive, you name it (and this is only tested for OS X).  
The example below interprets local Python (top), R (middle) and Hive (bottom) code on remote.

![sublimedemo]({{ site.url }}/images/sublimedemo.gif)


# IDE for everything

Good IDEs are everywhere. RStudio for R, Pycharm for Python, IntelliJ for Scala. It seems like there's no need for any more but this is for lazy data nerds who want to work on everything. Everything from hadoop ETL, Spark machine learning, R Shiny dashboard making to html/css editing in one IDE.  


The setup is heavily based on the following two packages  

- [SublimeREPL](https://github.com/wuub/SublimeREPL)  
enables REPL inside Sublime Text

- [origami](https://github.com/SublimeText/Origami).  
adds flexible pane layout

When you have them installed, the only thing you need to do is to add new SublimeREPL config.

# Add custom SublimeREPL config

First thing you need to do is to find out SublimeREPL config file location. Most probably you can find it by **Sublime Text** tab, **Preferences**, **Brouse Packages**, **SublimeREPL**, then **config** (I use OS X 10.10.5).

As an example, we are going through **remote_R** sublime interepreter config.  

{% highlight sh %}
cd YOURSUBLIMEREPLCONFIGFOLDER  
cp -r R remote_R #This will create remote_R folder  
cd remote_R #Go to remote_R  
open . #Open the folder
{% endhighlight %}

You'll find two files on the folder.  
Now we are going to give SublimeREPL access to your remote R (I assume you can SSH to your remote).
Edit the files as explained below.

**If you copy & paste the below code, don't forget to delete #CHANGE blah blah comment. JSON doesn't accep comments**

**Main.sublime-menu**

{% highlight json %}
[
     {
        "id": "tools",
        "children":
        [{
            "caption": "SublimeREPL",
            "mnemonic": "R",
            "id": "SublimeREPL",
            "children":
            [
                {"command": "repl_open",
                 "caption": "remote_R", #CHANGE
                 "id": "repl_remote_r", #CHANGE
                 "mnemonic": "R",
                 "args": {
                    "type": "subprocess",
                    "external_id": "r",
                    "additional_scopes": ["tex.latex.knitr"],
                    "encoding": {
                        "windows": "$win_cmd_encoding",
                        "linux": "utf8",
                        "osx": "utf8"
                        },
                    "soft_quit": "\nquit(save=\"no\")\n",
                    "cmd": {"linux": ["R", "--interactive", "--no-readline"],
                            "osx": ["ssh","REMOTENAME","R", "--interactive", "--no-readline"], # CHANGE (lunux and windows not tested)
                            "windows": ["Rterm.exe", "--ess", "--encoding=$win_cmd_encoding"]},
                    "cwd": "$file_path",
                    "extend_env": {"osx": {"PATH": "{PATH}:/usr/local/bin"},
                                   "linux": {"PATH": "{PATH}:/usr/local/bin"},
                                   "windows": {}},
                    "cmd_postfix": "\n",
                    "suppress_echo": {"osx": true,
                                      "linux": true,
                                      "windows": false},
                    "syntax": "Packages/R/R Console.tmLanguage"
                    }
                }
            ]
        }]
    }
]

{% endhighlight %}

**Default.sublime-commands**
{% highlight json %}
[
    {
        "caption": "SublimeREPL: remote_R", #CHANGE
        "command": "run_existing_window_command", "args":
        {
            "id": "repl_remote_r", #CHANGE
            "file": "config/remote_R/Main.sublime-menu" #CHANGE
        }
    }
]
{% endhighlight %}

Now you should see new **remote_R** added to your SublimeREPL if you search remote_R in Command Palette (default key binding is command + shift + p)  
![remoter]({{ site.url }}/images/remoter.png)


# Code and little more hack
The above example is only to add remote R but basically the same procedure to add Python, Scala, Spark, Hive, Impala and technically anything on remote.  
You might need to do a little trick in some cases so I also added config for Python and Hive to my github page as an example.

The full codes are available from [here](https://github.com/yukiegosapporo/2015-12-21-set-up-sublime-text-for-light-weight-all-in-one-data-science-ide).
