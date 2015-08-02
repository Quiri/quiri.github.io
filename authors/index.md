---
layout: page
title: Authors
excerpt: "Nerds and nerdettes poisoned by data"
search_omit: true
---
{% for a in site.data.authors %}
{% assign author = a[1] %}
<div class="authorinfo">
{% if author.avatar contains 'http' %}
          <img src="{{ author.avatar }}" class="bio-photo" class="author-photo" alt="{{ author.name }} bio photo">
{% else %}
          <img src="{{ site.url }}/images/{{ author.avatar }}" class="bio-photo" alt="{{ author.name }} bio photo">
{% endif %}

<span><b>{{ author.name }}</b>
  <a href="https://twitter.com/{{ author.twitter }}" title="Follow me on Twitter" itemprop="Twitter"><i class="fa fa-twitter-square"></i></a>
<br>{{ author.bio}}
</span>
</div>

<br>
{% endfor %}
