---
layout: post
title: Add external code to Rmarkdown
excerpt: Test test
date: 2014-10-21 20:25:13.000000000 +02:00
categories: articles
tags: [R]
type: post
published: true
comment: true
share: true
author: kirill
---


Ever been in a position to write a documentation or report about complex R code? Take a Shiny dashboard for example, or other big projects. Maybe you heard it already, with [RMarkdown](http://rmarkdown.rstudio.com/) you can simply write markdown code, add some R code to it and render it to pdf, static websites or even presentations. I don't want to go deep into detail here, [others](http://www.r-bloggers.com/r-markdown-v2/) have done it already. My point here is, that you already have R code running and want to write a report _ex post._ In this case copying the code to the .Rmd markdown document is pain and since code may change you will make sure that the code you copied is always up-to-date. But come on, we are data scientists and not rookies, there must be a way to refence code in external code. Good news, there is!

So assuming we have a server.R file for our shiny application, which I will borrow from [shiny.rstudio.com](http://shiny.rstudio.com/) main page.


{% highlight R %}
shinyServer(function(input, output) {

  output$main_plot <- renderPlot({

    hist(faithful$eruptions,
      probability = TRUE,
      breaks = as.numeric(input$n_breaks),
      xlab = "Duration (minutes)",
      main = "Geyser eruption duration")

    if (input$individual_obs) {
      rug(faithful$eruptions)
    }

    if (input$density) {
      dens <- density(faithful$eruptions,
          adjust = input$bw_adjust)
      lines(dens, col = "blue")
    }

  })
})
{% endhighlight %}

Now i want to add the histogram part to my report.Rmd. The standard way is to add the source code by copy-paste to a R-chunk. Note that we do not evaluate the code since it's often out of context in complex projects and evaluating it is often not possible. We want just add the code to our report to show it. Nevertheless, this is optional.

{% highlight R %}
hist(faithful$eruptions,
  probability = TRUE, 
  breaks = as.numeric(input$n_breaks), 
  xlab = "Duration (minutes)", 
  main = "Geyser eruption duration")
{% endhighlight %}

Let's start with referencing now. In the server.R we have to add a mark where the referencing starts. This is done by adding `## @knitr chunkname` or `## ---- chunkname` where chunkname should be replaced by the name you want to reference your chunk with. The marks are synonyms and can be used identically. Personally I prefer the latter, because it's cleaner and can help improve readability. Everything that follows after this mark can be referenced in a separate .Rmd file. The reference ends with end-of-file or with another mark. As reference end one can insert a new mark, for example `## ---- end-of-mark`. Technically we assigned a new mark that could be referenced as well, but if we stick to conventions, like only using `## ---- end-of-mark`, `## ---- end-of-chunkname`, or simply `## ---- end` which we can safe the readability of the code. Thus we get our new server.R:

{% highlight R %}
shinyServer(function(input, output) {

  output$main_plot <- renderPlot({

## ---- histogram
    hist(faithful$eruptions,
      probability = TRUE,
      breaks = as.numeric(input$n_breaks),
      xlab = "Duration (minutes)",
      main = "Geyser eruption duration")
## ---- end-of-histogram

    if (input$individual_obs) {
      rug(faithful$eruptions)
    }

    if (input$density) {
      dens <- density(faithful$eruptions,
          adjust = input$bw_adjust)
      lines(dens, col = "blue")
    }

  })
})
{% endhighlight R %}

It is important that the marks are at the beginning of the line.

Now since we set the reference points, we actually want to reference it from within Rmarkdown. We first have to tell markdown which .R files we want to reference and then we just add the code chunks where we want. So the report .Rmd boils down to:

{% highlight R %}
## Histogram

```{r echo = F}
library(knitr)
read_chunk("server.R")
```

This is how I generate the histogram in the shiny Dashboard:

```{r eval = F}
<<histogramm>>
# One can also add more code to the chunk
```</pre>

{% endhighlight %}

Well, that's it. Here's a summary:

*   Add reference points (marks) to your original code
*   Everything following the mark to the following mark will be referenced
*   If no following mark available, everything to end of file will be referenced
*   In the .Rmd all referenced .R files should be loaded with `read_chunk`
*   In the R chunks in .Rmd references can be used among with other code or references

If you need more input or examples see [here](http://zevross.com/blog/2014/07/09/making-use-of-external-r-code-in-knitr-and-r-markdown/) and [here](http://yihui.name/knitr/demo/externalization/).

Now folks, let's document our code!


