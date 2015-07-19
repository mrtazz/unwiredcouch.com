---
layout: default
title: writing
---
<div class="archive">
  {% for post in site.posts %}
    {% capture this_year %}{{ post.date | date: "%Y" }}{% endcapture %}
    {% capture next_year %}{{ post.previous.date | date: "%Y" }}{% endcapture %}

    {% if forloop.first %}
    <h2 class="hidemobile">{{this_year}}</h2>
    <ul>
    {% endif %}

      <li>
      <a href="{{ post.url }}"> {{ post.title }}</a>
      <span class="archivedate hidemobile">{{ post.date | date: "%b %d, %Y"}}</span>
      </li>

    {% if forloop.last %}
    </ul>
    {% else %}
        {% if this_year != next_year %}
        </ul>
        <h2 class="hidemobile">{{next_year}}</h2>
        <ul>
        {% endif %}
    {% endif %}
  {% endfor %}
</div>

