---
title: Static URL shortening with nginx maps
date: 2023-07-02
url: /bits/2023/07/02/static-url-shortening-nginx-maps.html
---

In 2012 when it was hip and cool to do so, I also had my own URL shortener. It
was based on what I called ["katana"](https://github.com/mrtazz/katana), a
convenience ruby wrapper around
["guillotine"](https://github.com/technoweenie/guillotine/) that made it easy
to run it on Heroku backed by Redis. Back then Heroku still had a free tier and
RedisToGo was available as a free add-on for databases up to 5MB or so. It was
really fun to run, it had [its own endpoint to support Tweetbot's custom URL
shortening
integration](https://github.com/mrtazz/katana/blob/master/app.rb#L28-L39) and
the free tier was more than good enough for the occasional shortening.

Over the years however I used it less and less, mostly because Twitter had
started forcing its own URL shortening with auto-expansion when viewing a tweet
on everything. And the experience of using a custom shortener was not on par
with that. I've also almost lost the database of the shortener a couple of
times because free tiers don't usually come with backups. So I rigged up a
quick GitHub Action that ran once a day,
[`redis-dump`-ed](https://github.com/jeremyfa/node-redis-dump
"node-redis-dump") all the contents to plain text and committed them to a git
repo as a low budget backup job. At this point I wasn't really shortening
anything anymore but wanted to keep the existing URLs functional. I had moved
to Heroku's own Redis service at that point and there was no real work involved
to keep it running.

Fast forward to 2022 Heroku [announced](https://blog.heroku.com/next-chapter
"Heroku’s Next Chapter") the end of the free tiers. And while I'm generally
happy to pay for things I wasn't convinced that just maintaining what was
essentially by now a barely used URL lookup app  was worth the $7/month for me.
So I shut it down and thought about alternatives. I could run the app on my
server that I use for a couple of things. But I really don't want to run a ruby
app + redis in my free time. I thought about implementing the shortener logic
in Go and back it by something like sqlite or even just a yaml file. But again
that felt like a lot of effort for not actually shortening anything.

And then I thought "this is just hosting 301 redirects, surely something nginx
is good at". And sure enough, after a quick internet search I found [a
stackoverflow
post](https://stackoverflow.com/questions/29354142/nginx-how-to-mass-permanent-redirect-from-a-given-list)
that provided a good example for managing a lookup map in a handful of lines of
code. The core of it is basically:

```
# head -n 5 /usr/local/etc/nginx/mrtz_cc_redirect_map.conf
/-KmaJA 'http://lusis.github.com/blog/2014/04/13/omnibus-redux/';
/-vvREg 'http://hannahmontana.sourceforge.net/';
/-yW3mQ 'http://s3itch.unwiredcouch.com/1._tmux-20140719-180429.jpg';
/09nQKA 'http://s3itch.unwiredcouch.com/Projects-20141130-133209.jpg';
/0YK2gg 'https://speakerdeck.com/mrtazz/statsd-workshop-monitorama-2013';

# wc -l /usr/local/etc/nginx/mrtz_cc_redirect_map.conf
424 /usr/local/etc/nginx/mrtz_cc_redirect_map.conf


# cat /usr/local/etc/nginx/sites/redirect
map_hash_bucket_size 256; # see http://nginx.org/en/docs/hash.html

map $request_uri $new_uri {
    include /usr/local/etc/nginx/mrtz_cc_redirect_map.conf;
}

server {
  listen 94.130.5.59:443 ssl;
  server_name mrtz.cc;

  if ($new_uri) {
    return 301 $new_uri;
  }

  ...
}

```

So all I had to do was convert the plain text backup of my redis instance into
the nginx map format, which was easy enough with this `awk` one-liner:

```
% head -n 5 backups/mrtz.cc/mrtz.cc.dump
SET     guillotine:hash:-KmaJA 'http://lusis.github.com/blog/2014/04/13/omnibus-redux/'
SET     guillotine:hash:-vvREg 'http://hannahmontana.sourceforge.net/'
SET     guillotine:hash:-yW3mQ 'http://s3itch.unwiredcouch.com/1._tmux-20140719-180429.jpg'
SET     guillotine:hash:09nQKA 'http://s3itch.unwiredcouch.com/Projects-20141130-133209.jpg'
SET     guillotine:hash:0YK2gg 'https://speakerdeck.com/mrtazz/statsd-workshop-monitorama-2013'

% awk '/guillotine:hash/ { split($2,a,/:/); print "/"a[3]" "$3";"}' < backups/mrtz.cc/mrtz.cc.dump | head -n 5
/-KmaJA 'http://lusis.github.com/blog/2014/04/13/omnibus-redux/';
/-vvREg 'http://hannahmontana.sourceforge.net/';
/-yW3mQ 'http://s3itch.unwiredcouch.com/1._tmux-20140719-180429.jpg';
/09nQKA 'http://s3itch.unwiredcouch.com/Projects-20141130-133209.jpg';
/0YK2gg 'https://speakerdeck.com/mrtazz/statsd-workshop-monitorama-2013';
```


And then chef out the nginx config and Let's Encrypt setup for the domain to my
server, change the DNS records to the server instead of Heroku[^1]. And
voila:

```
% curl -sv https://mrtz.cc/-vvREg 2>&1 | grep Location
< Location: http://hannahmontana.sourceforge.net/
```


I really like this setup because running nginx is pretty straight forward for
the small scale I use it at. And I care about keeping URLs working. So this
makes me happy. I might at some point maybe want to start using it and adding
URLs again. At which point I have to figure something out. But I don't expect
that to be any time soon (if at all).




[^1]: There were actually some hiccups in the middle where I still had the
DNS configure in dnsimple but had apparently let the domain lapse 😅. But
re-registering it with dnsimple was super fast and I just had to wait a bit
then for the registration to propagate.

