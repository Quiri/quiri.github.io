---
layout: page
title: Authors
excerpt: "Nerd and nerdettes poisoned by data"
search_omit: true
---

{% for author in site.data.authors %}
<div>{{ author[1].name }}<br>{{ author[1].bio}}</div><br>
{% endfor %}
