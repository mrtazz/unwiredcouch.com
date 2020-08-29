---
date: 2015-12-17
layout: post
title: Chef Driven Graphite Dashboards
---

Some years ago [I wrote about][monitoring_gs] how to use Heroku and a set of
hosted solutions for getting started with monitoring for your personal
infrastructure. I used this set up for quite a while and I learned a ton
setting it up. But after a while things were chugging along and I was paying
for things I wasn't using. So I decided to self host my monitoring on the
infrastructure I was already running anyways. The big switches were using
Nagios instead of Sensu (as I was familiar with it and it has less moving
parts), dropping chat integration and log aggregation as I was barely using it
and switching to Graphite for graphs. Interestingly enough this switch made me
improve my graphing setup a lot. I'm still using collectd and I've extended it
a lot more with custom scripts to track various things.

## Yet Another Graphite Dashboard
However since I wasn't using Librato anymore, I now had to find a way to get
nice overview dashboards for all of my metrics. And I looked into the usual
suspects. But all of them seemed to need a very elaborate setup and running an
additional application server besides `mod_php` which I was already running
for Nagios just for some graphs embedded on an HTML page didn't seem like a
thing I wanted to embark on. I always liked the way we approach [dashboards at
Etsy][etsy_dashboards] a lot. It's basically a PHP framework that gives you a
nice way to create graphs from Graphite or Ganglia and combine them into
dashboards. However it was a bit overkill for my use case and I would have to
write all the code for a typical collectd host anyways. So I wrote my own
little PHP script to generate a list of graphs from a config file. And it was
really nice, took me 20 minutes, was a lot of fun, and did everything I wanted
it to do. I decided to just use Twitter Bootstrap for the UI, which means it
also looks nice on my iPhone and it's aptly named [Yet Another Graphite
Dashboard][yagd].


## Chef integration and additional metrics
Now that I had this nice way of viewing dashboards, I wanted to have more
graphs. I have long made a choice to track as much as possible in Chef for my
personal infrastructure. And graphing is no exception here. Setting up the
initial collectd install is a bit manual as I depend on some options that are
available in the ports but not the official package builds (my infrastructure
is still all FreeBSD). But the configuration and graphing additions are all
fully chef-ed. I took the way we have Ganglia set up at Etsy as the role
model. We have a setup chef-ed to every box that runs all scripts prefixed
with `gmetric-` in a certain location on a minutely cron. This means in order
to get a new set of metrics, you just have to write a shell script that ends
up calling `gmetric` and put it in Chef.  And a couple of minutes later graphs
for all boxes will magically appear in Ganglia. I did the same for my collectd
setup via `collectdctl` and it looks a little bit like this:

```bash
* * * * * for SCRIPT in $(ls /usr/local/collectd/collectd-*); do command ${SCRIPT}; done
```

This means I can now easily add new metrics by dropping a script in there that
utilizes the collectd CLI tooling. However since collectd has a very specific
type setup, each script also needs a corresponding configuration in a custom
types db. I also track this in Chef so it's not too big of a problem. An
example script to track disk temperature looks like this:

```bash
#!/bin/sh

PLUGIN_NAME="disktemp"
HOSTNAME=$(hostname -f)
SMARTCMD="/usr/local/sbin/smartctl"
COLLECTD="/usr/local/bin/collectdctl"

for disk in $(ls /dev/ada* | grep -o "ada[0-9]$"); do
  TEMP=$(${SMARTCMD} -a /dev/${disk} | awk '/194 Temperature_Celsius/ {print $10}')
  ${COLLECTD} putval ${HOSTNAME}/${PLUGIN_NAME}-${disk}/celsius_current interval=60 N:${TEMP}

  if [ $? != 0 ]; then
    echo "ERROR ${0}: ${HOSTNAME}/${PLUGIN_NAME}-${disk}/celsius_current interval=60 N:${TEMP}"
  fi
done
```

Another thing that Ganglia gives you for free is a section for additional
metrics that just appear as soon as you send them with an optional group name
to group them by. In order to emulate that in my setup, the recipes for each
collectd script are also defining node attributes with the Graphite graphs
they are generating and how they are supposed to be displayed. This made a lot
of sense to me as when I'm writing the scripts I have the generated metrics in
my head anyways. And it's easy to just drop them in a node attribute. So for
tracking disk temperature for example, the recipe looks a bit like this:

```ruby
cookbook_file "/usr/local/collectd/collectd-disk-temp.sh" do
  source "collectd-disk-temp.sh"
  owner "root"
  group "wheel"
  mode 0755
end

node.default[:yagd][:additional_metrics][:disk_temperature] = {
  "Disk Temperature" => "collectd.#{node[:fqdn].gsub(".","_")}.disktemp-ada*.celsius_current"
}
```

The next step was now to not have to manually edit the config file for my
dashboards anymore. I now had all the data I needed in Chef, so all it took
was generating the config file there from a Chef search and all graphs were
magically appearing as soon as both the node to monitor and the dashboard host
had run Chef. This can take up to 20 minutes worst case (I run Chef every 10
minutes) which is really not a big deal for me. The Chef search code that does
this for me looks like this:

```ruby
hosts = []
nodes = search(:node, "domain:*unwiredcouch.com")

nodes.each do |computer|

  this_computer = {}

  this_computer[:name] = computer[:fqdn]
  this_computer[:cpus] = computer[:cpu].nil? ? 0 : computer[:cpu][:total]
  this_computer[:apache] = computer.recipes.include?("apache")
  this_computer[:interfaces] = computer.network.interfaces.keys.select {|k| !k.to_s.start_with?"lo" }
  this_computer[:filesystems] = []
  computer.filesystem.each do |k,v|
    name = v[:mount] == "/" ? "/root" : v[:mount]
    # cut out leading '/'
    name[0] = ''
    # substitute '/' with '-'
    name.gsub!("/", "-")
    # substitute '.' with '_'
    name.gsub!(".", "_")
    # and add to array
    this_computer[:filesystems] << name
  end
  this_computer[:additional_metrics] = computer[:yagd][:additional_metrics] unless computer[:yagd].nil?

  hosts << this_computer

end

template "#{dashboards_dir}/config.php" do
  source "yagd.config.php.erb"
  owner "www"
  group "wheel"
  mode 0775
  variables( :hosts => hosts )
end

```

And this is the accompanying erb template that gets rendered into a PHP file
to serve as the configuration for my dashboards instance.

```erb
<?php

$CONFIG = array(
    'title' => "dashboards",
    'navitems' => [
        'Hosts' => '/hosts.php',
        'Graphite' => '/graphite.php',
        'Twitter' => '/tweets.php'
    ],
    'graphite' => [
      'host' => "https://graphite.example.com",
      'hidelegend' => false
    ],
    'hosts' => array(
      <% @hosts.each do |host| %>
       "<%= host[:name] %>" => array(
         "cpus" => <%= host[:cpus] %>,
         "apache" => <%= host[:apache] %>,
         "interfaces" => <%= host[:interfaces].to_json %>,
         "filesystems" => <%= host[:filesystems].to_json %>,
         "additional_metrics" => [
           <% host[:additional_metrics].each do |name,values| %>
           "<%= name %>" => [
             <% values.each do |title,metric| %>
               "<%= title %>" => "<%= metric %>",
             <% end %>
           ],
           <% end %>
         ]
       ),
    <% end %>
    )
);
```

## The Cleanup

After all of this configuration, my dashboard setup was working beautifully
and I added more and more graphs I was interested in. But it was still more or
less the 20 minute PHP code I had initially thrown together.  This was
technically fine and I didn't mind it too much. But at the same time I thought
it might be nice to bring it in a state where it's usable for others.  So I
decided to take some time to clean it up and make it more generically usable.
So I refactored the code, added unit tests to run on [Travis CI][yagd_travis]
and hooked it up to [Code Climate][yagd_cc] so I could have a computer tell me
how I can improve the code quality.

With this refactor in place it's now fairly easy to get a dashboard page that
shows the status of all hosts:

```php
<?php

require __DIR__ . '/../vendor/autoload.php';

include_once("../config.php");

use Yagd\CollectdHost;
use Yagd\Page;

$page = new Page($CONFIG);
echo $page->getHeader($CONFIG["title"],
    $CONFIG["navitems"]);

foreach($CONFIG["hosts"] as $host => $data) {

    $fss = empty($data["filesystems"]) ? [] : $data["filesystems"];

    $server = new CollectdHost($host, $data["cpus"], $fss,
                               $data["interfaces"]);
    $server->setGraphiteConfiguration($CONFIG["graphite"]["host"]);
    echo "<h2> {$host} </h2>";
    $server->render();
}

echo $page->getFooter();
```

You can also [inject a selectbox][yagd_sbox] into the header to have it be
possible to just select a single server instead of always displaying all of
them. This makes it really nice to be able to just browse to something like
`https://yagd.example.com/hosts.php?hostname=foo.example.com` and get a quick
overview of how that that host is doing. Plus it gives you a URL you can link
to from anywhere else.

Also since this is just plain PHP, entirely driven by the config file,  it's
possible to have a per cluster view by passing a URL parameter like
`?cluster=name` and then changing the `include_once()` code in that example to
include a different config file based on that. And since Chef already knows or
can know all that data (maybe each cluster is its own role? ), it's just a
matter of writing some ruby to generate different sets of config files for the
dashboards.

## Summary
Writing yagd has been a lot of fun. The initial version took - as I already
said - about 20 minutes to write and I learned a ton of things while
refactoring it into a usable PHP module. You can install it via composer [from
packagist][yagd_packagist] if you want to try it out and use it for your own
dasboards.

However the point of this is not so much that I wrote yet another dashboard
framework, but rather how easy it was to get this going. Sure it's not super
trivial to get your infrastructure into Chef if it's not. And it also takes
some time to install Graphite if you aren't familiar with it. But with those
things in place, you have all the building blocks to quickly whip up a nice
dashboarding solution with some simple PHP.

As much as I love how many frameworks and libraries there are to
already solve those problems for us, I think it's a good practice to
occasionally go back to the basics and think about what the simplest solution
is I actually need. In my case this was showing graphs on an HTML page in a
somewhat structured way. I didn't need anything more fancy. And there was no
reason to try and find the dashboard solution that would do that, preferably
in PHP so I don't have to set up yet another application server, which most
likely solved way more problems that I actually had.

If you want to give [yagd][yagd] a try, I would love to hear what you think.
I currently track 4 servers and 2 jails with it, but for this and other
reasons it won't be the solution to all dashboarding problems. Nor should it.
The way more important thing in my mind is that it's solving a very specific
problem I had, in a pretty simple way. And in addition served as a side
project for me to learn a lot of things about writing PHP, setting up phpunit,
using codeclimate, and creating a reusable package on Packagist I didn't know
before.


[monitoring_gs]: https://unwiredcouch.com/2012/09/15/getting-started-with-monitoring.html
[yagd]: http://code.mrtazz.com/yagd/
[yagd_travis]: https://travis-ci.org/mrtazz/yagd
[yagd_cc]: https://codeclimate.com/github/mrtazz/yagd/
[yagd_sbox]: https://github.com/mrtazz/yagd#inject-a-select-box-into-the-navbar
[yagd_packagist]: https://packagist.org/packages/mrtazz/yagd
[etsy_dashboards]: https://github.com/etsy/dashboard
