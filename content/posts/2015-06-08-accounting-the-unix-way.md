---
date: 2015-06-08
layout: post
title: "Accounting: The Unix Way"
url: /2015/06/08/accounting-the-unix-way.html
---

I'm a big fan of simple tools and building blocks. A function of writing code
every day for the last 10 years has been that I feel really comfortable with
plain text files, vim and git. So whenever I can, I try to see if I can base
the solution to a problem on plain text. It's just in most cases so much more
portable than any other way and I am already very comfortable with the command
line. That way I can use my every day tools to add, modify and delete data.

A while ago I wanted to find a better way to keep on top of my finances. They
aren't crazy in any way and I have a very normal, regular, non-exceptional
financial situation as an employed engineer. However I felt like I could get
more data and better insights into everything. This wasn't really on my mind
for a while though. I kept the idea in the back of my head but wasn't actively
looking into any way to make it happen. Then one day I was reading my RSS
feeds where I amongst others subscribe to the wonderful ["The
Setup"][thesetup] blog. If you don't know about it, it's basically an
interview series where people talk about the tools (hardware and software)
they use to get their job done. I like reading about the tools others use and
get inspired to try out different things. And in there I was reading [an
interview][usesthis] with a Debian developer who mentioned working a lot with
text files and git. And he also said he was doing his accounting with git and
[ledger][ledger] and I was immediately intrigued.

I started to investigate the tool and read blog posts about how others were
using it. Ledger actually has a very [comprehensive
documentation][ledgerdocs], so I started there. Read about how to use it, the
basics of [double-entry bookkeeping][double-entry], and what kind of
information I could get out of it. I then also found an [interesting
post][reckonpost] where someone wrote a tool - [reckon][reckon] - which parses
CSV and formats it into ledger format. It even uses Bayesian machine learning
to suggest accounts to use for each entry, minimizing the work that needs to
be done manually even further.

### Diving into the deep end
So I decided to give it a try and take the upcoming tax return I had to file
as the motivation to get it done before that. I downloaded CSV data from my
bank accounts (and learned that the allowed time to back is 2 years, no data
before that), installed ledger via homebrew and the reckon rubygem and started
to import data. This was a bit tedious at first, as reckon didn't support
backspacing and thus editing mistyped accounts. I fixed that in the gem and
sent a [pull request][reckonpr] like a good open source citizen and
[procrastinating software engineer][accountingtweet]. And after a couple of
hours I had all my data from 2014 and (most of) 2013 in the ledger data
format. I played around with the reporting options and really liked it. It was
super flexible I could quickly fix and change things by opening the file in
vim. So I decided to properly structure it and go full in with ledger.

### All in
I created a git repo with directories for the raw csv files (in case I needed
to regenerate any data at some point or look up something else) and for each
year since 2013. In those per-year directories I have a file for checking,
credit card, cash and opening balances. And a top level ledger dat file per
year that includes the appropriate files.

```bash
cassie:accounting[master]% cat 2015.dat
include 2015/opening_balances.dat
include 2015/checking.dat
include 2015/credit_card.dat
include 2015/cash.dat

cassie:accounting[master]% ls -1 2015
cash.dat
checking.dat
credit_card.dat
opening_balances.dat
```

Checking and credit card should be self explanatory as they just hold the
entries for those accounts. Whenever I withdraw money at an ATM, I book it to
an `Expenses:Cash` account as I expect to spend that money. Otherwise I
wouldn't have withdrawn it. But this also means that I don't have a ton of
visibilty into what I spend cash on. That is why I have a file called
`cash.dat`. When I spend cash on something and remember, I note it down on my
phone in a text file which syncs to my computer. And when I'm doing my monthly
accounting I can pull up this file and just write proper ledger data entries
for the contents of this file. I then note that those expenses come from the
account `Expenses:Cash` to keep everything correct. The next file special file
is `opening_balances.dat`. Because I have a file per year, the data only
reflects postings for that year. In order to still get accurate balances, I
run the equity command (`ledger -f ledger-old.dat equity`) on the old year's
data and write that into the opening balances file as coming from the account
`Equity:OpeningBalances`. This is a bit of hack, but it illustrates a major
advantage of ledger. It doesn't care about what the accounts are named. This
means you can give them names that mean something to you and ledger won't have
a problem with that. The documentation even gives an example for tracking
inventory in the [video game EverQuest][ledgeraccounts].

### Monthly Routine
Now with this setup in place, I have a monthly recurring project in [my
OmniFocus][of_post] to download the CSV for my account and add them to my
ledger data. Once I've downloaded the file, I run reckon over it to have it
properly format the data and suggest accounts to add them to. Since reckon -
as I mentioned before - uses Bayesian learning to find out what accounts a
posting likely belongs to, it makes sense to have a corpus for it to learn
from which includes all possible accounts. And because I really like
Makefiles, I have one with a simple task in there to generate a big file which
contains all of my postings:

```make
SOURCES := $(shell find . -iname "*.dat*" -mindepth 2)

corpus.dat: $(SOURCES)
	cat $(SOURCES) > $@

```

Now I run reckon with something like

```bash
reckon -f raw_data/2015/checking05.csv --contains-header -o 201505_checking.dat -l corpus.dat
```

in order to parse the CSV file. Usually when I run this, reckon detects almost
all of my recurrent transactions like rent, gas, electricity, internet, subway
and ferry fare. I just have to confirm the account by hitting enter. With this
it takes me about 5-10 minutes to get through a CSV file. After I'm done I
might go through the file in vim to make some adaptions. For example I have a
very generic account named "Expenses:Amazon" which reckon detects to use for
everything coming from Amazon. However since I buy a variety of things
(household items, clothes, etc) on Amazon I open my "past orders" page on
amazon.com and check my transactions in ledger against it and file them into
more specific accounts. When I'm happy with it, I commit my changes to git and
have an up to date version of my accounting data. I then can run all the
queries on it to give me some overview of what I was spending money on in the
last month. Ledger is versatile enough that I could spend a lot of time on
explaining all the possibilities. But the simplest way to get started is just
showing the top level balances which will give you an overview about Income,
Expenses and Assets (if you have named your accounts like that):

```bash
ledger -f 2015.dat --period-sort "(amount)" balance -M --begin 2015/04/01 --end 2015/05/01 --depth=1
```

### Verdict
I'm really happy with this setup so far. It's comparably low tech and low
investment and I can (for the most part) use the tools I know and I don't have
to store my financial data on someone elses server. Still if I want to do
accounting on a different machine, it's just a matter of cloning the git repo
to it and installing ledger. The import process is not too cumbersome,
although I have to remember when I pay off my credit card from my checking
account for example that I only enter the transaction once as it will show up
in both CSV downloads (once as debit and once as credit). This has caused some
confusion for me in the past when I forgot but generally isn't too bad.

I'm also not doing any super advanced things with it so far. I've played with
it's [Gnuplot suppport][ledgerplot] and ran different queries in different
situations to track down where I actually spent more money than the month
before. I'm sure there are more use cases that will arise over time and while
I'm no accountant (and probably used some words wrong on this post) it has
been super interesting to get some more structure and insight into my personal
finances.


[ledger]: http://www.ledger-cli.org/
[ledgerdocs]: http://www.ledger-cli.org/3.0/doc/ledger3.html
[ledgeraccounts]: http://www.ledger-cli.org/3.0/doc/ledger3.html#Accounts-and-Inventories
[ledgerplot]: http://www.ledger-cli.org/3.0/doc/ledger3.html#Visualizing-with-Gnuplot
[double-entry]: http://en.wikipedia.org/wiki/Double-entry_bookkeeping_system
[reckon]: https://github.com/cantino/reckon
[reckonpost]: http://blog.andrewcantino.com/blog/2013/02/16/command-line-accounting-with-ledger-and-reckon/
[reckonpr]: https://github.com/cantino/reckon/pull/44
[thesetup]: http://usesthis.com/
[usesthis]: http://stefano.zacchiroli.usesthis.com/
[accountingtweet]: https://twitter.com/mrtazz/statuses/573671503029497856
[of_post]: https://unwiredcouch.com/2014/05/13/omnifocus.html
