---
date: 2022-05-11
title: "replace a disk in a running ZFS zpool"
url: /bits/2022/05/11/replace-zpool-disk.html
---


I've recently had to replace all disks in a `zroot` zpool on [my FreeBSD server](https://unwiredcouch.com/2013/10/30/uncloud-your-life.html).
And I kept looking up the commands and order in which to run them. So I thought I'd put them here to find them again when I need them.

The following assumptions are being made with this:
1. The `ada0` disk was faulty and already replaced
2. `ada1` is running in the zpool and working
3. Both `ada0` and `ada1` are the same size and have the same layout

## Replace the disk itself

1. First up we restore the disk layout from `ada1` onto `ada0` and verify:
``` 
# gpart backup ada1 | gpart restore -F ada0
# gpart show ada0
```

2. Given this is a `zroot` pool to boot from, we need a bootcode
```
# gpart bootcode -b /boot/pmbr -p /boot/gptzfsboot -i 1 ada0
```

3. Now we just replace the (missing) disk in the zpool with its replacement:
```
# zpool replace zroot ada0p3 /dev/ada0p3
# zpool status zroot
```

At this point the zpool is being resilvered to make sure all data is on the new disk. Depending on the amount of data
this can take a while. And while it's running `zpool status zroot` shows something like:

```
# zpool status zroot
  pool: zroot
 state: DEGRADED
status: One or more devices is currently being resilvered.  The pool will
        continue to function, possibly in a degraded state.
action: Wait for the resilver to complete.
  scan: resilver in progress since Tue May 10 07:15:33 2022
        416G scanned at 144M/s, 382G issued at 133M/s, 417G total
        384G resilvered, 91.66% done, 00:04:28 to go
config:

        NAME              STATE     READ WRITE CKSUM
        zroot             DEGRADED     0     0     0
          mirror-0        DEGRADED     0     0     0
            replacing-0   DEGRADED     0     0     0
              ada0p3/old  REMOVED      0     0     0
              ada0p3      ONLINE       0     0     0  (resilvering)
            ada1p3        ONLINE       0     0     0

errors: No known data errors
```


## Configure encrypted swap
The zroot setup from the baseinstall also comes with encrypted swap. So this also needs to be
configured on the new disk:

1. Check setup and options from the existing swap partition
```
# geli list ada1p2.eli
Geom name: ada1p2.eli
State: ACTIVE
EncryptionAlgorithm: AES-XTS
KeyLength: 128
Crypto: accelerated software
Version: 7
Flags: ONETIME, W-DETACH, W-OPEN, AUTORESIZE
KeysAllocated: 1
KeysTotal: 1
Providers:
1. Name: ada1p2.eli
   Mediasize: 2147483648 (2.0G)
   Sectorsize: 4096
   Mode: r1w1e0
Consumers:
1. Name: ada1p2
   Mediasize: 2147483648 (2.0G)
   Sectorsize: 512
   Stripesize: 0
   Stripeoffset: 1048576
   Mode: r1w1e1
```

2. Set up the new swap partition with the same options
```
# geli onetime -d -e AES-XTS -l 128 -s 4096 /dev/ada0p2
```

3. Turn new swap partition on
```
% swapon -a
```

**Notice:**
When running `swapinfo` the old swap partition still shows up as a kinda ghost partition. I haven't
experienced any problems with that and it usually goes away on the next reboot.

```
# swapinfo
Device          1K-blocks     Used    Avail Capacity
/dev/#C:0x86      2097152        0  2097152     0%
/dev/ada1p2.eli   2097152        0  2097152     0%
/dev/ada0p2.eli   2097152        0  2097152     0%
Total             6291456        0  6291456     0%
```
