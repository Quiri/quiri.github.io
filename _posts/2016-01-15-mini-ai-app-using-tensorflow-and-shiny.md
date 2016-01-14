---
layout: post
title: Mini AI app using TensorFlow and Shiny
categories: articles
excerpt: "Image recognition and wordcloud"
tags: [R, Shiny, Image recognition, TensorFlow, AI]
published: true
comments: true
author: yuki
share: true
date: 2016-01-15T06:00:00+02:00
---

# tr;dr

<span class = "dropcap">S</span>imple image recognition app using TensorFlow and Shiny

![image_recognition_demo]({{ site.url }}/images/image_recognition_demo.gif)

# About
My weekend was full of deep learning and AI programming so as a milestone I made a simple image recognition app that:  

- Takes an image input uploaded to Shiny UI  
- Performs image recognition using TensorFlow  
- Plots detected objects and scores in wordcloud  

# App
This app is to demonstrate powerful image recognition functionality using [TensorFlow](https://www.tensorflow.org/) following the first half of [this tutorial](https://www.tensorflow.org/versions/master/tutorials/image_recognition/index.html).  
In the backend a pretrained **classify_image.py** is running, with the model being pretrained by *tensorflow.org*.  
This Python file takes a jpg/jpeg file as an input and performs image classifications.  

I will then use R to handle the classification results and produce wordcloud based on detected objects and their scores.  


# Requirements
The app is based on R (shiny and wordcloud packages), Python 2.7 (tensorflow, six and numpy packages) and TensorFlow (Tensorflow itself and [this python file](https://github.com/tensorflow/tensorflow/blob/master/tensorflow/models/image/imagenet/classify_image.py)).  
Please make sure that you have all the above packages installed. For help installing TensorFlow [this link](https://www.tensorflow.org/versions/master/get_started/os_setup.html#download-and-setup) should be helpful.

# Structure
Just like a usual Shiny app, you only need two components; `server.R` and `ui.R` in it.  
This is optional but you can change number of objects in the image recognition output by changing [the line 63 of classify_image.py](https://github.com/tensorflow/tensorflow/blob/master/tensorflow/models/image/imagenet/classify_image.py#L63)

{% highlight python %}
tf.app.flags.DEFINE_integer('num_top_predictions', 5#I changed this to 10,
                            """Display this many predictions.""")
{% endhighlight %}

 
 

## server.R

I put comments on almost every line in server.R so you can follow the logic more easily.  

{% highlight r %}
library(wordcloud)
shinyServer(function(input, output) {
    PYTHONPATH <- "path/to/your/python"  #should look like /Users/yourname/anaconda/bin if you use anaconda python distribution in OS X
    CLASSIFYIMAGEPATH <- "path/to/your/classify_image.py" #should look like ~/anaconda/lib/python2.7/site-packages/tensorflow/models/image/imagenet
    
    outputtext <- reactive({
      ###This is to compose image recognition template###
      inFile <- input$file1 #This creates input button that enables image upload
      template <- paste0(PYTHONPATH,"/python ",CLASSIFYIMAGEPATH,"/classify_image.py") #Template to run image recognition using Python
      if (is.null(inFile))
        {res <- system(paste0(template," --image_file /tmp/imagenet/cropped_panda.jpg"),intern=T)} else { #Initially the app classifies cropped_panda.jpg, if you download the model data to a different directory, you should change /tmp/imagenet to the location you use. 
      res <- system(paste0(template," --image_file ",inFile$datapath),intern=T) #Uploaded image will be used for classification
        }
      })
    
    output$plot <- renderPlot({
      ###This is to create wordcloud based on image recognition results###
      df <- data.frame(gsub(" *\\(.*?\\) *", "", outputtext()),gsub("[^0-9.]", "", outputtext())) #Make a dataframe using detected objects and scores
      names(df) <- c("Object","Score") #Set column names
      df$Object <- as.character(df$Object) #Convert df$Object to character
      df$Score <- as.numeric(as.character(df$Score)) #Convert df$Score to numeric
      s <- strsplit(as.character(df$Object), ',') #Split rows by comma to separate rows
      df <- data.frame(Object=unlist(s), Score=rep(df$Score, sapply(s, FUN=length))) #Allocate scores to split words
      # By separating long categories into shorter terms, we can avoid "could not be fit on page. It will not be plotted" warning as much as possible
      wordcloud(df$Object, df$Score, scale=c(4,2),
                    colors=brewer.pal(6, "RdBu"),random.order=F) #Make wordcloud
    })
    
    output$outputImage <- renderImage({
      ###This is to plot uploaded image###
      if (is.null(input$file1)){
        outfile <- "/tmp/imagenet/cropped_panda.jpg"
        contentType <- "image/jpg"
        #Panda image is the default
      }else{
        outfile <- input$file1$datapath
        contentType <- input$file1$type
        #Uploaded file otherwise
        }
      
      list(src = outfile,
           contentType=contentType,
           width=300)
    }, deleteFile = TRUE)
})

{% endhighlight %}



## ui.R

The `ui.R` file is rather simple: 

{% highlight r %}
shinyUI(
  fluidPage(titlePanel("Simple Image Recognition App using TensorFlow and Shiny"),
            tags$hr(),
            fluidRow(
              column(width=4,
                     fileInput('file1', '',accept = c('.jpg','.jpeg')),
                     imageOutput('outputImage')
                     ),
              column(width=8,
                     plotOutput("plot")
                     )
              )
            )
  )
{% endhighlight %}

## Shiny App

That's it!  
Here is a checklist to run the app without an error.

- Make sure you have all the requirements installed   
- You have `server.R` and `ui.R` in the same folder  
- You corrently set `PYTHONPATH` and `CLASSIFYIMAGEPATH`  
- Optionally, `change num_top_predictions` in `classify_image.py`
- Upload images should be in jpg/jpeg format

I was personally impressed with what machine finds in abstract paintings or modern art &#128521;

# Code
The full codes are available on [github](https://github.com/yukiegosapporo/2016-01-12-mini-ai-app-using-tensorflow-and-shiny).
