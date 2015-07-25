---
layout: page
title: Authors
excerpt: "Nerd and nerdettes poisoned by data"
search_omit: true
---

{% for a in site.data.authors %}
{% assign author = a[1] %}
<div>
{% if author.avatar contains 'http' %}
          <img src="{{ author.avatar }}" class="bio-photo" alt="{{ author.name }} bio photo">
{% else %}
          <img src="{{ site.url }}/images/{{ author.avatar }}" class="bio-photo" alt="{{ author.name }} bio photo">
{% endif %}
</div>

<div><b>{{ author.name }}</b><br>{{ author.bio}}</div><br>
{% endfor %}
