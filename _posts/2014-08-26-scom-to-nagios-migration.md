---
layout: post
title: SCOM to Nagios Migration
---

Merely as a thought experiment (I like [SCOM](http://www.microsoft.com/en-us/server-cloud/products/system-center-2012-r2/default.aspx) and [Nagios](http://www.nagios.org/) both), if one were to implement Nagios, [Icinga](https://www.icinga.org/), et al., to cover the same functionality as SCOM, what would be the quickest and surest way?

SCOM and Nagios both do nothing -- they're just frameworks for collecting data and figuring out if it meets criteria to alert or report on.  SCOM without Management Packs is like Nagios without plugins: useless.  The most important part of monitoring is knowing what you want to monitor, but the documentation for hardware and software aren't generally very specific.  "Monitor the event logs for stuff with Red by them" isn't useful.  SNMP MIBs without any corresponding declaration of 'normal' is a start, but it's not good.  It's time-consuming to start from scratch (even from "Best Practices" whitepapers) and try to figure out what to monitor, what's normal, and what the severity is when things aren't normal.

The best documentation for monitoring Microsoft products (or anything with a SCOM management pack), is the management pack.  Load up a SCOM console (eval copy works fine), download the free [MPViewer utility](http://blogs.msdn.com/b/dmuscett/archive/2012/02/19/boris-s-tools-updated.aspx), [download the management pack(s) you need](http://social.technet.microsoft.com/wiki/contents/articles/16174.microsoft-management-packs.aspx), install them, then open MPViewer and view the management pack contents.  Discovery is much more difficult with Nagios (an exercise for the reader), but if you're looking for monitors and rules for 90% of use cases (eventlog id's, service status, perfmon counters, network status), it's pretty trivial to convert to [NSClient++/NSCP](http://www.nsclient.org/) checks.   Someone savvy enough could probably automate a great deal of it, though I bet Microsoft's lawyers might object....


