---
date: 2023-01-02
title: The Pedestrian Programmer
url: /2023/01/02/pedestrian-programmer.html
---

## Endless fiddling
In the field of software engineering there is a common theme of fiddling with
your tools and setup until they are juuuuust right, and only then can the work
of writing code commence. Or the next level of productivity be unlocked. I
don’t think this is something particularly special to software engineering.
It’s probably just a different form of cleaning up your desk before writing,
sorting all of the paperwork before doing your taxes, or re-organizing the
kitchen before cooking. Basically procrastination. And the hope that what’s
missing for productivity and "getting in the zone" is just this one weird trick
to improve the setup.

I've done this a lot as well especially early in my career, where I've had
convoluted setups that were very intricate and fine tuned to what I thought
made me the most productive. Be it
[tmux](https://unwiredcouch.com/2013/11/15/my-tmux-setup.html "My Tmux setup on
unwiredcouch.com"), or [IRC
notifications](https://unwiredcouch.com/2012/11/03/irc-notifications-with-logstash.html
"IRC notifications on unwiredcouch.com "), or of course [my way of managing
tasks](https://unwiredcouch.com/setup/omnifocus/ "Omnifocus setup on
unwiredcouch.com"). But the downside was always that the setups became more and
more brittle with everything that was added. A plugin would break behavior when
updated, a tool doesn't work or isn't available on macOS or Linux, an
integration breaks through an API change. And over time the upkeep of the setup
starts to become a bigger and bigger chore. And I noticed that at some point I
stopped bothering with it. My setup slowly "deteriorated" to the minimal
working state that kept me productive. I didn't use my fancy integrations
anymore. I could hardly remember why I installed some of the editor plugins.
And I actually was as productive if not more. And so the state I arrived at is
that I write all code in terminal vim in tmux now and that basically any Apple
laptop with even a small screen will do (my forever favorite being the 11"
MacBook Air and I absolutely can’t stand having more than one display) and I
can be set up within about 20 minutes by basically just configuring:

- low key repeat delay and quick type rate
- caps lock remapped to control
- git clone https://github.com/mrtazz/dotfiles && make install

And not much more. My dotfiles configure vim, zsh, some git aliases, and
install some useful tools (via homebrew/linuxbrew) that I could do without but
sometime enjoy using like `fzf`  and `ripgrep`.  They also get installed on
every [codespace](https://github.com/features/codespaces "GitHub Codespaces") I
create (at GitHub that is my main development environment) so when I ssh into
it, the terminal is set up in the same way. On macOS they install some apps I
use like iTerm2, 1Password, Alfred, and the Phoenix window manager with configs
that I haven't really changed in years. They are also mostly niceties that I
can probably more or less do without (except 1Password). E.g. for months when
codespaces was new and only available through VSCode I wrote code in a
fullscreen VSCode terminal window running vim within it. And I was basically as
productive as ever (maybe even a bit more given I had access to quick and
disposable codespaces). Even with browsers I don’t really use any extensions or
anything and change them without even thinking about it. I had some work
specific configuration in Safari break a while ago. And instead of spending
ages debugging it, I just switched to Firefox and moved on with my work.

And that is more or less the pretty barebones setup I use to write code and
which I describe as a "pedestrian programmer" programmer style when I get asked
about it.

## Programming
But this notion doesn’t stop at the setup for me. It’s also how I write code.
As I’ve mostly worked in infrastructure engineering over the last decade (even
though I've switched to a product platform team at the beginning of 2022), I’ve
had to jump between many different languages in the same day. It’s usually some
mix of ruby, python, shell, golang, javascript, PHP, and various config
formats. And I use that same setup for all of it. Furthermore, I also write
very similar code in all of these languages. I’ve mostly come to utilize the
common denominator of syntax and code structure to implement things regardless
of language (they are all C-style languages anyways so they aren't vastly
different). And only really start using language specific constructs where
needed. So my python classes look like my ruby classes, look like my PHP
classes. If I can help it I don’t use concepts like python’s decorators, or
ruby blocks (or even heavy use of higher order functions that most languages
support at this point) in code I define and control. In my mind, trying to
convey the solution that is implemented in code in as simple constructs as
possible makes it a lot more accessible and friendly to get started with. I
hope that even if someone comes from having written python their whole career,
my ruby and PHP still is very accessible. If it becomes a performance or
maintenance problem, it can still be changed to use more specialized constructs
and concepts later on. And maybe even more easily because the original
structure is fairly simple. But for as long as possible I try to keep code as
“pedestrian” as possible so it’s easy to read, follow along, reason about, and
change.

Similarly I don’t really use design patterns a lot when I write code. I
remember the days in university when design patterns were all the rage. And
books about them the most important text one could ever read about programming.
I also remember trying really hard to force the [Singleton
pattern](https://en.wikipedia.org/wiki/Singleton_pattern "The Singleton
Pattern") into every university programming project because it’s what
professors wanted to see. Nowadays I will try and solve the problem with as
simple of an architecture as I can. And then only change to a more intricate
pattern if it serves understanding or maintenance. I most of the time don’t
recall what a design pattern does when I hear the name. Not that I don’t
understand what they do or how they are useful. Or that I don’t end up
implementing them along the way. But I’ve found it to be more confusing than
helpful to throw design pattern names as jargon around instead of writing code
in a form that solves the problem and comment it along the way.

## Take away
My main point in all of this is not that it’s bad to have a very intricate
setup, or that you shouldn’t take joy in fiddling with it. But it’s important
to recognise when the hunt for the mythical “zero-friction” state gets in the
way of getting things done (and sometimes a little friction is not a bad
thing). On the other hand it also doesn’t mean that the most elite and true way
to write code is just using vim and the most barebones setup there is. Neither
would I advocate to never use design patterns or take time to build a
sophisticated architecture. The point I’m trying to bring across with the
description of my approach is that it doesn’t take intricate setups and complex
architectures to write production code that solves problems. Everyone is
different and different approaches result in the same useful code. There is no
rule of “the better the programmer, the more sophisticated the setup”. I’ve
worked with programmers I respect immensely that wrote code in Notepad.exe or
used the default 8 line vim config. I also enjoy reading about other’s setups
regardless of how complicated they are because there might be something in
there I’d love to try. And when I work in a team where we decide on design
patterns and a more complicated architecture or code style as a trade off for
some other problems, I’m happy to go along with it. It’s just not my first
choice.

Because in the end a setup doesn’t make you productive and code isn’t “the
better solution” because it’s complicated. You are productive with it because
it fits the way you (and the people on your team when it comes to shared code)
think and approach problems. There are no unreal programmers, if you write code
with whatever tools you like and in whatever shape you prefer, you’re still a
programmer as much as everyone else.  Even if you are - like me - a proud
pedestrian programmer.
