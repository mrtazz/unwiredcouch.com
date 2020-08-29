---
date: 2015-05-04
layout: post
title: There's No Such Thing as No Project Management
published: true
---

Project management. Every engineer seems to loathe the term and also what it
describes. It has that word *management* in there. It's different than code.
It's not code. So naturally whenever this comes up, all the engineers make a
joke, shrug and go hide behind their editors. I've been there, I've done that.
However over the years I have realized that this is not just stupid but
actively working against making software projects successful. I mostly had an
aversion against the overloaded, overused and useless definition of project
management glorifying charts and plans and deadlines over actually
organizing and making sense of the work and the processes to get it done.
Because the truth is you are already doing project management. Yes you! The
software engineer!

### You had the project management all along

Every time you start to write code, even for some fun side project, you start
to think about the different components that will make up the whole thing. You
start to form a mental model of all the high level parts that comprise the
finished application. You plan out some rough course of action for yourself.
Which parts you want to tackle first. Which things to stub out and which
things to punt on for later. You just (most of the time) don't write them
down. But as you go on, you think about what the first workable version will
be able to do. Then you think about the next one, maybe refactor some things
to accomodate new features. Maybe you write down some notes for you or add
some `//TODO:` lines in the code so you know what to do when you come back to
it.  But the important part here is, that you're planning the application.
You're basically already doing 85% of what project management for a small to
medium software project is all about.

So what's the difference? Well really mostly thinking about the structure of
your project on a higher level and writing things down. To be clear: It's ok
if you only want to write code. And you can be or get really good at it.
However only wanting to write code is like saying you only want to hammer wood
together.  Sure there is beauty in how you do it. There are good carpenters
out there who are able to do woodwork like nobody else. And everybody wants to
have such a craftsperson on their team when it comes down to doing the work.
However this will only be useful up to a certain level.  And that's absolutely
ok. But if you want to level up as a carpenter you will need to understand
what it is that you're actually building.

And that is very much the same for a software engineer. In my mind [being a
senior engineer][senior_engineer] also means that you understand the problems
you are solving past the perfect implementation of a binary sort. That you
understand that writing code is a means to an end and not the ultimate
purpose. That you understand what problem you are solving and the environment
it will exist in so you [plan for it][infra_projects] accordingly. This means
a good chunk of "non-coding time". It means that you understand how to break
the problem apart and how it would speed up the implementation if you suddenly
got 2 or 3 more engineers on the project. Or if it wouldn't help at all. It
means that you understand how the project could continue if you suddenly
[decided to go on vacation][vacation_factor] because you know you don't want
to [be a spof][spof]. It means that you have things planned out so someone
else could [take it over][not_work] or even make the whole project happen
without you. It means understanding what existing or future work would be
great for a more junior engineer on the team to level up on and plan work so
it's possible for them to do it. And it means writing things down and
communicating them.

This can be as easy as creating a project in your JIRA instance and adding a
bunch of subtasks. It can be Gantt charts if you are so inclined and want to
show dependencies better. It can be a markdown document laying out all the
bits and pieces you have thought about so far.

### You are not your project
All of these things might feel weird at the beginning. All you want to do is
write code, find the perfect abstraction, make it beautiful. You will suck at
this at first because you are not used to it. But at the same time you will
suddenly see others implementing things you want to exist, doing work for you
and learning while they do it. And maybe even take a whole project over from
you and finish it. And it will feel weird again. You will have this feeling of
not having finished something. Of only going 80% there. Of only having done
the "soft" parts. But in reality you just transferred a ton of knowledge. You
made it possible for someone else to work on something that previously only
existed in your head. [You are not your projects][egoless]. I've [said
before][capture_ideas] that you need to capture ideas for others to work on.
It's the only way to scale yourself. And it frees up your time to work on
other things. And even if you end up working on the project all by yourself
(which is less and less likely as your organization grows), there will be a
plan for others who are interested to follow along with what's going on. There
is clear communication of what's in progress and what the current state of
things is. And other engineers can learn from your example. Because suddenly
you're doing project management. And it's not even that weird. You have been
doing it on some level all along. And you should, it's part of your job. As an
engineer you understand best how work gets done. So you are in the perfect
position to plan out the structure of your projects. And there is no such
thing as "no project management" anyways. You can only decide to do it badly
or try to do it well. And seeing all the benefits of doing it well come to
life is so much more fun.

[infra_projects]: https://www.unwiredcouch.com/2015/01/28/building-a-plant.html
[capture_ideas]: https://twitter.com/mrtazz/statuses/467769106780127232
[spof]: https://twitter.com/mrtazz/statuses/557697168010924033
[senior_engineer]: http://www.kitchensoap.com/2012/10/25/on-being-a-senior-engineer/
[vacation_factor]: https://twitter.com/mrtazz/status/593835726858518528
[not_work]: https://twitter.com/mrtazz/status/590506541436039169
[egoless]: http://en.wikipedia.org/wiki/Egoless_programming



