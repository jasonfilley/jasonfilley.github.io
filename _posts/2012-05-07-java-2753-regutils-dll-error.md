---
layout: post
title: Java 2753 regutils.dll error
permalink: /2012/05/07/java-2753-regutils-dll-error/
---

I had a workstation today that would not install the 6.0_update32 JRE, getting the error "error 2753 regutils.dll".

[Sun/Oracle's 'troubleshooting' is worthless](https://forums.oracle.com/forums/thread.jspa?threadID=1316410&amp;start=15&amp;tstart=30).  Nobody else's was any help, either, though.  [JavaRa](http://singularlabs.com/software/javara/) gave it a good try. 

So, fire up [procmon](http://technet.microsoft.com/en-us/sysinternals/bb896645), include "msiexec.exe" and see what pops up....

![Java 2753 Registry Error msiexec]({{ site.url }}/images/java_2753_regutil_dll_error.png)

Simple enough.  The installer thinks there's another conflicting existing installation:

![Java 2753 Registry Error key]({{ site.url }}/images/java_2753_error_registry.png)

Delete the registry key (and subkeys):

 HKEY_CLASSES_ROOT\Installer\Products\4EA42A62D9304AC4784BF238120632FF

Easy enough.

So, why can't Sun/Oracle release a utility to clean up all traces of Java?  Laziness, pure and simple.  This has been a pain for admins for years.  Fix your installer.

