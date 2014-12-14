---
layout: post
title: Regain space on Windows Embedded Standard 7 by Removing Speech Components
permalink: /2013/03/17/regain-space-on-windows-embedded-standard-7-by-removing-speech-components/
---

Update: [Disk Cleanup Wizard addon lets users delete outdated Windows updates on Windows 7 SP1 or Windows Server 2008 R2 SP1 (KB2852386)](http://support.microsoft.com/kb/2852386)

I picked up an HP t5740e thin client off eBay, as I had deployed some at a prior job.  Window Embedded Standard 7 (32-bit), with 2GB RAM and 4GB flash.  Set it up the way I want it, re-enable the write filter, and Bob's your uncle.   But the default HP build includes components that take up a lot of space, and I have no need for them -- namely, the text-to-speech components, the natural language components, and the SAT performance tests (sample movies).

While logged in as Administrator, with the write filter disabled:

{% highlight winbatch %}
dism /online /Get-Packages
{% endhighlight %}

You'll get a list of all packages installed in the running image. Find the ones you want to delete. Then delete them. Reboot.

{% highlight winbatch %}
dism /online /Get-Packages

dism /online /Get-PackageInfo /packagename:WinEmb-Natural-Language~31bf3856ad364e35~x86~~6.1.7601.17514

dism /online /Remove-Package /PackageName:WinEmb-Accessibility~31bf3856ad364e35~x86~~6.1.7601.17514
dism /online /Remove-Package /PackageName:WinEmb-Natural-Language~31bf3856ad364e35~x86~~6.1.7601.17514
dism /online /Remove-Package /PackageName:WinEmb-Speech-LP-ENU~31bf3856ad364e35~x86~~6.1.7600.16385
dism /online /Remove-Package /PackageName:WinEmb-Speech~31bf3856ad364e35~x86~~6.1.7601.17514
dism /online /Remove-Package /PackageName:WinEmb-Diagnostics-Performance~31bf3856ad364e35~x86~~6.1.7601.17514
{% endhighlight %}








