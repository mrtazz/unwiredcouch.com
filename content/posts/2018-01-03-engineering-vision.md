---
date: 2018-01-03
title: Learning to have an engineering vision
url: /2018/01/03/engineering-vision.html
---

Saying that the last 18 months or so were stressful and full of changes would
be a colossal understatement. Work wise I switched to a new team after over 4
years on the same team, which was then dismantled as part of a big structural
reorg that was actually part 1 of 2. Part 2 consisted of a larger
restructuring that meant my new team also ceased to exist in its then current
form after only 10 months. These changes were incredibly important and long
overdue. However after a couple of pretty stable years this also meant I had
to get out of my comfort zone in a lot of new ways. On both newly created
teams I was one of the more senior engineers which meant for me thinking long
and hard about how I want to contribute to building up a new team and what my
place should and can be there. This meant building up and getting used to new
routines, schedules, way of communication and urgencies in work. All muscles I
had not really needed to exercise in a while and to a large degree not ever.
And besides the build up of technical knowledge about the services we were now
providing as a team, the non-technical side of things was where I really grew
as an engineer. Specifically the most positive impact on how I view work has
been to finally get a better grasp and think hard about what vision means for
an infrastructure/systems engineering team.

I've gone through the process of thinking about vision for a team before. At
Etsy we use a structure called "VMSO - Vision, Mission, Strategy, Objectives",
to organize and structure teams and departments in what their purpose is
within the company and what they contribute to the business. It draws a lot of
inspiration from the ideas in this blog post by LinkedIn CEO Jeff Weiner
called ["From Vision to Values: The Importance of Defining Your
Core"][weiner]. The rough overview is that vision is the 30 000 foot view, the
high level idea on the horizon that (almost) never changes. The world we want
to see exist. The mission is derived from it and describes what the team does
to get towards the vision. And then it gets more concrete with strategies how
to get there and concrete objectives we want to fulfill. It's not an easy
process and definitely takes a whole of brainstorming, suggestions, throwing
away suggestions, refining and merging ideas, and consensus building to get
there.

Before this season of change, on my old team, when we were tasked with
creating a VMSO for ourselves we always got hung up on the vision. It was
always that high level thing that never quite matched the work we were doing.
We would meet once or twice and always seemed to end at the same dead ends:
"Our work is too multifaceted to be captured by a single statement", "It's
hard to explain what we do", "We do anything that needs doing", "We keep
things running". If you're working on a general purpose infrastructure team,
this might sound familiar to you. It seemed like it was just impossible to
come up with a single vision for the team, so we always left it at a half
baked, cheesy feeling idea. And of course at that point we didn't manage to
derive a good mission from the vision either. Not to speak of strategy or
objectives. I didn't feel too bad about that at the time.  As we had a fairly
broad vision statement, it let us basically take on anything we wanted. And to
be honest, I *loved* working on that team. Although we were always working on
separate things, we were a bunch of engineers with the same mindset and
approach to work. We had a great team dynamic and our team meetings were a ton
of fun. I couldn't imagine working on a different team.

And in the middle of this work the first part of the reorg happened and our
team got dissolved. I was really upset. While I was fully onboard with the
reasoning and goals of the reorg, I couldn't understand why our team got ended
and most of our roadmap dropped. It felt like our work had gone completely
unvalued. But then I had a long 1-on-1 with my then [Engineering Director
Jason Wong][jwong]. We talked about all of it, he gave me a ton more context.
And he made me understand how a team that does "a little bit of everything" is
really hard to fit in organizationally. He asked me flat out what the purpose
and vision of the team was in the org. Where was the team going? What would it
look like in 2 years? And I couldn't give him a straight, simple answer. I was
a very senior engineer on the team and I had no answer. This was the moment
where I managed to connect (some of) the dots. And tie together our lack of a
comprehensive vision to the downsides of our operating model. We ended up
supporting way more things than we could, leading to long periods of
maintenance work and almost none of the iterative improvements we planned for
at the beginning of the year. We had no way of saying no to work because we
didn't have a good reason to reject the work. We had weeks where our work
summary would basically just be "clean up". Which I love doing and is valuable
work, but not if it takes up 90% of someone's time. We agreed on a vision that
was defined by the work we were already doing and not by what we wanted the
work to be.

And at the time I failed to see the big downside of this: it let us take on
anything we wanted. While this sounds like fun at first, it makes a lot of
things really hard. We continuously worked on 6 different projects as a team
of 7 engineers. There was hardly any collaboration possible and we ended up
with single points of failure because single engineers would end up being the
only ones knowing about a particular system. Once we had hit the limit of
reports for a manager (7 at the time), we needed to hire another manager but
had a really hard time figuring out how to split the team because there was no
clear structure. And boy was it hard to give the elevator pitch for the team
in those interviews. We were a team that was ever expanding its work areas to
catch things and never managed to retract back and focus on our core. We were
aware of those problems and we always thought we will figure them out with
time. For the time being it felt better to keep fixing things and worry about
the rest later. Succumbing to the always existing, intriguing feeling that
something that you can fix needs to be fixed right now.

And in the middle of 2016, all of this was suddenly gone. And after that very
intense and honest 1-on-1 with Jason I felt I knew what I had to do. I joined
a new team. I kept thinking about team focus and organizational structure. And
when we set up to create a VMSO I went full in and went with the process. I
talked a lot to [Vanessa Hurst][vanessa] and [Lara Hogan][lara], both also
Engineering Directors at the time, about VMSOs, team structure and direction.
Both of them know incredibly well how to build engineering organizations and
gave me so much insight and food for thought how to approach this task. I
thought hard and good about what *I* as an engineer on the team wanted the
team to be. And what I don't want it to be. What were the things that I wanted
this team to contribute to the business? What did I not want to bring around
anymore and let stay in the past? I wanted to have a vision that I can align
goals and work to that would provide focus and effectiveness for the team. And
after a week or two with many, many VMSO meetings we ended up with a result
that I was really happy with. It was also the first thing we delivered as a
newly created team which helped immensely with team identity building. And in
the following months to come I found myself often referring to the vision when
the question came up of whether our team should be doing a particular bit of
work or take over a certain ticket.

Since then I've also worked on the VMSO for our whole organization of Systems
Engineering. And it was an even harder challenge to find something that
matches the purpose of a dozen teams and gives them something to align their
work to. But it was again a valuable lesson and a time spent building the
structure for something I really want to be part of and make contribution to
the business.

These past 18 months have been an incredibly intense learning period for me.
Most of the things we did on my old team were the right things to do at the
time. We worked on a lot of exciting and important projects that enabled
others to build on top. And we were incredibly successful. But we also missed
the point where the team needed to change to a different operating model to
grow with the business. To align it to where the infrastructure needed to go.
I learned to not think about work on an infrastructure team as just "keeping
the lights on", "fixing broken things" or "administering the machines
everything else runs on". But actually take the time to think about what to
really contribute to engineering. What the state is I can see on the horizon
and not just the work I know needs to get done right now. The two or three
things that will make a difference over a laundry list of things that would be
nice to do.



[weiner]: https://www.linkedin.com/pulse/20121029044359-22330283-to-manage-hyper-growth-get-your-launch-trajectory-right
[jwong]: http://twitter.com/attackgecko
[vanessa]: http://twitter.com/dbness
[lara]: https://twitter.com/lara_hogan
