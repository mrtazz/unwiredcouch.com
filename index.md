---
layout: default
title: writing
---
<div class="archive">
  <ul>
  {% for post in site.posts %}
      <li>
      <a href="{{ post.url }}"> {{ post.title }}</a>
      <span class="archivedate hidemobile">{{ post.date | date: "%b %d, %Y"}}</span>
      </li>
  {% endfor %}
  </ul>
</div>
