---
date: 2016-03-18
layout: post
title: I don't like Breaking Things
---

I don't like breaking things. I never have. I hate it. When I was a kid and we
got our first computer I was completely [afraid of breaking
it][breaking_afraid]. It was a super expensive item at the time and I had no
idea how it worked. And I didn't know if I would completely break it and we
didn't really have the money to get a new one if I did. Sure I was curious and
I was fascinated by it. I wanted to do cool things on this computer. But I
didn't want to break it. My sister was also using it and playing games on
there and I didn't have the hubris that I definitely would be able to put it
back together if I broke it. Looking at the trade-off between probably
learning something but also ruining my sister's day it just wasn't worth it.
It wasn't that I didn't want to know how it worked, it was [about
respect][computer_respect]. And it's not like I never broke the computer or
anything on it. But I never approached it lightly and was very uncomfortable
when it happened. And I sure wasn't proud of it.

Fast forward 25 years or so I have gone to a bunch of LAN parties as a kid,
went to university to study computers and eventually got a master's degree in
computer science. I'm running [most of my own infrastructure][uncloud], have
built my own home router, had DNS servers from a Dutch ISP take zone transfers
from a [computer running in a camper van toilet][van_toilet], and upgraded PHP
on a big e-commerce website without downtime. It's fair to say I've learned a
couple of things and know my way around computers most of the time. And yet I
am still deeply uncomfortable breaking things.

### What's wrong with breaking things?
Ironically I now work in an industry that basically worships breaking things.
From famous company mottos like "move fast and break things" to phrases that
get quoted out of context like "ask for forgiveness, not permission" everybody
seems to love being able to break stuff. What it doesn't take into account is
that breaking things doesn't happen in a vacuum. Your actions always impact
others. Even if you're on-call, the nature of our complex systems means that
nobody has a perfect overview over all interactions. And nobody can be sure
they will be the only one to get paged and not someone else downstream who is
just sitting down to eat with their family. And claiming you can is in my
opinion more an unhealthy sign of hubris than healthy engineering. More likely
than not it's gonna ruin someone else's day.

In addition the romantic picture of the engineer who is not afraid of breaking
things and thus disrupting whole industries on the way is not an evenly
distributed one. As [Kate Losse][kate_losse] already wrote in ["the unbearable
whiteness of breaking things"][whiteness] it's usually just the white men
again who are able to get away with it. For everyone else this is likely gonna
end less well.

It's also a very unhealthy and non-collaborative way of approaching things. It
assumes a very negative default instead of working together. And it keeps
reinforcing a stereotype that only works because there's a team of people
picking up the pieces once the magic disruptive engineer is done.

### But it's the only way to learn
Now you might say "Hold up there. Breaking things is the only way to learn.
You don't know a technology until you've seen it break." And I partly agree
with you there. However there is a big difference between doing gamedays where
things are turned off and shut down in a controlled environment, where
everybody got a heads up this is going on, and systems are observed as a team
to learn how they behave. This is a great way to learn about technology. And I
encourage everyone to do this. Equally if things *do* break it's paramount to
investigate those incidents in a blameless way to maximize the things to learn
from it.

However: Just testing in prod. Not bothering to write unit tests. Not going
through staging before going to prod. Rolling out a change to all servers at
once just to save some time. Those are the things no one learns a lot from.
Other than the fact that you can quickly make a day awful for a bunch of
people. And that you might be a shitty coworker.

Let me be very explicit. I don't think you can *prevent* every failure from
happening. I don't think people should be punished if something breaks during
their daily work. Things break. There's nothing you can do about that. What I
don't condone is approaching everything with the attitude that it's ok to
actively break things. That it should be the default. That your need of
changing something is more important than someone else's need of not being
interrupted. That it's ok to lean all the way towards efficiency and away from
thoroughness. This is not disruption it's just lack of empathy. The default
should always be to try and not break anything. There should be a way to make
it as easy as possible to catch errors early on. To test things before they go
to prod. To get confidence in something without disrupting someone else's day.
And if there isn't, maybe this is something  to spend time on making better
first. It beats breaking things by a long shot. And is actually something to
be proud of.




[breaking_afraid]: https://twitter.com/mrtazz/statuses/611190610964430848
[c64_hacking]: https://twitter.com/mrtazz/statuses/611190546372132864
[computer_respect]: https://twitter.com/mrtazz/statuses/611190760734650368
[uncloud]: https://unwiredcouch.com/2013/10/30/uncloud-your-life.html
[van_toilet]: https://www.flickr.com/photos/mrtazz/214028839/in/album-72157594235164764/
[whiteness]: https://medium.com/@katelosse/the-unbearable-whiteness-of-breaking-things-521cb394fda2#.pujsyenre
[kate_losse]: https://twitter.com/katelosse
