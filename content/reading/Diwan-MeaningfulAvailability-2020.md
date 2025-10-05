---
title: Meaningful Availability
author: Amer Diwan, Dan Ardelean, John Lunney, Philipp Hoffmann, Tamás Hauer
publication_date: 2020
date: 2023-11-01
origin_url: https://www.usenix.org/conference/nsdi20/presentation/hauer
media_type: paper
status: needs review
---

SLOs the way they are usually constructed heavily bias towards the most active
user. This isn't necessarily a good representation of the overall customer
impact of an incident. In order to address that, a mechanism called "windowed
user-uptime" is introduced to make the measure of user impact more
representative.

## Detailed discussion

The paper starts with an introduction of the usual approach for SLOs:

> “Success- ratio is the fraction of the number of successful requests to total requests over a period of time (usually a month or a quarter) [” (Diwan et al., 2020, p. 1)

This plain calculation has the advantage that it's very easy to calculate but comes with the bias of skewing towards most active users as they will represent more requests (successful as well as unsuccessful) in the overall ratio.

The general form of availability metrics are defined as

```
availability = good service / total demanded service
```

And the way service is measured here generally falls in one of two buckets. Either time based which means the time between failures is uptime and the time recovering from a failure is downtime. Which leads to a metric defined as

```
availability = uptime / (uptime + downtime)
```

This measure strongly relies on the definition and precise meaning of "failure" and "recovery". Especially given situations of partial failure, the definition on whether failure means for all users or at least one user or something in between becomes important for the result of what it means for measuring availability. Here percentage thresholds are often introduced for the definition, to be able to say something like "failure means at least 5% of users encounter errors". Which still comes with the problem of an arbitrary threshold. Within this definition a system with 5% error rate is treated the same as one with 0.0001% error rate given the chosen threshold as the delineation line. And the general downsides of this measure are:
- it's not proportional to the severity of the system's unavailability
- not proportional to users affected
- not actionable with not insight into source of failures
- not meaningful as they rely on arbitrary thresholds and/or manual judgements

For the other approach of _count based_ availability which is much more rare and is based on the similar definition of
```
availability = successful requests / total requests
```

There is some popularity to this approach as it is easy to implement. However users ultimately care about time they were able to use a service and not the number of requests they were able to do. So this approach also comes with the downsides of:
- not meaningful as it's not based on time
- being biased towards highly active users
- being biased due to different client behaviour during outages
There is a quick discussion of synthetic probes for measuring system availability but this isn't really discussed deeply as it comes with the downsides of not being representative of user activity and not proportional to what users experience. So for the goals of meaningful measure of uptime it's not a good fit.

In order to improve on these

