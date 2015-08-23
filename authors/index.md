---
layout: page
title: Authors
excerpt: "Nerds and nerdettes poisoned by data"
search_omit: true
---
{% for a in site.data.authors %}
{% assign author = a[1] %}
<div class="authorinfo" id = "{{ a[0] }}">
{% if author.avatar contains 'http' %}
          <img src="{{ author.avatar }}" class="bio-photo" class="author-photo" alt="{{ author.name }} bio photo">
{% else %}
          <img src="{{ site.url }}/images/{{ author.avatar }}" class="bio-photo" alt="{{ author.name }} bio photo">
{% endif %}

<span><b>{{ author.name }}</b>
{% if author.twitter %}
  <a href="https://twitter.com/{{ author.twitter }}" title="Follow me on Twitter" itemprop="Twitter"><i class="fa fa-twitter-square"></i></a>
{% endif %}
{% if author.github %}
  <a href="https://www.github.com/{{ author.github }}" title="Watch my code" itemprop="Github"><i class="fa fa-github-square"></i></a>
{% endif %}
{% if author.linkedin %}
  <a href="https://www.linkedin.com/in/{{ author.linkedin }}" title="Contact me on LinkedIn" itemprop="Linkedin"><i class="fa fa-linkedin-square"></i></a>
{% endif %}
<br>{{ author.bio}}
</span>
</div>

<br>
{% endfor %}
