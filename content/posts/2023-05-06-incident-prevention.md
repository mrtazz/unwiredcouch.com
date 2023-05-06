---
date: 2023-05-06
title: "Incidents can't be prevented, but learned from"
url: /2023/05/06/incident-prevention.html
---

## Incidents are painful

If your job is taking care of a running system, then you know how painful
incidents can be. They are often sudden and unexpected. They are disruptive to
your (and your coworker's) workday. And they are a stark reminder of the fact
that you are operating on inaccurate assumptions about the world your systems
are operating in. Often in seconds you are forced to through a painful
realignment of your understanding of the world. And at the very latest when
the incident is remediated and the adrenaline starts to dissipate you are left
with those irritating feelings full of hindsight and regret (especially if the
incident was triggered through the deploy of a change). "How did we not
foresee this?", "Why didn't we stop before running the command?", "How could
we let this error happen?". "We have to make sure this never happens again!"

## Prevention of incidents

This urge to prevent uncomfortable situations from happening again is
absolutely natural. And we all go through it. We don't want to be in this
situation where we have no idea how something could suddenly break. Much less
in a situation where we can't be sure it won't break again. And the next
logical thing is looking for just even a single thing that makes sure we
aren't ever going to be in this situation again. And even if you [already know
that root causes aren’t a
thing](https://www.kitchensoap.com/2012/02/10/each-necessary-but-only-jointly-sufficient/
"Each necessary but only jointly sufficient"), it’s an incredibly tempting
thing to try and find. Even Nietzsche said it over a hundred years ago:

> To derive something unknown from something familiar relieves, comforts, and satisfies, besides giving a feeling of power. With the unknown, one is confronted with danger, discomfort, and care; the first instinct is to abolish these painful states. First principle: any explanation is better than none. Since at bottom it is merely a matter of wishing to be rid of oppressive representations, one is not too particular about the means of getting rid of them: the first representation that explains the unknown as familiar feels so good that one considers it true
> <p class="cite">
> &mdash; <cite> Friedrich Nietzsche, Twilight of the Idols (1888) </cite>
> </p>

And so in the case of an incident we look for anything that lets us prevent
this incident (or others like it) to happen again.

The problem with this kind of goal fixation on prevention (as noble as it is)
is exactly that. It's fixation on a single outcome. A single "good" state. And
this means it severely limits how much can be learned from an incident.
Because even as you have now realized something new about the system and the
world and went through that painful realignment of your perspective, that's
still not the full picture. And it never will be. Our systems are highly
complex and subject to constant change in both their code and operations as
well as their environment. So even if we come up with something now that we
are sure will prevent the incident from happening again, it won't (and can't)
ever be a solution with the full view of the system. So anything we can come
up with in this situation to "prevent" the incident from happening again has a
high likelihood to be over specific to this current view of the world.
Proposals for solutions in this situation often take the form of guard rails,
check lists, over zealous automation, or other things to reduce ["human
error”](https://unwiredcouch.com/2014/08/04/human-error-getting-off-the-hook.html
"Human error and getting off the hook"). But those things - while well
intentioned - often have the downside that they take flexibility away from the
true source of resilience in a system: the human operator. And when the next
incident comes around, there is a decent chance that these newly instated
"improvements" are now working against operators and their ability to reason
about a situation and improvise a solution. Effectively causing them to take
longer with debugging and remediation in a state of reduced flexibility than
they did before.

> “The problem comes when the pressure to fix outweighs the pressure to learn.”
> <p class="cite">
> &mdash; <cite> Todd Conklin  </cite>
> </p>

And after all that investment there was likely only very little learned from
an otherwise information rich incident. Plus there is usually no way of
telling whether you actually prevented anything. Most of the time in running
systems, incidents _don’t_ actually happen. So the absence of incidents -
especially the non-recurrence of a specific incident - is generally not a
strong signal about the resilience impact of a single change.  Often many
contributing factors to an incident lie dormant for a long time only for an
operator to exclaim while debugging an incident “how did this ever work?”.

## Learning from incidents

So what’s the alternative? Surely we don't just want to shrug off incidents
and ignore them. That would be such a waste. Incidents are a great source of
knowledge and learning. And I for one enjoy getting the chance to learn
something.

In the situation of post processing an incident this means now is the time to keep an open mind and understand how we arrived at the current state of the world and our systems:

- Why are they set up like this?
- What are their current known limitations?
- What is easy/hard about changing them?

I won’t go into too much detail about how to facilitate learning from
incidents here. I’ve had the fortune to collaborate [on a
document](https://extfiles.etsy.com/DebriefingFacilitationGuide.pdf "Etsy
Debriefing Facilitation Guide") about this many years ago and I think it’s
still a useful place to start.

But this is the discussion that should bring all your experts to the forefront
(the yard?). The people that are operating the systems in question and know
their in and outs. The ones that are operating alongside and within the
behaviours and boundaries of those systems every day. They will be able to
quickly pinpoint shortcomings, workarounds, and idiosyncrasies. But also more
importantly slack and flexibilities, and processes and hacks that aren't part
of the day to day automation but are needed in edge case situations to keep
the system resilient. They will be able to talk about how they decided to look
at some metrics but not others to make sense of the state of the system. How
they decided to go with one route for a possible fix and not the other. In a
setting where learning is preferred over fixing and solving there is the
chance for a lot of people to go on a journey of how to navigate a highly
complex socio-technical system and make the whole organisation more resilient
through the dissipation of knowledge. And while discussions of incidents often
seem linear and algorithmic in hindsight, it’s also important to always
remember that the operator chose _one_ path to success amongst a myriad of other
routes that may or may not have been taken. And what looks linear and
algorithmic now was most likely nothing like that when it happened. Sometimes
what comes out of the discussion _might_ be more automation or it _might_ be
an additional guard rail. But the importance is that neither is it something
that can be known beforehand, nor is it something that will be instated to
keep the human at bay.

The point of debriefing and discussing incidents is **not** to keep something
from happening but to make sure the tools (including automation) and support
(including knowledge sharing and learning) are in place to _["augment and
compliment [..] human adaptive and processing
capacities"](https://www.kitchensoap.com/2013/08/20/a-mature-role-for-automation-part-ii/)_.

## So what to do?

Incidents don’t have to be painful. At least not once they are over and you’ve
gotten some sleep to get ready to debrief them. You can approach them with a
stoic attitude of knowing that you won't ever be able to prevent them. That
you will keep having incidents. They will likely change in nature and shape as
your systems and understanding of them changes. But you won't ever get rid of
them completely. Along that same topic [Lorin
Hochstein](https://surfingcomplexity.blog "Lorin Hochstein's blog") recently
gave [a great talk at
SRECon23](https://surfingcomplexity.blog/2023/04/25/my-srecon-23-talk-is-up/
"Lorin Hochstein's SRECon23 Talk") about why we will all keep having
incidents. And it’s well worth your time, so go watch it. But approaching
incidents with a mindset of learning makes it an exciting rather than painful
situation. Because you’ll know you’ll never run out of sources for learning.
And once you’ve realised what a good source for learning incidents are, it’s
maybe even time to take a good look whether [shallow incident
data](https://www.adaptivecapacitylabs.com/blog/2018/03/23/moving-past-shallow-incident-data/
"Moving Past Shallow Incident data @ Adaptive Capacity Labs") like “mean time
to detection” and “mean time to resolution” (or the maybe worst offender of
all “mean time between failure”) are actually helping your team approach
incidents as a learning opportunity or maybe are incentivising an approach
that foregoes learning for a better look of those metrics.
