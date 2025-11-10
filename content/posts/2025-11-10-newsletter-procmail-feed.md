---
title: Newsletter feeds with procmail and Feedbin
date: 2025-11-10
url: "/2025/11/10/newsletter-feeds-procmail-feedbin.html"
---

I'm a huge fan of [web feeds][webfeeds] to keep up with content that interests
me. I've been using them since the fairly early days of [Google
Reader][greader] and yes I was also sad and disappointed when the service got
shut down. However in my opinion the landscape of web feeds today is vastly
better than what we had 15 years ago even though it's a well loved cliché to
still bemoan the demise of Reader. I still read web feeds daily today. This
includes blogs and news pages and also YouTube channels (I found out about
this not that long ago at a time I had almost abandoned following YouTube
channels because I found the experience of following channels so
insufferable). For many years now I'm a happy paying customer of
[Feedbin][feedbin] to have my feeds available on all my devices but read it
99% of the time through [Reeder Classic][reeder] on my iPhone. I really like
the service and also use one of their features heavily, which is the ability
to configure email addresses to subscribe to newsletters and have them show up
as feeds as well. I've been using that fairly heavily and switched a bunch of
my subscriptions over to it. This however came with two inconveniences for me:

1. The effort of unsubscribing and re-subscribing to existing newsletters
2. Sometimes newsletters aren't easily separated from the address I use for
   generally using a service (like a shop I buy from but also get newsletters)
3. My newsletters are linked to an email address that is not mine

So I wanted an easier way to benefit from the service with less hassle and
also make it easier to decide to stop reading newsletters through the service
without doing another unsubscribe and re-subscribe cycle. Luckily for me I
still run my own IMAP server that runs [procmail][] for filtering my emails. I
mostly use it to filter out some spam and move messages from mailing lists I
am subscribed to into their own folders.

In order to take advantage from the setup for getting my newsletters into
feedbin more easily I first created a new email address in Feedbin as a kind
of catch all for newsletters. Next up I configured a procmail rule for each
email address I get newsletters from with the following form:

```
:0
* ^From.*news@coolwebpage.de
* ^List-Unsubscribe.*
{
  :0 c
  ! cool.address.333@feedb.in
  :0:
  $HOME/Mails/newsletters/
}
```

This matches any email sent from the configured address that has a
`List-Unsubscribe` header as well. While this isn't a perfect fit it's a
requirement for newsletters being treated properly by major mail providers and
not marked as spam. Having both rules in there also makes sure that emails
that aren't newsletters from that same address (say purchase receipts from a
shop) don't get matched. Then there is a rule body that first forwards the
mail to Feedbin to turn into a feed item. And then also files it into a
`newsletter` folder. That second part is mostly a backup for me so I have the
messages handy still if something gets lost somewhere.

So now if I notice a newsletter in my inbox, I can just add the sender address
to a list and my configuration management system on my IMAP server generates a
new procmail rule to filter it and send it to Feedbin from now on. And while
procmail definitely doesn't have the easiest syntax to understand and get
going with, I really enjoy this workflow it enables for me. And many mail
providers also allow this sort of things with their rule system.

Happy feed reading!


[feedbin]: https://feedbin.com/home
[webfeeds]: https://en.wikipedia.org/wiki/Web_feed
[reeder]: https://www.reeder.app/classic/
[greader]: https://en.wikipedia.org/wiki/Google_Reader
[procmail]: https://en.wikipedia.org/wiki/Procmail
