---
layout: post
title: How I prepare for and give conference talks
---

I thoroughly enjoy reading about how other people do their work, tackle
problems, find productivity, and prepare for talks. So this is my contribution
to this. Before I start however I want to acknowledge that this post is
completely inspired by blog posts from [Cate Huston][cate_talks] and [Liz
Abinante][liz_talks] who have written wonderful posts about their conference
talk prep process. So before you go on reading here, I encourage you to read
theirs first.

I have given [a bunch of talks][my_talks] over the last 2 years. Most of them
were last year where I felt like I was at a different conference every month.
I have given regular conference talks, keynotes, and was on panels. Some of
them were as short as 15 minutes with the longest one having been 90 minutes
of me talking. The topics range from cultural talks about how we approach
things like deployment or blameless postmortems at Etsy to somewhat technical
talks about our stack and tools we use and have built. Before 2013 I had never
given a public talk, save for some presentations at work and university with a
somewhat mixed audience of coworkers or other academics. This means when I
had my first talk over 2 years ago, everything was very new to me, I had
no idea what I was doing and it took me a long time to get anything done.
However I have learned a lot since then and have refined my skills to a level
where I enjoy and feel comfortable preparing talks, creating slides, and
speaking in front of an audience. And giving talks has been one of the most
amazing experiences in my career so far. So I hope this post is useful in
helping more people to also improve their presentation skills and encouraging
more to also give talks. While you're reading through this I also want you to
always keep in mind that all of those things are very much a function of my
character. I identify as an introvert and a highly-sensitive person (I haven't
been tested for it, so I don't have conclusive proof that I am either one). A
lot of things in how I prepare and give talks are to make this experience as
good as I can for me as well as my audience. So while some things might work
for you as well, I encourage you to take this as inspiration to find your own
way.


### Finding A Topic

The most important part about finding a topic is to remember that talks are
about sharing knowledge and whatever seems obvious to you, is very likely
pretty interesting to a lot of people outside of your company.

I used to have a pretty hard time with this as I did think all my work was
obvious and nothing interesting. I was fortunate however that the way Etsy
does deployment was something still very popular when I started giving talks
and still is to this day. And since I also work on deployment tooling as my
day job it was a very natural thing to talk about for me. So when I got asked
to submit a talk proposal for my first conference, I could take the topic of
Continuous Deployment and turn it into a talk that was appropriate for what
the organizers were looking for. Since then I have given many variations of
that talk. Depending on what a conference was looking for I could put more
focus on the cultural aspects of it, the tooling, or how it fits into the
bigger picture of software development and collaboration at Etsy.

However coming up with different topics has been a challenge for me. I gave
two differently themed talks last year. One was focused on the Etsy monitoring
stack and the other one on how we tackle blameless postmortems. What makes
them both a little bit special is that they are not really related to an
actual project I had at work. They are about existing setups and ongoing work
we are doing to improve things. While this is great for getting out of the
mindset that all your current work is obvious and nobody would be interested
in hearing about it (two things that are basically always false), it can be
hard to find your story arc in such a talk. Since you don't really go from a
problem to the analysis and research part, to the implementation and then the
solution, you have to find another hook for your audience. In the case of the
monitoring talk I chose Etsy's technical architecture. We are for the most
part running a monolithic [LAMP][lamp] application which seems surprising to a
lot of people. So this was a good introduction in to the talk. For talking
about blameless postmortems I just chose something everybody can relate to:
failure. Most people in the audience have seen their stack break under
surprising conditions and Etsy is no exception there. So I chose a familiar
scenario to talk about how we deal with it.

Something that has helped in the past with finding a topic for me was talking
to coworkers that are working on slightly different things and asking them
what they think would be interesting to hear a talk on. There is also often an
opportunity to follow trends on Twitter to see what kind of problems people
are interested in and give a talk on how you tackle that. And if there is
something you think is interesting, there's a high chance others will to. And
even if it seems obvious to you, people love to hear about how others tackle
problems. So don't think just because you feel like your work isn't totally
novel that others won't be interested in it.

### Writing The Abstract

When it comes to writing the abstract, there are two things I try to optimize
for:

1. Organizers should quickly get an idea if the talk is a fit
2. Attendees should quickly know if they want to see the talk over another one

Writing the abstract for the talk proposal used to be a huge undertaking for
me. I wanted to make sure all my ideas are captured and the conference
organizers knew what they were getting when they accepted my talk. So I ended
up with proposals that were sometimes 2 pages of a fully fleshed out talk
(that would change until I give it anyways) and really elaborate. It took me a
while to realize that conference organizers get a ton of proposals and they
don't have the time to read a novel of a proposal just to decide whether or
not the topic is interesting (if you are a conference organizer and have
gotten such a proposal from me: I'm sorry). So I eventually learned to
concentrate on the main story arc and message the talk will have. So now when
I write an abstract, it's about 6 sentences to at most 2 paragraphs of text.
It contains the title, the super high level outline and what the audience will
be able to take away from it. Because the other part of this is that
conferences often put the abstract on their schedule page and attendees use it
to decide which talk to go to if it's not a single track conference. So I want
them to be able to decide within 30 seconds whether or not my talk sounds
interesting. And not bore them with 2 pages of things they might not even be
interested in.

Plus focusing on the main idea has a big benefit when writing the outline and
the slides for the talk. I can always go back to the abstract and check
whether or not my talk actually conveys the message I wanted it to bring
across. And if I notice I drift from my original idea, I can correct that
easily. There have also been occasions where I changed the story arc and
message of the talk slightly as I found one I liked better while preparing the
slides.  This is ok most of the time, however if it turns into a completely
different talk I'd check with the organizers if they are fine with this as
well. If not, maybe I have a new proposal for a different conference :).

### Prepping The Talk

The time leading up to the conference and preparing the talk is kind of a
tricky one for me. I have a process there that works great for me, but which I
wouldn't necessarily recommend for anyone. The main reason for this is that I
don't write anything down until a week or so before the conference and I also
don't do any dry runs. However I want to emphasize that this is not because I
think I don't need all of those things. I'm very convinced my talks would be
better if I did them. It's mostly because of how my brain works and some of my
personal anxieties.

Just because I don't write anything down doesn't mean I don't think about the
talk. As a matter of fact in the weeks before the conference I'm mostly
forming ideas and shaping things in my head which then end up on the slides. I
do think a long time about things before taking actions, this is just my
nature so my talk prep follows this. Then about a week before I give the talk,
I start to write my ideas down as slides. Refining them until (sometimes
literally) I go on stage. I have used [Keynote][keynote] for a long time to do
this. I sometimes wrote down my ideas as a Markdown outline in vim and then
create slides in Keynote from this. However as much as I preferred writing the
outline in vim, it being twice the amount of work - as I had to basically do
the same thing in Keynote then - lead to me more often than not just starting
in Keynote. Then in fall of last year I found [Deckset][deckset]. A wonderful
OSX application that lets me write my slides completely in Markdown and then
creates a beautiful presentation from them. Since then I have gone back to
writing the outline of my talks in vim and then slowly transforming it into
slides.

And as I said before, I never do dry runs. That's not because I don't think
they are a good idea. They are and you should absolutely do them. However for
me they never fit into my schedule. Because I work on the slides until right
before I have to give the talk, there isn't a version I'm confident in showing
people early enough for dry runs. In addition to that if I prepared my talk
sooner so I could do a dry run I would constantly think that I'm not giving my
best because I'm not using all the time there is. Plus talking in front of
people takes a lot of preparation for me (as you will discover later). So dry
runs take a huge amount of energy. That being said it is something I'm not
really happy about and want to work on getting better at in the future. There
are so many things that other people notice about your talks that I think it
is one of the things I'm doing that is keeping my talks from being better.

### Slide Design

For the slide design I have come to heavily rely on Deckset to do the right
thing. I'm a big fan of having only a simple statement or message on a slide
to carry the story of the talk. Even when I was using Keynote I tried to have
as few things as possible on each slide. Keynote makes it really easy to go
overboard with effects, information, shapes, pictures, movies, bullet points,
etc. I had a pretty good slides template that I got from [a coworker][lara]
and that has basically been adapted for almost all Etsy engineering talks by
now. This made it pretty fast for me to iterate on slides. I would put the
outline headings on a single slide in bold font and then fill in slides in
between with content aiming for 1.5 slides per minute. When it comes to slide
design I usually choose between either

- a short statement or quote
- a picture (optionally with a statement or title)
- an animated gif

That's it. Nothing more complicated than that. I sometimes have a short bullet
point list but I try to keep that rare. If I can't say something on a slide
within those constraints, I very likely should rethink it or split it across
multiple slides. I do use some font styles to emphasize words in a statement
that I think should have more focus. But all in all I try to keep it simple.
And Deckset makes that a lot easier with its constraints (generated from
Markdown, no custom themes, etc) than Keynote. So I actually end up being able
to iterate on slides much faster. I spent a lot of time trying to find the
right pictures and animated gifs for my talks, often I even switch them out
right before I give the talk (more on that later). Usually I look for things
that are somewhat humorous and make the talk less dry and more enjoyable. I
have a big weakness for pop culture references and so it's not unlikely that
my talk includes references to Gossip Girl, Vampire Diaries, Black Sabbath,
Iron Man, MacGyver, or various internet memes. This is also how I ended up
giving a [talk at the USPTO][uspto_talk] with the Backstreet Boys and Avril
Lavigne being part of my slides. I usually end up having enough slides for my
talk (to satisfy the 1.5 slides/minute ratio) by the day before the conference
or the day before I leave for the conference.

### Travel (optional)

This should probably be its own blog post as there is so much I've learned
about traveling in the last year. However this only has its own section here
as I want to emphasize that I optimize for minimalism and worry free travel
when I go to conferences. This means I only have my backpack, which can hold
my clothes for at least a week, my laptop with all the cabling, and my
[Aeropress, grinder, and beans][coffee] because I love good coffee and don't
want to think about where to get coffee when I'm in a hotel. I plan my travel
so I'll be at the conference on the day before I give my talk. Usually I end
up working on the slides more on the plane and thinking about what message I
want to bring across with each slide.

### The Day Before

When I arrive at the conference, I check into the hotel, make sure to ask
where breakfast is served the next day and when and then meet up with the
organizers and try to get a feel for the atmosphere of the conference. This is
all for me to get acclimated with the new environment and to minimize
surprises and things to worry about. I try to find the room I'm going to give
the talk in and if there is a talk I really want to see I attend it. But I
don't sweat that too much, if I have the feeling that I don't yet feel good
about my slides or that I will be more calm by hanging out in the hotel room,
I will do that instead.  After all I'm here for giving a kick-ass talk and I
will do everything to make sure this is what's gonna happen. Either way I try
to be in my hotel room at 10pm at the latest. If I'm there sooner, I'll go
over my slides again and make some adaptations based on what atmosphere I
picked up from the conference. By 10pm I'm usually exhausted from travel
and/or jet lag and will fall asleep.

### The Day Of

I get up between 6 and 6.30am, read a book or browse twitter or my RSS feeds
to not yet think about the talk. As soon as the hotel breakfast restaurant
opens, I'm heading down there to have an extensive and relaxed breakfast. I go
that early for two reasons:

1. I want to have as much time as possible to enjoy breakfast.
2. Most likely there aren't a lot of people around yet, so it's quiet

After breakfast I go back to my room and go over my slides again. At this
point I usually just do some minor changes. But I have also reworked a good
chunk of the talk during this before. So there are no rules except that I have
to feel good about the talk. I might look for a better picture or gif to
support the message of some slides or reorder them a bit to make the flow of
the overall talk better. I also make coffee as it's another thing that makes
me calm (oddly enough) and feel good. I keep working on my slides until 90
minutes or so before my talk. Then I try to take my mind of the talk for a
bit, shower, listen to some music, get dressed (I always wear my Etsy
Engineering t-shirt so I don't have to think about what to wear) and head to
the conference. I always try to be at the conference 30-45 minutes before my
talk to acclimate myself with the atmosphere. This is a lot easier if the
conference is at the same hotel obviously but the same goes regardless of
where it's at. I then find the room I'm giving the talk in, if nobody is
speaking there before I find an organizer or other staff member and get set
up. My favourite speaking slots are the first ones in the morning. The
conference is still a bit empty, the rooms usually are. I just take 15 minutes
or so to get a feeling for the room and watch the people coming in. While
attendees are sitting down I try to spot 3-5 people in various locations that
are evenly spread out and remember them.  Those are going to be the people
that I try to make eye contact with during the talk. Then 10 minutes or so
before I actually am supposed to go on, I go to the restroom, even if it's
just to wash my hands, to have another couple of minutes of quietness before
I'm supposed to talk to a room full of people.

### Actually Giving The Talk

Once I'm on stage and have my slides up there and am ready to give the talk.
Nothing matters except for the talk. I try to be my most energetic, friendly
and enthusiastic self. I emphasize when I think how good or bad something is
that we are doing or trying to solve. I might try to make some jokes about
certain things that people can likely relate to, like how naming this is hard
or how computers sometimes don't do what you think you told them to do. I
remember the 3-5 people from before and while I'm talking I switch between
them, trying to make eye contact. Generally I'm really bad about making eye
contact even in conversations within small groups. So by adhering to this
pattern of looking up people beforehand I can just follow it without worrying
whether or not I'm actually capturing the audience enough or staring holes
into the air. I have my speaker notes on my laptop (I try to present with my
laptop if at all possible) but I only usually have notes for the most crucial
things or if I'm not confident I get some things right. English isn't my first
language so if things might get tricky with remembering an important word I
write it down. Otherwise I tend to improvise on slides a bit. I generally know
what I want to say and not having a strict set of notes tends to make it less
dry and more lively for me. I tend to always have the last 10% of talk time
open for questions. So once I'm done with my slides I let everyone know that I
have time for questions. But also make sure it's clear that I will be
around after the talk and also have my (work) email address on the slides. So
if someone in the audience has a question but doesn't want to ask it in front
of a lot of people, there is more than that one setting to ask about my talk.

### After The Talk

If possible I try to stay in the room for a couple of minutes so people can
come up to me for questions. If not I'll try to be around the conference
somewhere and - although I have the urge to - try not to disappear
immediately. I won't however attend a talk right after as I'm too hyped up and
overstimulated from just having spoken to a room full of people. Once people
are not coming up to me for questions anymore or it otherwise doesn't seem
like I'm running away from anyone I try to find a quiet corner and check
Twitter to see how people reacted to my talk and what things they tweeted from
it. This is a good indicator for me which parts resonated with people and
which didn't. I don't over obsess on this but it's nice to read about how
people liked your talk and gives me a better feeling about all this
preparation and over stimulation having been worth it. I then upload my
slides, usually have a page written for it on my [site][my_talks] which I
publish and then try to enjoy the rest of the conference. I tend to only go
into hiding for a bit and not go to my hotel room as there is a big chance I
won't come back to the conference. So I only take as much time as I need to be
able to recharge and enjoy the conference again.

### The Takeaway

Preparing and giving a talk is something I do very thoroughly. I do all those
things mentioned here (which may seem like a huge set of preparations) because
it helps me be and feel prepared. A lot of the preparation for a talk is
psychological for me. As I said in the introduction, I'm very introverted and
often have somewhat strong reactions to new and unknown environments and
people. So having this framework helps me immensely feeling less overwhelmed.

However it's worth noting that this is the absolute ideal plan. I try to make
it work like that but if any of the things don't work according to plan it's
not a catastrophe. I'm able to give the talk regardless, this is just the
dream set up. It also varies a lot depending on how big the conference is and
what kind of talk I'm giving. If it's an internal lunch talk at work, it's
fairly low stress for me now and I don't have that much prep time that I need.
But mostly because I now have a ton of experience giving talks and it's less
scary than it was 2 years ago.

This year however I have decided to take a break from giving talks as it was
just a bit too much last year. I'm looking forward to giving more talks next
year and have spent this year so far helping others to give talks by
connecting them to conferences I have spoken at, acting as a sounding board
for talk ideas, giving feedback on abstracts and proposals and answer as many
questions as I can about the process and nature of giving a conference talk.
Learning how to give talks and giving them until I felt pretty comfortable
doing it has been a great experience and definitely one of the most amazing
things I get to do as part of my job.

*Thanks to [Bethany Macri][bethany] and [Lara Hogan][lara] for reading drafts
of this and giving feedback*


[liz_talks]: http://lizabinante.com/blog/how-i-prepare-conference-talks/
[cate_talks]: http://www.catehuston.com/blog/2014/06/06/my-4-step-plan-for-giving-a-talk/
[my_talks]: https://unwiredcouch.com/talks
[lamp]: https://en.wikipedia.org/wiki/LAMP_(software_bundle)
[keynote]: https://www.apple.com/mac/keynote/
[deckset]: http://www.decksetapp.com
[lara]: https://twitter.com/lara_hogan
[coffee]: https://instagram.com/p/lIK8wstp-_/
[bethany]: https://twitter.com/bethanymacri
[uspto_talk]: https://speakerdeck.com/mrtazz/the-road-to-success-is-paved-with-small-improvements
