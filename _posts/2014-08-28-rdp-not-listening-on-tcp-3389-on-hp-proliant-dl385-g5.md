---
layout: post
title: RDP not listening on TCP 3389 on HP ProLiant
permalink: /2014/08/28/rdp-not-listening-on-tcp-3389-on-hp-proliant-dl385-g5/
---

Hope this saves someone some time:  RDP was not listening on TCP 3389 on a new server build.  Followed the standard troubleshooting (verify registry, re-create RDP listener, etc). When showing hidden devices in device manager, tdtcp (tdtcp.sys) was not enabled.  NIC is HP373i (Broadcomm), but the tdtcp driver would not load until after I installed the HP Network Configuration Utility (NCU)  + reboot.  Tip your waitress.

