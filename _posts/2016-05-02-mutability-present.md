---
layout: post
title: Optimize for Mutability and the Present
---

I recently read [John Vincent's][lusis] very interesting and honest blog post
about [being paralyzed because of seeing all the flaws in
systems][flaw_all_things]. At first I decided to just put it away as it's not
a problem I encounter a lot. But in the last paragraph he asked how others
deal with this. And that was the point in which I started thinking about why
this doesn't bother me as much. And it occupied my brain in those precious
shower and dish washing moments thinking about why this - although I know the
feeling well - is the case. I more or less thought about it all weekend and
this is my attempt to give my perspective on it in a somewhat coherent form. I
hope it's in any way helpful and you should absolutely read John's post first
to understand the context of this post.

The short answer is that I optimize for the present and for mutability, which
in itself is probably a completely useless answer. So let me try to elaborate
what I mean by this. My day job is working in infrastructure engineering,
specifically on a team that works on making writing code and deploying it as
much fun as possible. This means while I'm technically a software engineer,
the lines between software engineering and operations are blurry at best in my
day to day work (which is a good thing and I very much enjoy it). I have
worked on a bunch of systems, designed some of them, see almost all of them
break in various ways and participate in as many architecture reviews as
possible to give input on other people's system designs. The main goal of my
work however is to contribute to engineering happiness. This means I'm very
aware of the intersection of technology and humans using it. In addition to
that, working mostly on internal things means when the things I work on break,
a lot of my coworkers are blocked from getting their stuff done. This can be
petrifying. When I set out to write a new thing or fix up an existing one, I
can test it out for my workflow but can also inevitably see how it could and
will break for someone with a different workflow, editor, or set of dotfiles.
And what makes it worse is that I won't notice immediately and when it breaks
for someone I might be in a meeting, unable to help right away. And I really
[hate breaking things][breaking_things].

So there I have 2 choices. Ship a thing that's gonna break in some way. Or
don't ship anything. And the way I make myself be ok with shipping something
that is flawed is by of course making sure I do a reasonably extensive attempt
of testing it. But also make it as easy as possible to change or adapt later,
to decide whether my original trade offs are still the right way to go and to
rip things out if not. But not necessarily by trying to cater for all possible
future use cases (the famous "premature optimization") and sure as hell not by
writing throw away code. Because everybody can tell you the only thing harder
than building something is decommissioning it, and that goes doubly so for
throw away code. How I try to achieve this is by dropping all of my context
into [documentation and automation][doc_writing] in some form. This means code
comments.  Documenting my thought process on the JIRA ticket that relates to
it. Writing thorough [detailed commit message][commit_message] about my
change. Writing unit tests that are being run on CI. A proper README. A
thought through Chef recipe. A Makefile with all important tasks. A runbook.
Those kinds of things. So that when someone else has to go and fix something
(that could be future me or a coworker), they don't have to spend minutes to
hours to get up to speed on the context, decisions, and trade-offs I had and
made to understand why I opted for this solution to the problem. So I'm very
happy to write a 20 line commit message that links to the ticket and the
CI/try run and mentions the people I consulted while working on this - even
for a single line of change. I'm excited to add unit tests even when I'm
"only" writing a vim plugin or a shell script. And I'm excited when I get to
write man pages.

Because if I'm honest, yes I can see how things are flawed and can break in
the future. But I don't think I can accurately judge the impact of that flaw
down the line. How severe will it be to reboot a bunch of things for a
security update? How annoyed is the developer really gonna be about this
tooling change? How pissed is my coworker gonna be to get paged for the thing
I built? But also, what is someone gonna be able to build on top of or
inspired by this? What am I free to do until the flaw really becomes a
problem? And is my coworker gonna be ok with with all of this as they have
learned something from it and had all the context available to fix it and make
it better? Because the one thing I do know about current me is that there are
gonna flaws in any solution. And I know one thing for sure about future me or
my coworker encountering the flaw in the system: If they have the same context
as I had when I deployed it, they are gonna be a lot happier, more empathetic
as to why I made those choices, and be able to more quickly build on the
existing solution. And if documentation, automation, and tests are in place it
looks a lot less like some thrown together piece of code but more like the
thought through project and honest attempt to fix a problem that had to make
trade offs that it is. And up until now they trade offs were good ones and
enabled a lot of other things that were impossible to tell before the fact.

So I guess the way I work through those feelings of overwhelming and paralysis
is by making sure I can be damn [proud][proud] of the work I'm doing in the
present. And make sure it's as easily adaptable as possible when the future
comes around.

Of course this is just my personal way of dealing with it. And it is highly
influenced by my character and the team I get to work with. And I hope I
didn't deviate too much from John's original point in the blog post and that
this post makes sense in some way. None of this actually makes the reality of
flaws and dread of having to deal with them go away. But it gives me an anchor
in the present and something to focus on to get things done. And a way to feel
more prepared when the flaws *do* surface. Because I'd like to think of change
as inevitable but also a good thing. Change you're not prepared for however is
when it feels most like a flaw.


[lusis]: https://twitter.com/lusis
[flaw_all_things]: http://blog.lusis.org/blog/2016/04/28/the-flaw-in-all-things/
[breaking_things]: https://unwiredcouch.com/2016/03/18/breaking-things.html
[proud]: https://unwiredcouch.com/2016/01/12/coding-pride.html
[commit_message]: https://twitter.com/mrtazz/statuses/661618547295129600
[doc_writing]: https://twitter.com/mrtazz/status/724734135831547905
