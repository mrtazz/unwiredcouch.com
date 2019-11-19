---
title: Factors of Confidence
---

I've been having a lot of discussions about delivery of software lately and
especially about the deployment part of it. This made me think about the last
couple of years of working on deployment and development tooling and the
approach I take there.

I've come to view this from a perspective of formulating a hypothesis and
establishing factors of confidence to confirm or refute this hypothesis. This
sounds very abstract and theoretical at first. But bear with me for a moment
here. The basis for all delivery is a change (or patch, diff, commit, change
set, whatever you wanna call it). This change is meant to improve something.
Add a feature (or establish the base for one), fix a bug, improve performance,
increase visibility, or just clean up some technical debt. This means you're
going to production to make the world better. However given the complex nature
of the systems we deploy software to, you won't actually know if your change is
a net positive until it's running in production. And even then you often only
know a couple of hours or even days later. So all you have when you're in front
of your editor writing some code is an idea about what will make the word
better. A hypothesis.

The job of a delivery pipeline now is to help you get confidence. Confidence
that your hypothesis holds. Or confidence when you have to refute it. However
all of the complex interactions of systems means you don’t get to have that
single unified proof that your code is what you want it to be. Your ability to
make a decision about your change is based on many small factors of
confidence.  And the delivery pipeline should give you tools along the way to
acquire those factors of confidence in reasonable time and effort. It usually
starts with a very quick feedback loop and something akin to a unit test. You
can write them quickly and they can be verified quickly (individually that is.
Running large numbers of unit tests on CI is still a not so easy problem). You
then usually move on to test that are more expensive with a longer feedback
loop.  Like an integration test. Maybe a QA environment. A staging
environment.  Smoker tests in production. Canary deploys. And so on. All of
those things (and this is hardly an exhaustive list) are intended to give you
confidence in something.  That your logic is correct, that your code works
well with other API endpoints, that it interacts with other code on the site
in a way that doesn’t break the whole thing, that it doesn’t put too much load
on downstream systems, etc, etc.  And ideally all these things in place will
give you a nice set of guardrails that make deploying to production an
enjoyable experience.

However given these tools are merely a snapshot of your understanding of the
system at the time and what confidence is needed to make a change to it, the
delivery pipeline needs to be constantly maintained and re-evaluated. Maybe
system growth now means that the trade off of running a large array of unit
tests and the time it takes, doesn’t pay off in the confidence it provides. Or
maybe it does and this means you need to think of something to make running
unit tests faster. Maybe a new additional service means you now need to add a
set of smoker tests. Whatever it is, the most important thing is that you know
*why* any of these tools to assert confidence are in place. *Who* are they for
and *what* are they telling you? The last couple of years have seen the rise of
a huge number of fantastic delivery systems. Often highly opinionated or
infinitely configurable. Sometimes both. It’s easy to just take one of them and
cargo cult what they bring with it. And if you don’t already have an
established system, this is a fine approach that will certainly make you end up
with a better setup than you had before. However I encourage you to look
closely what your delivery pipeline is made up of. And what kind of things it
gives you confidence in. Do you often see failures after deploys because of
surprises in your logic? Maybe you’re missing some unit tests. Are you spending
tons of time on unit tests that essentially only re-test the framework code of
the tool you’re using? Maybe you don’t need those tests and can free up a lot
of engineering time. Whatever it is, your delivery pipeline needs to give you
confidence in changes in *your* stack. You know best what kind of things need
to go in there. And spending some time to think about that will give you a lot
of insight and pay off when it comes to improving your delivery pipeline. And
it’s also tons of fun!




PS: I’ve had many discussions about those things with many people over the
years. And they all helped me figure out how I think about delivery and make
sense of my rambling thoughts. So if you've ever chatted with me about
deployment and/or delivery, I'm extremely grateful you took the time and I
really enjoyed our chat.
