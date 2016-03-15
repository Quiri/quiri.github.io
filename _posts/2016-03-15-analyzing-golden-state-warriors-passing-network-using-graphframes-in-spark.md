---
layout: post
title: Analyzing Golden State Warriors' passing network using GraphFrames in Spark
categories: articles
excerpt: "and interactive chart with networkD3"
tags: [Python, Spark, GraphX, GraphFrames, R, networkD3]
published: true
comments: true
author: yuki
share: true
date: 2016-03-15T16:00:00+02:00
---

<!--html_preserve--><div id="htmlwidget-5445" style="width:804px;height:504px;" class="forceNetwork html-widget"></div>
<script type="application/json" data-for="htmlwidget-5445">{"x":{"links":{"source":[11,11,11,11,11,11,11,11,11,11,11,11,11,11,12,12,12,12,12,12,12,12,12,12,12,12,12,7,7,7,7,7,7,7,7,7,7,7,7,7,13,13,13,13,13,13,13,13,13,13,13,13,13,13,2,2,2,2,2,2,2,2,2,2,14,14,14,14,14,14,14,14,14,14,14,0,0,0,0,0,0,0,0,0,0,0,0,0,0,10,10,10,10,10,10,10,10,10,10,10,10,3,3,3,3,3,3,3,3,3,3,3,3,3,3,6,6,6,6,6,6,6,6,6,6,6,6,6,4,4,4,4,4,4,4,4,4,4,4,4,4,4,5,5,5,5,5,5,5,5,5,5,5,8,8,8,8,8,8,8,8,8,8,8,8,8,8,9,9,9,9,9,9,9,9,1,1,1,1,1,1,1,1,1,1,1,1,1,1],"target":[6,4,3,13,8,12,7,0,2,1,5,10,14,9,8,7,0,3,4,6,13,11,1,5,10,9,14,4,6,8,13,1,12,0,5,2,3,11,10,14,6,4,2,8,7,1,5,12,11,3,0,10,9,14,4,6,13,8,7,1,11,3,0,12,4,8,0,6,7,1,3,13,11,12,9,8,7,12,1,4,6,5,3,11,13,2,10,14,9,8,3,7,0,11,13,4,6,12,5,1,2,12,6,11,8,7,13,10,1,0,5,4,2,9,14,4,13,7,8,1,2,11,3,0,5,12,10,14,6,13,2,7,1,11,5,8,0,12,3,14,10,9,4,8,6,7,0,13,3,1,11,12,10,7,6,0,12,1,13,4,5,2,3,10,11,14,9,3,0,11,8,13,4,14,1,4,8,6,7,13,0,3,2,12,11,5,14,10,9],"value":[3.16,3.06,1.7,1.68,1.54,0.84,0.8,0.78,0.7,0.56,0.3,0.16,0.1,0.06,4.34,2.9,1.88,1.52,1.36,0.98,0.92,0.86,0.8,0.16,0.14,0.02,0.02,7.34,6,5.86,3.26,3.22,2.98,2.92,1.8,1.8,1.18,0.8,0.48,0.28,9.3,5.2,3.68,2.3,2.22,1.96,1.12,0.98,0.82,0.68,0.54,0.34,0.02,0.04,13.78,6.64,4.88,2.18,1.94,1.66,1.08,0.56,0.46,0.02,0.54,0.28,0.26,0.24,0.2,0.14,0.08,0.06,0.04,0.02,0.02,3.02,2.6,2.04,1.46,1.2,1.12,0.86,0.72,0.7,0.6,0.3,0.2,0.2,0.14,1.42,1.14,0.8,0.38,0.34,0.34,0.26,0.24,0.18,0.06,0.04,0.02,1.8,1.44,1.36,1.28,1.2,1.06,0.88,0.86,0.74,0.52,0.42,0.28,0.08,0.02,32.94,13.12,7.08,6.58,4.22,3.28,3.08,1.86,1.68,1.62,1.02,0.16,0.18,22.8,12.68,8.2,6.08,5.4,2.5,2.48,2.1,1.48,1.4,0.44,0.26,0.12,0.06,4.38,3.16,1.78,1.66,1.38,0.98,0.88,0.48,0.42,0.12,0.06,5.88,5.4,4.72,4.12,4,3.26,2.88,1.8,1.72,1.6,1.06,1,0.1,0.02,0.22,0.14,0.14,0.08,0.06,0.04,0.02,0.02,6.46,4.36,3.36,2.92,2.62,1.56,1.26,1.26,1,0.56,0.46,0.12,0.04,0.02]},"nodes":{"name":["Barbosa, Leandro","Barnes, Harrison","Bogut, Andrew","Clark, Ian","Curry, Stephen","Ezeli, Festus","Green, Draymond","Iguodala, Andre","Livingston, Shaun","Looney, Kevon","McAdoo, James Michael","Rush, Brandon","Speights, Marreese","Thompson, Klay","Varejao, Anderson"],"group":[0,1,1,0,0,1,1,1,0,1,1,1,1,0,1],"nodesize":[52.3611707850441,75.4378963472945,59.7657818859762,35.3958263109262,469.473001117824,23.9527229345031,397.271752130282,151.459584612675,167.106945458715,2.77559132554324,7.30400213603421,31.7317642269105,44.9684206052305,179.54518132615,3.71062155092688]},"options":{"NodeID":"nodeid","Group":"group","colourScale":"d3.scale.category10()","fontSize":16,"fontFamily":"Arial","clickTextSize":40,"linkDistance":350,"linkWidth":"function(d) { return Math.sqrt(d.value); }","charge":-120,"linkColour":"#666","opacity":0.8,"zoom":true,"legend":false,"nodesize":true,"radiusCalculation":" Math.sqrt(d.nodesize)+6","bounded":false,"opacityNoHover":true,"clickAction":null}},"evals":[],"jsHooks":[]}</script><!--/html_preserve-->



Databricks recently announced [__GraphFrames__](https://databricks.com/blog/2016/03/03/introducing-graphframes.html), awesome Spark extension to implement graph processing using DataFrames.  
I performed graph analysis and visualized beautiful ball movement network of Golden State Warriors using rich data provided by [NBA.com's stats](http://stats.nba.com/)

# Pass network of Warriors

### Passes received & made

The league's MVP Stephen Curry received the most passes and the team's MVP Draymond Green provides the most passes.  
We've seen most of the offense start with their pick & roll or Curry's off-ball cuts with Green as a pass provider.  

<iframe src="//giphy.com/embed/46mmB5LSIMn7O" width="480" height="272" frameBorder="0" class="giphy-embed" allowFullScreen></iframe><p><a href="http://giphy.com/gifs/golden-state-warriors-stephen-curry-draymond-green-46mmB5LSIMn7O">via GIPHY</a></p>

##### inDegree

<table border="4" class="dataframe">  <thead>    <tr style="text-align: center;">      <th>id</th>      <th>inDegree</th>    </tr>  </thead>  <tbody>    <tr>      <td>CurryStephen</td>      <td>3993</td>    </tr>    <tr>      <td>GreenDraymond</td>      <td>3123</td>    </tr>    <tr>      <td>ThompsonKlay</td>      <td>2276</td>    </tr>    <tr>      <td>LivingstonShaun</td>      <td>1925</td>    </tr>    <tr>      <td>IguodalaAndre</td>      <td>1814</td>    </tr>    <tr>      <td>BarnesHarrison</td>      <td>1241</td>    </tr>    <tr>      <td>BogutAndrew</td>      <td>1062</td>    </tr>    <tr>      <td>BarbosaLeandro</td>      <td>946</td>    </tr>    <tr>      <td>SpeightsMarreese</td>      <td>826</td>    </tr>    <tr>      <td>ClarkIan</td>      <td>692</td>    </tr>    <tr>      <td>RushBrandon</td>      <td>685</td>    </tr>    <tr>      <td>EzeliFestus</td>      <td>559</td>    </tr>    <tr>      <td>McAdooJames Michael</td>      <td>182</td>    </tr>    <tr>      <td>VarejaoAnderson</td>      <td>67</td>    </tr>    <tr>      <td>LooneyKevon</td>      <td>22</td>    </tr>  </tbody></table>

##### outDegree

<table border="4" class="dataframe">  <thead>    <tr style="text-align: center;">      <th>id</th>      <th>outDegree</th>    </tr>  </thead>  <tbody>    <tr>      <td>GreenDraymond</td>      <td>3841</td>    </tr>    <tr>      <td>CurryStephen</td>      <td>3300</td>    </tr>    <tr>      <td>IguodalaAndre</td>      <td>1896</td>    </tr>    <tr>      <td>LivingstonShaun</td>      <td>1878</td>    </tr>    <tr>      <td>BogutAndrew</td>      <td>1660</td>    </tr>    <tr>      <td>ThompsonKlay</td>      <td>1460</td>    </tr>    <tr>      <td>BarnesHarrison</td>      <td>1300</td>    </tr>    <tr>      <td>SpeightsMarreese</td>      <td>795</td>    </tr>    <tr>      <td>RushBrandon</td>      <td>772</td>    </tr>    <tr>      <td>EzeliFestus</td>      <td>765</td>    </tr>    <tr>      <td>BarbosaLeandro</td>      <td>758</td>    </tr>    <tr>      <td>ClarkIan</td>      <td>597</td>    </tr>    <tr>      <td>McAdooJames Michael</td>      <td>261</td>    </tr>    <tr>      <td>VarejaoAnderson</td>      <td>94</td>    </tr>    <tr>      <td>LooneyKevon</td>      <td>36</td>    </tr>  </tbody></table>

### Label Propagation

Label Propagation is an algorithm to find communities in a graph network.  
The algorithm nicely classifies players into backcourt and frontcourt without providing label!  

<table border="4" class="dataframe">  <thead>    <tr style="text-align: center;">      <th>name</th>      <th>label</th>    </tr>  </thead>  <tbody>    <tr>      <td>Thompson, Klay</td>      <td>3</td>    </tr>    <tr>      <td>Barbosa, Leandro</td>      <td>3</td>    </tr>    <tr>      <td>Curry, Stephen</td>      <td>3</td>    </tr>    <tr>      <td>Clark, Ian</td>      <td>3</td>    </tr>    <tr>      <td>Livingston, Shaun</td>      <td>3</td>    </tr>    <tr>      <td>Rush, Brandon</td>      <td>7</td>    </tr>    <tr>      <td>Green, Draymond</td>      <td>7</td>    </tr>    <tr>      <td>Speights, Marreese</td>      <td>7</td>    </tr>    <tr>      <td>Bogut, Andrew</td>      <td>7</td>    </tr>    <tr>      <td>McAdoo, James Michael</td>      <td>7</td>    </tr>    <tr>      <td>Iguodala, Andre</td>      <td>7</td>    </tr>    <tr>      <td>Varejao, Anderson</td>      <td>7</td>    </tr>    <tr>      <td>Ezeli, Festus</td>      <td>7</td>    </tr>    <tr>      <td>Looney, Kevon</td>      <td>7</td>    </tr>    <tr>      <td>Barnes, Harrison</td>      <td>7</td>    </tr>  </tbody></table>

### Pagerank

PageRank can detect important nodes (players in this case) in a network.  
It's no surprise that Stephen Curry, Draymond Green and Klay Thompson are the top three.  
The algoritm detects Shaun Livingston and Andre Iguodala play key roles in the Warriors' passing games.  

<table border="4" class="dataframe">  <thead>    <tr style="text-align: center;">      <th>name</th>      <th>pagerank</th>    </tr>  </thead>  <tbody>    <tr>      <td>Curry, Stephen</td>      <td>2.17</td>    </tr>    <tr>      <td>Green, Draymond</td>      <td>1.99</td>    </tr>    <tr>      <td>Thompson, Klay</td>      <td>1.34</td>    </tr>    <tr>      <td>Livingston, Shaun</td>      <td>1.29</td>    </tr>    <tr>      <td>Iguodala, Andre</td>      <td>1.21</td>    </tr>    <tr>      <td>Barnes, Harrison</td>      <td>0.86</td>    </tr>    <tr>      <td>Bogut, Andrew</td>      <td>0.77</td>    </tr>    <tr>      <td>Barbosa, Leandro</td>      <td>0.72</td>    </tr>    <tr>      <td>Speights, Marreese</td>      <td>0.66</td>    </tr>    <tr>      <td>Clark, Ian</td>      <td>0.59</td>    </tr>    <tr>      <td>Rush, Brandon</td>      <td>0.57</td>    </tr>    <tr>      <td>Ezeli, Festus</td>      <td>0.48</td>    </tr>    <tr>      <td>McAdoo, James Michael</td>      <td>0.27</td>    </tr>    <tr>      <td>Varejao, Anderson</td>      <td>0.19</td>    </tr>    <tr>      <td>Looney, Kevon</td>      <td>0.16</td>    </tr>  </tbody></table>

# Everything together


{% highlight r %}
library(networkD3)

setwd('/Users/yuki/Documents/code_for_blog/gsw_passing_network')
passes <- read.csv("passes.csv")
groups <- read.csv("groups.csv")
size <- read.csv("size.csv")

passes$source <- as.numeric(as.factor(passes$PLAYER))-1
passes$target <- as.numeric(as.factor(passes$PASS_TO))-1
passes$PASS <- passes$PASS/50

groups$nodeid <- groups$name
groups$name <- as.numeric(as.factor(groups$name))-1
groups$group <- as.numeric(as.factor(groups$label))-1
nodes <- merge(groups,size[-1],by="id")
nodes$pagerank <- nodes$pagerank^2*100


forceNetwork(Links = passes,
             Nodes = nodes,
             Source = "source",
             fontFamily = "Arial",
             colourScale = JS("d3.scale.category10()"),
             Target = "target",
             Value = "PASS",
             NodeID = "nodeid",
             Nodesize = "pagerank",
             linkDistance = 350,
             Group = "group", 
             opacity = 0.8,
             fontSize = 16,
             zoom = TRUE,
             opacityNoHover = TRUE)
{% endhighlight %}

<!--html_preserve--><div id="htmlwidget-7396" style="width:504px;height:504px;" class="forceNetwork html-widget"></div>
<script type="application/json" data-for="htmlwidget-7396">{"x":{"links":{"source":[11,11,11,11,11,11,11,11,11,11,11,11,11,11,12,12,12,12,12,12,12,12,12,12,12,12,12,7,7,7,7,7,7,7,7,7,7,7,7,7,13,13,13,13,13,13,13,13,13,13,13,13,13,13,2,2,2,2,2,2,2,2,2,2,14,14,14,14,14,14,14,14,14,14,14,0,0,0,0,0,0,0,0,0,0,0,0,0,0,10,10,10,10,10,10,10,10,10,10,10,10,3,3,3,3,3,3,3,3,3,3,3,3,3,3,6,6,6,6,6,6,6,6,6,6,6,6,6,4,4,4,4,4,4,4,4,4,4,4,4,4,4,5,5,5,5,5,5,5,5,5,5,5,8,8,8,8,8,8,8,8,8,8,8,8,8,8,9,9,9,9,9,9,9,9,1,1,1,1,1,1,1,1,1,1,1,1,1,1],"target":[6,4,3,13,8,12,7,0,2,1,5,10,14,9,8,7,0,3,4,6,13,11,1,5,10,9,14,4,6,8,13,1,12,0,5,2,3,11,10,14,6,4,2,8,7,1,5,12,11,3,0,10,9,14,4,6,13,8,7,1,11,3,0,12,4,8,0,6,7,1,3,13,11,12,9,8,7,12,1,4,6,5,3,11,13,2,10,14,9,8,3,7,0,11,13,4,6,12,5,1,2,12,6,11,8,7,13,10,1,0,5,4,2,9,14,4,13,7,8,1,2,11,3,0,5,12,10,14,6,13,2,7,1,11,5,8,0,12,3,14,10,9,4,8,6,7,0,13,3,1,11,12,10,7,6,0,12,1,13,4,5,2,3,10,11,14,9,3,0,11,8,13,4,14,1,4,8,6,7,13,0,3,2,12,11,5,14,10,9],"value":[3.16,3.06,1.7,1.68,1.54,0.84,0.8,0.78,0.7,0.56,0.3,0.16,0.1,0.06,4.34,2.9,1.88,1.52,1.36,0.98,0.92,0.86,0.8,0.16,0.14,0.02,0.02,7.34,6,5.86,3.26,3.22,2.98,2.92,1.8,1.8,1.18,0.8,0.48,0.28,9.3,5.2,3.68,2.3,2.22,1.96,1.12,0.98,0.82,0.68,0.54,0.34,0.02,0.04,13.78,6.64,4.88,2.18,1.94,1.66,1.08,0.56,0.46,0.02,0.54,0.28,0.26,0.24,0.2,0.14,0.08,0.06,0.04,0.02,0.02,3.02,2.6,2.04,1.46,1.2,1.12,0.86,0.72,0.7,0.6,0.3,0.2,0.2,0.14,1.42,1.14,0.8,0.38,0.34,0.34,0.26,0.24,0.18,0.06,0.04,0.02,1.8,1.44,1.36,1.28,1.2,1.06,0.88,0.86,0.74,0.52,0.42,0.28,0.08,0.02,32.94,13.12,7.08,6.58,4.22,3.28,3.08,1.86,1.68,1.62,1.02,0.16,0.18,22.8,12.68,8.2,6.08,5.4,2.5,2.48,2.1,1.48,1.4,0.44,0.26,0.12,0.06,4.38,3.16,1.78,1.66,1.38,0.98,0.88,0.48,0.42,0.12,0.06,5.88,5.4,4.72,4.12,4,3.26,2.88,1.8,1.72,1.6,1.06,1,0.1,0.02,0.22,0.14,0.14,0.08,0.06,0.04,0.02,0.02,6.46,4.36,3.36,2.92,2.62,1.56,1.26,1.26,1,0.56,0.46,0.12,0.04,0.02]},"nodes":{"name":["Barbosa, Leandro","Barnes, Harrison","Bogut, Andrew","Clark, Ian","Curry, Stephen","Ezeli, Festus","Green, Draymond","Iguodala, Andre","Livingston, Shaun","Looney, Kevon","McAdoo, James Michael","Rush, Brandon","Speights, Marreese","Thompson, Klay","Varejao, Anderson"],"group":[0,1,1,0,0,1,1,1,0,1,1,1,1,0,1],"nodesize":[52.3611707850441,75.4378963472945,59.7657818859762,35.3958263109262,469.473001117824,23.9527229345031,397.271752130282,151.459584612675,167.106945458715,2.77559132554324,7.30400213603421,31.7317642269105,44.9684206052305,179.54518132615,3.71062155092688]},"options":{"NodeID":"nodeid","Group":"group","colourScale":"d3.scale.category10()","fontSize":16,"fontFamily":"Arial","clickTextSize":40,"linkDistance":350,"linkWidth":"function(d) { return Math.sqrt(d.value); }","charge":-120,"linkColour":"#666","opacity":0.8,"zoom":true,"legend":false,"nodesize":true,"radiusCalculation":" Math.sqrt(d.nodesize)+6","bounded":false,"opacityNoHover":true,"clickAction":null}},"evals":[],"jsHooks":[]}</script><!--/html_preserve-->


Here is a network visualization using the results of above.  

- Node size: pagerank
- Node color: community
- Link width: passes received & made

# Workflow

## Calling API

I used the endpoint __playerdashptpass__ and saved data for all the players in the team into local JSON files.  
The data is about *who passed how many times* in 2015-16 season

{% highlight python %}
# GSW player IDs
playerids = [201575,201578,2738,202691,101106,2760,2571,203949,203546,
203110,201939,203105,2733,1626172,203084]

# Calling API and store the results as JSON
for playerid in playerids:
    os.system('curl "http://stats.nba.com/stats/playerdashptpass?'
        'DateFrom=&'
        'DateTo=&'
        'GameSegment=&'
        'LastNGames=0&'
        'LeagueID=00&'
        'Location=&'
        'Month=0&'
        'OpponentTeamID=0&'
        'Outcome=&'
        'PerMode=Totals&'
        'Period=0&'
        'PlayerID={playerid}&'
        'Season=2015-16&'
        'SeasonSegment=&'
        'SeasonType=Regular+Season&'
        'TeamID=0&'
        'VsConference=&'
        'VsDivision=" > {playerid}.json'.format(playerid=playerid))
{% endhighlight %}

## JSON -> Panda's DataFrame

Then I combined all the individual JSON files into a single DataFrame for later aggregation.  

{% highlight python %}
raw = pd.DataFrame()
for playerid in playerids:
    with open("{playerid}.json".format(playerid=playerid)) as json_file:
        parsed = json.load(json_file)['resultSets'][0]
        raw = raw.append(
            pd.DataFrame(parsed['rowSet'], columns=parsed['headers']))

raw = raw.rename(columns={'PLAYER_NAME_LAST_FIRST': 'PLAYER'})

raw['id'] = raw['PLAYER'].str.replace(', ', '')

{% endhighlight %}

## Prepare vertices and edges

You need a special data format for GraphFrames in Spark, vertices and edges.  
Vertices are lis of nodes and IDs in a graph.  
Edges are the relathionship of the nodes.   
You can pass additional features like weight but I couldn't find out a way to utilize there features well in later analysis. 
A workaround I took below is brute force and not even a proper graph operation but works (suggestions/comments are very welcome).  

{% highlight python %}
# Make raw vertices
pandas_vertices = raw[['PLAYER', 'id']].drop_duplicates()
pandas_vertices.columns = ['name', 'id']

# Make raw edges
pandas_edges = pd.DataFrame()
for passer in raw['id'].drop_duplicates():
    for receiver in raw[(raw['PASS_TO'].isin(raw['PLAYER'])) &
     (raw['id'] == passer)]['PASS_TO'].drop_duplicates():
        pandas_edges = pandas_edges.append(pd.DataFrame(
        	{'passer': passer, 'receiver': receiver
        	.replace(  ', ', '')}, 
        	index=range(int(raw[(raw['id'] == passer) &
        	 (raw['PASS_TO'] == receiver)]['PASS'].values))))

pandas_edges.columns = ['src', 'dst']

{% endhighlight %}

## Graph analysis

Bring the local vertices and edges to Spark and let it spark.  

{% highlight python %}
vertices = sqlContext.createDataFrame(pandas_vertices)
edges = sqlContext.createDataFrame(pandas_edges)

# Analysis part
g = GraphFrame(vertices, edges)
print("vertices")
g.vertices.show()
print("edges")
g.edges.show()
print("inDegrees")
g.inDegrees.sort('inDegree', ascending=False).show()
print("outDegrees")
g.outDegrees.sort('outDegree', ascending=False).show()
print("degrees")
g.degrees.sort('degree', ascending=False).show()
print("labelPropagation")
g.labelPropagation(maxIter=5).show()
print("pageRank")
g.pageRank(resetProbability=0.15, tol=0.01).vertices.sort(
    'pagerank', ascending=False).show()

{% endhighlight %}

## Visualise the network

When you run [__gsw_passing_network.py__](https://github.com/yukiegosapporo/gsw_passing_network/blob/master/gsw_passing_network.py) in my github repo, you have *passes.csv*, *groups.csv* and *size.csv* in your working directory.  
I used *networkD3* package in R to make a cool interactive D3 chart.  

{% highlight r %}
library(networkD3)

setwd('/Users/yuki/Documents/code_for_blog/gsw_passing_network')
passes <- read.csv("passes.csv")
groups <- read.csv("groups.csv")
size <- read.csv("size.csv")

passes$source <- as.numeric(as.factor(passes$PLAYER))-1
passes$target <- as.numeric(as.factor(passes$PASS_TO))-1
passes$PASS <- passes$PASS/50

groups$nodeid <- groups$name
groups$name <- as.numeric(as.factor(groups$name))-1
groups$group <- as.numeric(as.factor(groups$label))-1
nodes <- merge(groups,size[-1],by="id")
nodes$pagerank <- nodes$pagerank^2*100


forceNetwork(Links = passes,
             Nodes = nodes,
             Source = "source",
             fontFamily = "Arial",
             colourScale = JS("d3.scale.category10()"),
             Target = "target",
             Value = "PASS",
             NodeID = "nodeid",
             Nodesize = "pagerank",
             linkDistance = 350,
             Group = "group", 
             opacity = 0.8,
             fontSize = 16,
             zoom = TRUE,
             opacityNoHover = TRUE)

{% endhighlight %}


# Code

The full codes are available on [github](https://github.com/yukiegosapporo/gsw_passing_network).

<!-- htmlwidgets dependencies --> 
{% include htmlwidgets/analyzing-golden-state-warriors-passing-network-using-graphframes-in-spark.html %}
