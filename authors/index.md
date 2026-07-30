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

{% if author.twitter %}[<i class="fab fa-twitter"></i> @{{ author.twitter }}](https://twitter.com/{{ author.twitter }}){% endif %}
{% if author.github %} · [<i class="fab fa-github"></i> {{ author.github }}](https://github.com/{{ author.github }}){% endif %}
{% if author.linkedin %} · [<i class="fab fa-linkedin"></i> LinkedIn](https://linkedin.com/in/{{ author.linkedin }}){% endif %}

---

{% endfor %}
