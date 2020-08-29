---
date: 2016-04-13
title: Bash Unit Testing from First Principles
url: /2016/04/13/bash-unit-testing-101.html
---


In the last couple of months I've done a foray into unit testing the shell
scripts I write. This is mostly a conglomerate of things I've learned and a
talk I've given to our ops team about unit testing 101 for infrastructure
tools last year.

In August last year I decided to finally scratch an itch I had for quite a
while. The details aren't super important here, just that it's a shell script
and that there was no sort of of pressure around it which made me take the
time to write unit tests for it. That meant for me researching what existed in
terms of frameworks and how people are generally approaching this. And
unsurprisingly I found a number of ready to use unit testing frameworks, most
of them modeled after the familiar patterns you can find in test frameworks
for other languages. However I was also curious what a minimal testing
framework for bash would look like. After all, all my script would be doing is
create some files and directories on disk with some specific content. So I
could verify it all with `grep` and `test`.  So I decided to also use this
side project to try and write my own minimal bash unit test setup.  And while
I mostly ended up doing integration testing for the script, it still made me
think quite a bit about the basics of unit testing.

### Unit Testing 101
One of the first questions I always get when someone hasn't really come across
a lot of [unit testing][unit_testing] is "what is a unit?". And while
technically you can probably argue for a unit being a lot of things, the most
helpful one I've always found to be:

> a unit is a function

This simultaneously gives a very concrete answer and also a starting point of
what to do. When writing unit tests, start testing functions. This of course
occasionally leads to the next question "what is a function?" and more often
to the debate of how to make a function testable. For the first question I've
again found this very reductionist answer to be the most helpful:

> a function is a reusable piece of code that turns defined input into defined output

This is somewhat close to what you learn in school about functions in math and
has helped me a lot with how I think about writing code.

### Writing our first tested Bash code

Now with those definitions out of the way, there's a plan on how to make a
shell script unit testable:

1. Refactor your code into functions
2. Write tests for those functions

There's a bit of a lesson to learn about [side effect free
functions][side_effects] but we can short circuit that by saying the only
things your functions should rely on are variables passed into it. And it
should always echo its results to STDOUT.  This heavily reduces the
possibility for side effects in bash functions but also limits the functions
that absolutely have to do something other than just taking input and printing
results to an absolute minimum. Your logic can live in the other functions
most of the time. And those are the ones you can unit test. So now let's
write some functions and tests for them.

Let's say we want a function to output the number of characters in a string.
It could look something like this:

```bash
function num_chars {
  echo "${1}" | wc -c
}
```

It's a very contrived example and you're basically testing that `wc` works
correctly. But it's a useful example here to show some things. Notice how the
function only acts on variables passed into it and prints the result to
STDOUT.

Now let's write a unit test for it.

```bash
function test_num_chars {
  local res=$(num_chars "foo")
  if [ ${res} -ne 3 ]; then
    echo "failed to assert that ${res} is 3"
  fi
}
```

And that's it. That's all you really need to do to write a simple unit test in bash.

Of course adding more tests now generates a lot of repetitive work. So we can
write a helper function to do the assertion part of the test.

```bash
function assert {
 eval "${1}"
 if [[ $? -ne 0 ]]; then
   echo "${FUNCNAME[1]}: failed"
 else
   echo "${FUNCNAME[1]}: passed"
 fi
}
```

This helper function takes an argument which is a statement to evaluate. And
depending on whether the eval exits with 0 or not, the test is regarded as
passing or failing. It then prints out the result accordingly. `FUNCNAME` in
bash is an array that holds the current execution call stack. And thus the
first entry in it is the current function and the next one is the calling
function. This gives us a nice way to determine which test is being executed
and make it part of the output message.

And with this helper function in place, our test now looks like this.

```bash
function test_num_chars {
  local res=$(num_chars "foo")
  assert "[ ${res} -ne 3 ]"
}
```

Now we can already define a couple of tests and run them by calling the
functions we defined. However that also gets very repetitive fast and you
always have to remember to actually call the function when you define a new
test. So let's also write a helper function to do this for us.

```bash
function run_test_suite {
  for testcase in $(declare -f | grep -o "^test[a-zA-Z_]*") ; do
    ${testcase}
  done
}

```


This helper gets all the currently declared functions (via `declare -f`),
looks for the ones starting with "test", and then simply executes them.

Now all you have to do is call `run_test_suite` at the end of your file and
all new test functions are automatically picked up as long as they start with
"test".

### Fixtures for Tests
Now a lot of times in shell scripts you actually want to interact with files
on the file system. And it's not really feasible to always have everything
just be variables to be passed in. In this case you can adapt your script by
setting the base of where the files are you want to interact with. Something
like this:

```bash
FILEBASE=${FILEBASE:-/usr/local/foo}

function list_files_with_a {
  ls "${FILEBASE}/a*"
}
```

Now you can set the variable in your test suite before you source your shell
script with the functions to test. That way `FILEBASE` will already be set and
the functions use it as their base. If you know create a directory for those
fixtures in your tests directory, you can easily mock out file system details
in a controlled way and test for them.

### Dependency Injection in Bash
One of the most important things for me to get better at unit testing in
general was understanding [dependency injection][dep_injection]. Writing code
in a at that would let me completely drive function behavior based solely on
what I'm passing in. And if I have to call an external resource make it so I
can pass in the expected return value and only if it's not set, call the
external resource. A simple example could look like this:

```bash
function get_url {
  local url="${1}"
  local res="${2}"

  if [ -z "${res}"]; then
    res=$(curl -s "${url}")
  fi
}
```

Now you can use this function as you would normally do with `'get_url
"https://unwiredcouch.com"`. However in tests you can also pass in a second
argument which will be used as a locked out response instead of actually
curl-ing the URL.

### Wrapping up
In this short set of examples I hope it got somewhat clear that it can be
straightforward to write a quick unit testing setup for shell scripts from
built in functionality and start writing tests. I've also shown some
techniques to write more testable bash to begin with. If you're interested in
reusing the code if pushed the (slightly more improved) version of this I use
to [GitHub][minibashtest]. It provides nicer output, more details and properly
returns a non-zero exit code if something failed, so you can run it on CI.  If
you want more functionality or more advanced testing support, I've listed some
alternatives in the [README][advanced_testing].

And on a slightly related note, you should start using [shellcheck][] when
writing bash. It's such an awesome way to get feedback about how to write
better shell scripts and I've learned tons already just from the errors,
warnings, and suggestions popping up in my VIM quickfix list.

But the most important part is that testing isn't magic and doesn't have to be
complicated. You can get started immediately with just the basics of any
language. And especially starting to write tests for shell scripts is lots of
fun.

[minibashtest]: https://github.com/mrtazz/minibashtest
[shellcheck]: http://www.shellcheck.net/
[coding_pride]: https://unwiredcouch.com/2016/01/12/coding-pride.html
[advanced_testing]: https://github.com/mrtazz/minibashtest#advanced-testing
[unit_testing]: https://en.wikipedia.org/wiki/Unit_testing
[dep_injection]: https://en.wikipedia.org/wiki/Dependency_injection
[side_effects]: https://en.wikipedia.org/wiki/Side_effect_(computer_science)
