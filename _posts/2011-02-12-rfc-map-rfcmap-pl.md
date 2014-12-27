---
layout: post
title: RFC Map
permalink: /2011/02/12/rfc-map-rfcmap-pl/
---

[rfcmap.pl]({{ site.url }}/images/rfcmap.pl) parses the [RFC index](ftp://ftp.rfc-editor.org/in-notes/rfc-ref.txt)
 and produces [Graphviz](http://www.graphviz.org/) output.

<!--excerpt-->

For example, here’s the output for 

{% highlight console %}
perl -T rfcmap.pl RFC0821 RFC0822 RFC1035
{% endhighlight %}

which covers some of the initial documents on SMTP, mail message format, and domain names.

![RFC map relating to RFC's 821, 822, and 1035]({{ site.url }}/images/email_and_domains.png)


{% highlight perl %}
{% include rfcmap.pl %}
{% endhighlight %}

