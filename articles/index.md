---
layout: page
title: All Articles
excerpt: "An archive of articles sorted by date."
search_omit: true
---

<ul class="post-list">
{% for post in site.categories.articles %} 
   <li>
  <article>
    <a href="{{ site.url }}{{ post.url }}"> {{ post.title }} 
      <span class="entry-date">
	<time datetime="{{ post.date | date_to_xmlschema }}"> {{ post.date | date: "%B %d, %Y" }} </time>
     </span>
     <div class="sub">
     {% if post.excerpt %} 
       <span class="excerpt"> {{ post.excerpt }} </span>
     {% endif %}
     {% if post.author %}
       <span class="authorshort">by {{post.author}} </span>
     {% endif %}
     </div>
     </a>
  </article>
  </li>
{% endfor %}
</ul>
