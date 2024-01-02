---
title: "Maglev: Fast Software Load Balancer"
author: "Danielle E. Eisenbud, Cheng Yi, Carlo Contavalli, Cody Smith, Ardas Cilingiroglu, Bin Cheyney, Wentao Shang, Jinnah Dylan Hosein, Roman Kononov, Eric Mann-Hielscher"
date: 2018-05-29
category: paper
publication_date: 2016
origin_url: "https://research.google/pubs/maglev-a-fast-and-reliable-software-network-load-balancer/"
---

- Google's network load balancer
- distributed system on commodity servers
- no physical deployment
- horizontally scalable
- load distribution via ECMP by network routers
- consistent hashing and connection tracking
- serving Google since 2008
- Downside of hardware LB
  - limited vertical scale
  - only 1+1 redundancy
  - lack of flexibility + programmability
  - expensive to upgrade

![maglev architecture overview](/images/reading/maglev/sketch.png)

- larger clusters have hardware encapsulators between maglev and router so they don't need to be in the same L2 domain
- Linux kernel is circumvented for fast packet processing
- steering module consistent hashes between rx queues with packet rewrites threads
- rewrites checks for VIP match, connection table
- 5 tuple host over round robin for stability of connections (rr is fallback)
- 813 kpps for 1500 bytes IP packets
- processing speed of 9.06 Mpps for smaller packets

## Fast Packet Processing
- userspace app circumventing kernel
- shared packet pool with NIC
- ring queue of pointers pointing to packets in pool
- NIC and forwarder advance pointers in ring (no copying)
- backend selection consistency across Maglev machines is accomplished by consistent hashing based on backend names (**simplified algorithm!!**)
- kernel bypass 5x performance
- handling fragments via special backend pool containing all Maglevs
- special packet tracer packets that trigger Maglev to send debug info to SRC
- steering module bottleneck before moving to 40Gbps
- 5 packet threads saturate 10Gbps NIC

## Questions
- [ ] read up on ECMP
- [ ] study Maglev hashing details

