---
layout: single
title: "Authors"
excerpt: "Nerds and nerdettes poisoned by data"
permalink: /authors/
author_profile: false
---

{% for a in site.data.authors %}
{% assign author = a[1] %}

### {{ author.name }}

{{ author.bio }}

{% if author.linkedin %}[<i class="fab fa-linkedin"></i> LinkedIn](https://linkedin.com/in/{{ author.linkedin }}){% endif %}

---

{% endfor %}
