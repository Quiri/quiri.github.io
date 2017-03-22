---
layout: post
title: "Emojis Analysis in R"
excerpt: "Who to analysis emojis"
categories: articles
tags: [R, Twitter, Emojis, Social Media]
published: false
comments: true
author: jess
date: 2017-03-02T07:00:00+02:00
share: true
---

<span class = "dropcap">A</span> while ago I developed and shared an emoji decoder because I was facing problems when retrieving data from Twitter and Instragram. For those who don't want to read [the article](http://opiateforthemass.es/articles/emoticons-in-R/), basically the issue is that R encodes emojis in a way that makes it a hassle identifying them. This is where the decoder/dictionary comes into play.  

After I put together my decoder, new emojis have been released. For example, certain emojis came with different skin colours. [This list](http://unicode.org/emoji/charts/full-emoji-list.html) is a more complete version than the one I used for my decoder. Felipe put together [a new decoder](https://raw.githubusercontent.com/felipesua/sampleTexts/master/emojis.csv) based on the new list which I will use in the post. This skin tone thingie adds a little bit of complexity to the analysis, as these emojis have slightly different descriptions. The princess emoji for instance can be either the plain princess or the princess with a defined skin colour, for example princess: light skin tone, in which simple string matching would fail to identify these as being the same emoji. It's gonna require some special attention when cleaning the data. More on that later in the code. 

Alright, so with the decoder at hand, we're able to identify the emojis in, say, a tweet retrieved with the `twitteR` package. What now? Quite some people contacted me since I released the article asking for advice concerning emojis analysis and I'd like to cover some questions in this post. 

 
## Most used emoji
One such question was how to determine a users most used emoji. 

Let's start setting everything up. 

{% highlight R %}
# load packages and set options
options(stringsAsFactors = FALSE)
library(dplyr)
library(twitteR)
library(stringr)
library(rvest)
library(Unicode)
library(tm)

Sys.setlocale(category = "LC_TIME", locale = "en_US.UTF-8")

# load twitter credentials and authorize
load("twitCred.Rdata")
api_key <- twitCred$consumerKey
api_secret <- twitCred$consumerSecret
access_token <- twitCred$oauthKey
access_token_secret <- twitCred$oauthSecret
setup_twitter_oauth(api_key,api_secret,access_token,access_token_secret)

# read in emoji dictionary
emDict_raw <- read.csv2("../emojis.csv") %>% 
  select(EN, ftu8) %>% 
  rename(description = EN, r.encoding = ftu8)

# plain skin tones
skin_tones <- c("light skin tone", 
                "medium-light skin tone", 
                "medium skin tone",
                "medium-dark skin tone", 
                "dark skin tone")

# I don't need the skin tone info, so I remove plain skin tones and skin tone info in description
# if you need this infor, obviously don't delete it!
emDict <- emDict_raw %>%
  filter(!description %in% skin_tones) %>%
  mutate(description = gsub("(.*):.*", "\\1", description)) %>%
  # now we have several occurences of "woman" e.g. and we only want to keep the 
  # first one with the code that doesn't contain the skin info
  group_by(description) %>% 
  slice(1:1)

# utility functions
# this function outputs the emojis found in a string as well as their occurences
# provide a sentiment score for each emoji to get back a sentiment score
count_matches <- function(string, matchto, description, sentiment = NA) {
  vec <- c()
  for (m in matchto) {
    l <- str_count(string, m)
    vec <- c(vec, l)
  }
  
  if (!is.vector(sentiment)) {
    vec <- as.data.frame(cbind(string, description, vec), row.names = NULL) %>%
      rename(count = vec, text = string) %>%
      filter(count != 0) %>%
      mutate(count = as.numeric(count))
    return(vec)
  }
  if (is.vector(sentiment)) {
    
    vec <- as.data.frame(cbind(string, description, vec, sentiment), row.names = NULL) %>%
      rename(count = vec, text = string) %>%
      filter(count != 0) %>%
      mutate(count = as.numeric(count))
    return(vec)
  }
}

# this function does the same but with a vector 
emojis_matching <- function(texts, matchto, description, sentiment = NA) {
  df <- data.frame()
  
  if (!is.vector(sentiment)) {
    
    for (t in texts) {
      part <- count_matches(t, matchto, description)
      df <- rbind(df, part)
    }
    
  }
  
  if (is.vector(sentiment)) {
    
    for (t in texts) {
      part <- count_matches(t, matchto, description, sentiment)
      df <- rbind(df, part)
    }
    
  }
  return(df)
}
{% endhighlight %}

Now we're good to go. We'll start collecting some sample data to perform our analysis on. In case you didn't already know, Paris Hilton is my favorite victim when it comes to emojis analysis or social media analysis, for the simple reason that she uses as lot ot them and shares a lot of content. The `emojis_matching` function introduced above is the heart of all the analysis performed in this post. 

{% highlight R %}
# get some sample data
usermedia <- userTimeline(user = "parishilton", n = 3200) %>%
  twListToDF
# convert to a format we can work with
usermedia$text <- iconv(usermedia$text, from = "latin1", to = "ascii", sub = "byte")

# rank emojis by occurence in data
rank <- emojis_matching(usermedia$text, emDict$r.encoding, emDict$description) %>% 
group_by(description) %>% 
summarise(n = sum(count)) %>%
arrange(-n)

head(rank, 10)
# A tibble: 10 × 2
                       description     n
                             <chr> <dbl>
1                         sparkles   125
2                         princess    25
3                     party popper    14
4                        red heart    12
5                          balloon    11
6  people with bunny ears partying    10
7                Statue of Liberty    10
8                             fire     9
9                     glowing star     8
10                 sparkling heart     8
{% endhighlight %}

Paris Hilton's favorite emoji is: SPARKLES! Who would have thought ;) Her alltime favorite MUSICAL NOTES landed on place 6 (status quo 2017-02-03).

## Tweet with most emojis

Another possible use case is to determine which tweet contains the most emojis. We can use the `emojis_matching`function for this question again and than arrange by descending count. Done. Easy peasy.

{% highlight R %}
tweets <- emojis_matching(usermedia$text, emDict$r.encoding, emDict$description) %>% 
group_by(text) %>% 
summarise(n = sum(count)) %>%
# I add the time created because it makes it easiert to look up certain tweets
merge(usermedia, by = "text") %>% 
select(text, n, created) %>%
arrange(-n)
{% endhighlight %}

![]({{ site.url }}/images/jessica/tweets_ranked.png)

From here, it's easy to calculate the average number of emojis per tweet: 

{% highlight R %}
mean(tweets$n)
[1] 3.646341
{% endhighlight %}

## Sentiment analysis with emojis

Doing some research for this article, I quickly came accross [this paper](https://www.clarin.si/repository/xmlui/handle/11356/1048), which extensively analyzes the valence (positive, negative, neutral) of emojis in a scientific manner. The authors made a csv file available containing all the emojis with their respective valences. I will base the 
sentiment analysis on this file. 

In order to count sentiments in tweets, we'll first need to get the [list](http://kt.ijs.si/data/Emoji_sentiment_ranking/index.html) containing the sentiment score for each emoji.

{% highlight R %}
# reference website
url <- "http://kt.ijs.si/data/Emoji_sentiment_ranking/index.html"

# get emojis
emojis_raw <- url %>%
read_html() %>%
html_table() %>%
  data.frame %>%
  select(-Image.twemoji., -Sentiment.bar.c.i..95..)
names(emojis_raw) <- c("char", "unicode", "occurrences", "position", "negative", "neutral", 
                   "positive", "sentiment_score", "description", "block")
# change numeric unicode to character unicode to be able to match with emDict 
emojis <- emojis_raw %>%
  mutate(unicode = as.u_char(unicode)) %>%
  mutate(description = tolower(description)) 

str(emojis)
'data.frame':	751 obs. of  10 variables:
 $ char           : chr  "\U0001f602" "❤" "♥" "\U0001f60d" ...
 $ unicode        :Class 'u_char'  int [1:751] 128514 10084 9829 128525 128557 128536 128522 128076 128149 128079 ...
 $ occurrences    : int  14622 8050 7144 6359 5526 3648 3186 2925 2400 2336 ...
 $ position       : num  0.805 0.747 0.754 0.765 0.803 0.854 0.813 0.805 0.766 0.787 ...
 $ negative       : num  0.247 0.044 0.035 0.052 0.436 0.053 0.06 0.094 0.042 0.104 ...
 $ neutral        : num  0.285 0.166 0.272 0.219 0.22 0.193 0.237 0.249 0.285 0.271 ...
 $ positive       : num  0.468 0.79 0.693 0.729 0.343 0.754 0.704 0.657 0.674 0.624 ...
 $ sentiment_score: num  0.221 0.746 0.657 0.678 -0.093 0.701 0.644 0.563 0.632 0.52 ...
 $ description    : chr  "face with tears of joy" "heavy black heart" "black heart suit" "smiling face with heart-shaped eyes" ...
 $ block          : chr  "Emoticons" "Dingbats" "Miscellaneous Symbols" "Emoticons" ...
{% endhighlight %}

Ok, so we have a list of emojis with their respective unicode codepoints and sentiment scores. We will now merge this list with Felipe's list to have the additional R encoding info. 
{% highlight R %}
emojis_merged <- emojis %>%
  merge(emDict, by = "unicode")
{% endhighlight %}

This move made us loose 137 emojis that are not in `emDict` and for which we don't have an R encoding. For what I could see, all of them are basic black and white emojis hardly used in a social media context anyways, so I'd say it's not too big of a loss. If you're curious, do `emojis %>% filter(!unicode %in% emDict$unicode) %>% View` to have a glance at the emojis lost in the process. 

The next step consists of matching sentiments to the tweets. Let's do that.

{% highlight R %}
sentiments <- emojis_matching(usermedia$text, 
                              emojis_merged$r.encoding, 
                              emojis_merged$description, 
                              sentiment = emojis_merged$sentiment_score) %>%
  mutate(sentiment = count*as.numeric(sentiment)) %>%
  group_by(text) %>% 
  summarise(sentiment_score = sum(sentiment))
{% endhighlight %}

![]({{ site.url }}/images/jessica/sentiments.png)

What we get is a list of the tweets with there respective, aggregated sentiment scores. Most of Paris Hilton's tweets are positive, which was to be expected, with only two tweets identified as having a negative valence.
I'll merge `sentiments` back to the original `usermedia` object with this piece of code: 

{% highlight R %}
usermedia_merged <- usermedia %>% 
  select(text, created) %>% 
  merge(sentiments, by = "text", all.x = TRUE)
{% endhighlight %}

Some tweets don't have any sentiment score, this is due to the fact that they didn't contain any (identifiable) emoji. 

## Emojis associated with words in tweets

Let's get a list of the emojis used in the tweets and a list of, say, the top 5 words associated to each and every one of them. 

{% highlight R %}
# function that separates capital letters hashtags to get the most text out of them
hashgrep <- function(text) {
  hg <- function(text) {
    result <- ""
    while(text != result) {
      result <- text
      text <- gsub("#[[:alpha:]]+\\K([[:upper:]]+)", " \\1", text, perl = TRUE)
    }
    return(text)
  }
  unname(sapply(text, hg))
}

# tweets cleaning pipe
cleanPosts <- function(text) {
  clean_texts <- text %>%
    gsub("<.*>", "", .) %>% # remove emojis
    gsub("&amp;", "", .) %>% # remove &
    gsub("(RT|via)((?:\\b\\W*@\\w+)+)", "", .) %>% # remove retweet entities
    gsub("@\\w+", "", .) %>% # remove at people
    hashgrep %>%
    gsub("[[:punct:]]", "", .) %>% # remove punctuation
    gsub("[[:digit:]]", "", .) %>% # remove digits
    gsub("http\\w+", "", .) %>% # remove html links
    iconv(from = "latin1", to = "ASCII", sub="") %>% # remove emoji and bizarre signs
    gsub("[ \t]{2,}", " ", .) %>% # remove unnecessary spaces
    gsub("^\\s+|\\s+$", "", .) %>% # remove unnecessary spaces
    tolower
  return(clean_texts)
}

# function that outputs a df of emojis with their top 5 words (by frequency)
wordFreqEmojis <- function(df, text = df$text, description = df$description, top = 5) {
  
  
  words_to_emojis <- data.frame(emoji = character(), 
                               words = character(), 
                               frequency = numeric())
  
  for (i in unique(description)) {
    cat(i)
    dat <- df %>% 
      filter(description == i)
    
    myCorpus <- Corpus(VectorSource(dat$text)) %>%
      tm_map(removePunctuation) %>%
      tm_map(stripWhitespace) %>%
      tm_map(removeWords, stopwords("english"))

    dtm <- DocumentTermMatrix(myCorpus)
    # find the sum of words in each Document
    rowTotals <- apply(dtm , 1, sum)
    dtm.new   <- dtm[rowTotals> 0, ]
    # collapse matrix by summing over columns
    freq <- colSums(as.matrix(dtm))
    # create sort order (descending)
    ord <- order(freq,decreasing=TRUE)

    df_new <- data.frame(emoji = i, 
                         words = names(freq[ord][1:top]), 
                         frequency = freq[ord][1:top], 
                         row.names = NULL) 

    words_to_emojis <- rbind(words_to_emojis, df_new)
  }
  
  return(words_to_emojis)
  
}
{% endhighlight %}

We have all the functions we need to clean the tweets (you can adjust that step to your needs) and get a data frame with a user's emojis and their top words. 

{% highlight R %}
# get emojis for each tweet and clean tweets
raw_texts <- emojis_matching(usermedia$text, emDict$r.encoding, emDict$description) %>% 
  select(-sentiment, -count) %>%
  mutate(text = cleanPosts(text)) %>%
  filter(text != "")
  
# get data frame with emojis and top words
words_emojis <- wordFreqEmojis(raw_texts, raw_texts$text, raw_texts$description) %>% 
  filter(!is.na(words))
{% endhighlight %}

Browsing through `words_emojis`, it's obvious that the data makes a lot of sense. The emojis associated with the word "adios" are for instance "sun", "water wave", "bikini" and "airplane". These words all indicate the twitter user is travelling. 

![]({{ site.url }}/images/jessica/words_emojis.png)

The top words used along with the emoji "sparkles" are "love", "girl", "paradise" and "gold" among others. 
In natural language programming, there are literally endless possibilities. One could fine tune the results by using other stopwords, working with word stems or considering ngrams instead of single words just to name a few. 

## Emojis and weekdays
 
The data allows us to look for the weekday with the highest emojis usage. 

{% highlight R %}
emojis_matching(usermedia$text, emDict$r.encoding, emDict$description) %>%
  merge(usermedia %>% select(text, created), by = "text") %>% 
  select(description, created) %>% 
  mutate(weekday = weekdays(created)) %>% 
  select(-created) %>% 
  group_by(weekday) %>% 
  summarise(n = n()) %>% 
  arrange(-n)
# A tibble: 7 × 2
    weekday     n
      <chr> <int>
1   Tuesday   118
2 Wednesday   114
3    Monday   111
4  Saturday   111
5  Thursday   103
6    Sunday    84
7    Friday    80
{% endhighlight %}

Turns out Paris' lazy days are Friday (busy getting ready for the weekend?) and Sunday (busy recovering from the weekend?).
One could even look at trends for every single emoji if needed. For instance, defining groups of "happy emojis" and "sad emojis", one could check wether these two groups are distributed differently accross the week. 
 
## emojis associated with time of the day (morning, afternoon, evening, night)?

## Final thoughts

Emoji analysis is unlikely to make a good job at replacing natural language processing in a sentiment analysis context. Emojis can help easily identify positive content, but they're not so good at identifying negative or serious, business related content. It makes sense since most of the emojis have a positive meaning. Also, not everyone makes the same use of emoji and not every positive tweet contains an emoji, so again, I don't think it's a good idea to base your sentiment analysis exclusively on emojis. I'd rather suggest to perform traditional sentiment analysis and enrich it with emoji data. Also, emoji analysis can become quite difficult due to the constantly growing number of emojis. Some of them have more than one unicode codepoint, this can also be a challenge in the analysis. 

In this article, I only showed how to perform simple positive/negative sentiment analysis and very basic association with words, but one could come up with much more detailed approaches. One could harvest much more information from emojis than just their level of positiveness. I'm thinking activities, different sentiments, patriotism, fondness for children, frequency of travelling, etc. 
