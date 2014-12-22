---
layout: post
title: RDP Cookies
permalink: /2011/02/06/rdp-cookies-2/
---

Windows terminal server (remote desktop session host) environments needing load balancing and high availability may use 3rd-party load balancers to distribute initial connections and persist further network connections. Load balancers utilize RDP cookies -- short text strings sent by RDP clients in initial connection requests.

<!--excerpt-->

Native Windows functionality may be sufficient for some needs, say by creating a terminal server farm and using round-robin DNS to distribute initial connections ("Poor Man's Load Balancing"). For example, given three terminal servers (TERM{1,2,3}) with IP addresses 10.10.10.{1,2,3}, the administrator would publish a DNS A record (e.g., "TERMFARM") with the multiple IP addresses of each terminal server. The client requests the address for "TERMFARM" is [somewhat] randomly given one of the IP addresses and connects to that server. Of course, when the client disconnects and tries to connect again, a different IP address may be returned, and the client would log in at that server, causing two active sessions to be open. This is very unproductive for users, and it's a waste of resources. Microsoft Session Broker (Connection Broker) can be used to keep track of open sessions, and subsequent reconnects redirect the user back to the server hosting their existing session ("revectoring"). This generally works fine. There are a few downfalls: 

1. The initial connection may fail if the randomly-returned server is down, and the client will wait 30 seconds before trying the next, 
2. Windows Server 2003 must be the more expensive Enterprise Edition to use Session Broker, 
3. Windows 2003's Session Broker doesn't do any actual load balancing, and 
4. Windows Server 2008's Connection Broker is better (load balances solely on session count), but it incorporates no other intelligence. Additionally, RDP clients have to have direct IP connectivity with the terminal servers, which may not be desirable in some cases.

As an alternative, consider putting a couple of UNIX servers out in front, running [HAProxy](http://haproxy.1wt.eu/) on a shared IP address, by using [keepalived](http://www.keepalived.org/) or similar. RDP clients would connect to a DNS name pointing to an IP address. keepalived manages the failover IP address so that if the primary load balancer fails, the second one picks up the traffic. The HAProxy load balancing software understands RDP cookies and can load balance connection requests. Savvy admins and value-added companies can add more intelligence to the load balancing. You could weight some servers higher than others, or include memory and CPU load, rather than using a sessions-per-host metric. Also, using a 3rd-party load balancer can hide the servers, simplifying network and firewall administration effort.


#Connection Request Protocol Details

Remote Desktop Protocol (RDP) clients send a small text string  a cookie or routing token when starting a new connection. RDP is implemented through the [ITU X.224 protocol](http://www.itu.int/rec/T-REC-X.224/en), where commands are encapsulated in Protocol Data Units (PDU). RDP connection requests use X.224 Connection Request PDU.

ITU ["T.123:Network-specific data protocol stacks for multimedia conferencing"](http://www.itu.int/rec/T-REC-T.123/en)

ITU ["X.224:Information technology - Open Systems Interconnection - Protocol for providing the connection-mode transport service"](http://www.itu.int/rec/T-REC-X.224/en)

Microsoft ["2.2.1.1 Client X.224 Connection Request PDU"](http://msdn.microsoft.com/en-us/library/cc240470)

A X.224 Connection Request PDU has the following layout:

![RDP Connection Request]({{ site.url }}/rdp_connection_packet.png)


# Cookies

Cookies are simple text strings and have nothing to do with authentication or any type of negotiation -- they are just a string of text set by the RDP client. There are two types of cookies, and they're mutually exclusive -- a connection request can only contain one type of cookie. They are:

* User cookie (mstshash): ANSI text string that almost always contains a username.
* IP cookie (msts): numeric string that encodes the IP address and port number to route the connection to.


## User Cookies (mstshash:)

A user cookie is intended to map a user to a specific terminal server, even if the user disconnects and reconnects from a different client and IP address.

The format of the user cookie is:

Cookie:[space]mstshash=[ANSI string][0x0d0a]

10:57:26.321918 192.168.0.201.33520 > 192.168.0.93.3389:
P 2000684428:2000684480(52) ack 3864383132 win 5840
<nop,nop,timestamp 2842032495848714> (DF)
0000: 4500 0068 53a2 4000 4006 6477 c0a8 00c9 E..hS@.@.dw(.?
0010: c0a8 005d 82f0 0d3d 7740 058c e655 ce9c (.].?.=w@..?U?.
0020: 8018 16d0 3908 0000 0101 080a 0004 562b ...?9.........V+
0030: 94c3 a10a 0300 0034 2fe0 0000 0000 0043 .....4/?.....C
0040: 6f6f 6b69 653a 206d 7374 7368 6173 683d ookie: mstshash=
0050: 6a61 736f 6e74 6573 7440 636f 7270 0d0a jasontest@corp..
0060: 0100 0800 0000 0000 ........

The cookie is then 'mstshash=jasontest@corp'.

A load balancer will keep a table listing the cookie and target  server IP address, using the cookie to balance the initial connection if  no state already exists, or routing the connection to the appropriate  server if an existing session does exist.

For example, USER1 has no existing session on any terminal server. USER1's RDP client sends an RDP Connection Request to the load balancer (with cookie mstshash=USER1), and the load balancer sees that mstshash=USER1 has no existing state (no active sessions). The load balancer, depending on configuration, applies an algorithm to determine where the request should be sent. Most load balancers default to round-robin, but different implementations may have more intelligent methods, like using terminal server agents to report back load (memory, CPU, etc.,) that the load balancer can use when routing initial connections. USER1's connection request is sent to a terminal server.


### Cookie Size and Interoperability
Different RDP client implementations impose different size limits on the user cookie:

* The Windows RDP client (mstsc.exe) truncates the user cookie to 9 characters.</li>
* Newer versions of the Windows RDP client can use the [LoadBalanceInfo](http://msdn.microsoft.com/en-us/library/aa381177%28VS.85%29.aspx) property and set the cookie up to 110 characters. [More](http://technet.microsoft.com/en-us/library/ee891143%28WS.10%29.aspx)

* [rdesktop](http://www.rdesktop.org) limits the cookie to 127 characters.
* [ProperJavaRDP](http://properjavardp.sourceforge.net/) and [Elusivas Open Source Java RDP](http://www.elusiva.com/opensource/) fork both truncate the user cookie to 9 characters: (iso.java): 

{% highlight java %}
if(uname.length() > 9) uname = uname.substring(0,9);
{% endhighlight %}


This truncation causes certain issues.

The most well-known issue is a collision that occurs when cookies are truncated to 9 characters. For instance, the default Microsoft client cookie for DOMAIN\USER1 is "DOMAIN\US" (9 characters). The default Microsoft client cookie for DOMAIN\USER2 is also "DOMAIN\US" (9 characters). The cookies are the same for both connection requests, and a load balancer would route them to the same server. The consensus solution for this is to use the USER@DOMAIN login format. So, USER1@DOMAIN would have cookie "USER1@DOM", while USER2@DOMAIN would be "USER2@DOM".

But note that the user can't switch formats. "CORP\Bob" connects with cookie "CORP\Bob" and disconnects. He connects again, but uses "Bob@CORP" with cookie "Bob@CORP". These cookies are different, so a load balancer will treat the connections differently -- he may end up with different sessions on different servers.

Another snafu occurs when switching between clients that truncate the cookie and those that don't. CORP\ROBERT logs in from a Windows XP RDC client and opens a session on TERM-01. He heads out to the warehouse and logs in from a UNIX thin client using rdesktop. But he ends up with a new session on TERM-02. His first connection was with cookie "CORP\ROBE", while his second connection used cookie "CORP\ROBERT".


## IP Cookies

IP-based routing tokens "msts=" are handed back by Windows Session Broker / Connection Broker when "Use IP Address Redirection" is disabled.

![Use Token]({{ site.url }}/images/use_token1.png)


Cookie:[space]msts=[ip address].[port].[reserved][0x0d0a]
09:39:40.133269 192.168.0.93.34764 > 192.168.0.87.3389:
P 3072855348:3072855403(55) ack 1295660978 win 46
<nop,nop,timestamp 2836782526209545> (DF)
0000: 4500 006b d090 4000 4006 e7f7 c0a8 005d E..k?.@.@.??(.]
0010: c0a8 0057 87cc 0d3d b728 0d34 4d3a 37b2 (.W.?.=(.4M:7
0020: 8018 002e 8262 0000 0101 080a a915 ddbe .....b.......?
0030: 0003 3289 0300 0037 32e0 0000 0000 0043 ..2....72?.....C
0040: 6f6f 6b69 653a 206d 7374 733d 3134 3933 ookie: msts=1493
0050: 3231 3534 3234 2e31 3536 3239 2e30 3030 215424.15629.000
0060: 300d 0a01 0008 0000 0000 00             0..........

Decode the IP address as follows:

* Convert decimal to hex: 1493215424 = 59 00 A8 C0
* Reverse the bytes: C0 A8 00 59
* Convert back to decimal: 192 168 0 89 (192.168.0.89)

Decode the TCP port likewise:

* Convert decimal to hex: 15629 = 3D 0D
* Reverse the bytes: 0D 3D
* Convert back to decimal: D3D = 3389

The reserved section should always be "0000".

#Monitoring

I wrote a short Perl script to parse offline tcpdump packet dumps for RDP cookies:

{% highlight perl %}
{% include watch_rdp_cookies.pl %}
{% endhighlight %}


## tcpdump

{% highlight winbatch %}
tcpdump -s 65535 -X dst port 3389 and tcp[37] == 0xe0
{% endhighlight %}


## Wireshark

[Wireshark's RDP documentation](http://wiki.wireshark.org/RDP)

Filter: 'x224.rdp_rt'

![Wireshark]({{ site.url }}/images/wireshark_rdp_connect.png)


## Network Monitor

Description == "X224:Connection Request"

![Network Monitor]({{ site.url }}/images/netmon_rdp_connect1.png)

Make sure the Windows parser profile is loaded.

![Network Monitor]({{ site.url }}/images/netmon_rdp_connect2.png)





