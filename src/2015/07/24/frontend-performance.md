---
layout: post
published: true
title: Adventures in Frontend Performance
---

In my daily job I am far removed from being a frontend engineer. In a previous
job I had spent months to optimize JavaScript to be small enough to be served
by an [embedded microcontroller][capt2web] (there's a certain irony in the
fact that I don't have the original paper anymore and thus can't read my own
paper without paying now, but that's a different topic). But those days are
long gone. My main tools today are Chef, PHP and shell script most of the
time. This means that I unfortunately don't have a great amount of experience
on how to structure web frontends to be fast. But it's one of the things I'm
working on getting better at. Fortunately I work with a lot of talented
people. And one of them, my coworker and friend [Lara Hogan][lara_twitter],
literally wrote the book on ["Designing for Performance"][dfp]. So I decided
to start there and bought it and read it last week. It's a great and fast read
and gives you a really great introduction into how to structure web content to
be fast.

After I was done reading it, I decided to try out what I've learned and see if
I can make my blog faster. So I installed [YSlow][yslow] and ran it on an
[example blog post][example_post]. I don't often have a lot of images in my
posts. It's mostly text and maybe some inline code snippets. So I decided that
this was a good representative post for testing my improvements. And the YSlow
results weren't great. In my current setup loading this simple page resulted
in the following YSlow result:

```
12 HTTP requests and a total weight of 157.2K bytes with empty cache
```

At least I now had a baseline to compare my changes to. The book has a very
good chapter on how to cleanup CSS and how it can affect page weight and page
load times. So I started there. I didn't really have good structure in my CSS
as it has basically organically grown since 2009. And whenever I wanted to
change something or try out something new, I just added the CSS for it on top
of the existing one. I've rarely gone back and cleaned things up. This lead to
me having 3 CSS files being loaded for every page. The main style declarations
aptly named `style.css`, a CSS file which contained definitions for all the
code highlighting I'm using on my site `pygments.css` and a third file from
when I started playing with fonts that would declare font-faces and such and
was named - you guessed it - `fonts.css`. When I added those files it made
sense to me to have them separate. They were taking care of different things,
contained no duplicate code, I was basically treating them like includes in a
programming language. So I took a look at the files and found a lot of old
clutter. I was still loading two fonts which I hadn't used in forever.  And I
also had recently reworked my header but was still loading the font that gave
me icons for popular social media sites which I had previously used for
linking. Those together were already around 75kB and 3 HTTP requests for
nothing. So I removed the fonts I wasn't using, cleaned up some other CSS that
I had found that was unused and combined the 3 style files I had into 1. And
that already gave me a huge jump in optimization. Just by removing things that
I didn't need and combining CSS files I went to:

```
7 HTTP requests and a total weight of 65.4K bytes with empty cache
```

I was already amazed and excited and of course now I wanted to do more. So I
installed a CSS minifier and decided to load only minified CSS. This gave me
another 15 kB in improvements:

```
7 HTTP requests and a total weight of 50.0K bytes with empty cache
```

Another thing that is mentioned in the book as a common way to improve
performance is to load images for the size you actually want to display them
at and not bigger. I didn't want to go through all the images I had in some
random blog posts but still do something for my baseline performance. And
since I load my avatar from Gravatar into the header on every load, I looked
at that and saw that I was requesting the image in size 142x142 (Gravatar
gives you the handy URL parameter `?s=142` for that) but was only displaying
it in 100x100. So I changed the parameter to 100 and squeezed a couple more
kilobytes out of my site:

```
7 HTTP requests and a total weight of 47.7K bytes with empty cache
```

Now I was kind of at a stopping point. I had collected all the low hanging
fruit. My page was only a third as big as it was before and I was down 5 HTTP
requests that didn't have to be done anymore. This was already huge for me.
Looking at YSlow now told me that I was spending another HTTP request for
loading JavaScript from Twitter to embed their social media buttons. And that
this also added about 35 kB to my page weight. At this point about 75% of my
total page weight. Of course as a first course of action, [I tweeted about
it][fep_tweet] and thought about whether or not I really need or want the
share buttons on there. Fortunately [Corey][atmos] responded to my tweet with
essentially what I was thinking. That I don't really need those buttons for
anything. So I removed the buttons, bringing my total YSlow results to:

```
6 HTTP requests and a total weight of 12.4K bytes with empty cache
```

And I was blown away when I actually saw the number. Just by following some
simple advice from the book, I was able to cut the number of HTTP requests in
half. And slim down my page weight to ~8% of what it was before.

### Learning new things is fun

Optimizing my site has been a lot of fun. Of course if you are an experienced
frontend engineer, all of those things are not surprising and probably the
first thing you would try. But not working in that field every day, I was
surprised by the impact such a cleanup and restructuring can make on even a
small site like mine. I had tried to dabble a little bit in getting better at
frontend engineering and performance before. However I had never had a good
introduction to give me a place to start. Learning new things can be
overwhelming and especially if you don't know where to start, everything can
feel like it's probably wrong. Lara's book gave me a great introduction into
all the different topics of frontend performance and if you are interested in
this as well, I can highly recommend it.

For now I might not be able to squeeze out more performance just from reducing
the page weight. I've since installed `mod_deflate` and `mod_expire` on my web
server to improve transfer size and caching for my site. However I still feel
like structuring HTML and CSS in a good and fast performing way is something I
don't have a good grasp on. And it's definitely something my site can benefit
from, if even for more clarity next time I want to change anything. So this
might be the next thing I'll tackle in learning more about frontend
engineering.


[lara_twitter]: http://twitter.com/lara_hogan
[dfp]: http://larahogan.me/design/
[fep_tweet]: https://twitter.com/mrtazz/status/622603993215303681
[example_post]: https://www.unwiredcouch.com/2015/06/08/accounting-the-unix-way.html
[yslow]: http://yslow.org
[capt2web]: http://dl.acm.org/citation.cfm?id=1582405
[atmos]: https://twitter.com/atmos
