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

<span class = "dropcap">A</span> while ago I developed and shared [an emoji decoder](http://opiateforthemass.es/articles/emoticons-in-R/) because I was facing problems when retrieving data from Twitter and Instragram. In a nutshell, the issue is that R encodes emojis in a way that makes it a hassle identifying them. This is where the decoder/dictionary comes into play.  

After I put together my decoder, new emojis have been released. For example, certain emojis came with different skin colours. [This list](http://unicode.org/emoji/charts/full-emoji-list.html) is a more complete version than the one I used for my decoder. [Felipe](https://stackoverflow.com/users/7078119/felipe-su%C3%A1rez-colmenares) released [a new decoder](https://raw.githubusercontent.com/felipesua/sampleTexts/master/emojis.csv) based on the new list which I will use in the post. This skin tone thingie adds a little bit of complexity to the analysis. In fact, the skin tone information is an own unicode codepoint. It means that an emoji with skin tone information (e.g. boy: light kin tone "U+1F466 U+1F3FB") consists of two unicode codepoints: the codepoint for the emoji (e.g. "U+1F466" for boy) and the codepoint for the respective skin tone (e.g. "U+1F3FB" for light skin tone). The descriptions are thus slightly different (e.g. "princess" vs "princess: light skin tone") in which case simple string matching would fail to identify these as being the same emoji. It's gonna require some special attention when cleaning the data. More on that in the code.  

Alright, so with the decoder at hand, we're able to identify the emojis in, say, a tweet retrieved with the `twitteR` package. What now? Quite some people contacted me since I released the article asking for advice concerning emojis analysis and I'd like to cover some questions in this post. The whole code I used for the analysis in this article is available [here](https://github.com/today-is-a-good-day/emojis/blob/master/emoji_analysis.R). 

 
## Most used emoji
One such question was how to determine a users most used emoji. 

We'll start collecting some sample data to perform our analysis on. In case you didn't already know, Paris Hilton is my favorite victim when it comes to emojis analysis or social media analysis, for the simple reason that she uses as lot ot them and shares a lot of content. The `emojis_matching` function is the heart of all the analysis performed in this post. 

{% highlight R %}
# get some sample data
usermedia <- userTimeline(user = "parishilton", n = 3200) %>%
  twListToDF
# convert to a format we can work with (very important!)
usermedia$text <- iconv(usermedia$text, from = "latin1", to = "ascii", sub = "byte")

# rank emojis by occurence in data, super basic
rank <- emojis_matching(usermedia$text, matchto, description) %>% 
  group_by(description) %>% 
  summarise(n = sum(count)) %>%
  arrange(-n)

head(rank, 10)
# A tibble: 10 × 2
                       description     n
                             <chr> <int>
1                         sparkles   386
2                         princess   101
3                     party popper    69
4                             fire    53
5  people with bunny ears partying    51
6                        red heart    46
7                    musical notes    38
8                        palm tree    38
9                  sparkling heart    37
10                         balloon    34
{% endhighlight %}

Paris Hilton's favorite emoji is: SPARKLES! Who would have thought ;) Her alltime favorite MUSICAL NOTES landed on place 7 (status quo 2017-03-24).

## Tweet with most emojis

Another possible use case is to determine which tweet contains the most emojis. We can use the `emojis_matching`function for this question again and than arrange by descending count. Done. Easy peasy lemon squeezy. This is how the output looks like:

![]({{ site.url }}/images/jessica/tweets_ranked.png)

From here, it's easy to calculate the average number of emojis per tweet: 

{% highlight R %}
mean(tweets$n, na.rm = TRUE)
[1] 3.646341
{% endhighlight %}

## Sentiment analysis with emojis

Doing some research for this article, I came accross [this paper](https://www.clarin.si/repository/xmlui/handle/11356/1048), which extensively analyzes the valence (positive, negative, neutral) of emojis in a scientific manner. The authors made a csv file available containing all the emojis with their respective valences. I will base the 
sentiment analysis on this file. 

For a reason I ignore, the csv file available doesn't contain the sentiment score. The article gives guidance as how to compute the senteiment score of each emoji based on the data in the csv file, but at this point I prefer to scrape the list with the sentiment scores. It's available [here](http://kt.ijs.si/data/Emoji_sentiment_ranking/index.html). This is how the list looks like: 

{% highlight R %}
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

Ok, so we have a list of emojis with their respective unicode codepoints and sentiment scores. The next step consists of matching sentiments to the tweets. 

{% highlight R %}
sentiments <- emojis_matching(usermedia$text, new_matchto, new_description, sentiment) %>%
  mutate(sentiment = count*as.numeric(sentiment)) %>%
  group_by(text) %>% 
  summarise(sentiment_score = sum(sentiment))
{% endhighlight %}

What we get is a list of the tweets with there respective, aggregated sentiment scores: 

![]({{ site.url }}/images/jessica/sentiments.png)

Most of Paris Hilton's tweets are positive, which was to be expected, with only two tweets identified as having a negative valence. 
Some tweets don't have any sentiment score, this is due to the fact that they didn't contain any (identifiable) emoji. 

## Emojis associated with words in tweets

One question that came to my mind was with what words each emoji is associated. Before we can perform this kind of text analysis, we need to do the usual house keeping: clean the texts from links, strange characters, punctuation etc. I recommand having a look at [the code](https://github.com/today-is-a-good-day/emojis/blob/master/emoji_analysis.R) to see what I exactly did, especially at the cleaning pipe. Furthermore, I wrote the function `wordFreqEmojis` that outputs a data frame of emojis with their top 5 words (default value, can be changed) by frequency. 

{% highlight R %}
# get emojis for each tweet and clean tweets
raw_texts <- emojis_matching(usermedia$text, matchto, description) %>% 
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

In natural language programming, there are literally endless possibilities. One could fine tune the results by using other stopwords, working with word stems or considering ngrams instead of single words just to name a few. Besides words, one can also find cooccuring emojis. 

## Emojis and weekdays
 
The data allows us to look for the weekday with the highest emojis usage. 

{% highlight R %}
emojis_matching(usermedia$text, matchto, description) %>%
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
1    Monday   150
2    Friday   135
3   Tuesday   131
4  Saturday   129
5    Sunday   127
6  Thursday   119
7 Wednesday   107
{% endhighlight %}

Turns out Paris emojis use is more or less constant over the week. 
One could even look at trends for every single emoji if needed. For instance, defining groups of "happy emojis" and "sad emojis", one could check wether these two groups are distributed differently accross the week. 

## List of further emojis analysis ideas

Summing up, here are some ideas for further analysis I didn't implement in this article but can be done with emojis: 

- combine traditional text based sentiment analysis with emojis basd sentiment analysis
- analyse coocccurence of emojis
- identify topics based on emojis
- track trends in emojis use

## Final thoughts

Emoji analysis is unlikely to make a good job at replacing natural language processing in a sentiment analysis context. Emojis can help easily identify positive content, but they're not so good at identifying negative or serious, business related content as far as I can tell. It makes sense since most of the emojis have a positive meaning. Also, not everyone makes the same use of emoji and not every positgroup_by(text) %>%
    mutate(valid = ifelse(any(description == "sparkles"), TRUE, FALSE)) %>%ive tweet contains an emoji, so again, I don't think it's a good idea to base your sentiment analysis exclusively on emojis. I'd rather suggest to perform traditional sentiment analysis and enrich it with emoji data. Also, emoji analysis can become quite difficult due to the constantly growing number of emojis. Some of them have more than one unicode codepoint, this can be a challenge in the analysis. 

In this article, I only showed how to perform simple positive/negative sentiment analysis and very basic association with words, but one could come up with much more detailed approaches. One could harvest much more information from emojis than just their level of positiveness. I'm thinking activities, different sentiments, patriotism, fondness for children, frequency of travelling, etc. 
