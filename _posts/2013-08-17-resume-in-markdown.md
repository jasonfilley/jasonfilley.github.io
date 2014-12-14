---
layout: post
title: Resume in Markdown
permalink: /2013/08/17/resume-in-markdown/
---

It used to be a sign of technical prowess to compose a resume in LaTeX -- you wanted to take the extra effort to make a professional, beautiful document. Now, unfortunately, nobody reads printed resumes -- employers just want something to copy-and-paste into a database field so they can search for whatever isolated skill set they're looking for. Nice-looking PDF's may not fit the bill; copying and pasting may lose all the nice ligatures. Where you mention "Office", pasting into Word will drop the "ffi" ligature into gibberish, and you're left with "Oce". Unless you're looking for a printer job, this isn't what you want.

And, face it, almost everyone wants a Microsoft Word copy.

IT staff need to keep their resumes current, regardless of job search status. Employers may want an internal database. They may provide a bundle of resumes to prospective clients, to show off their staff competence -- happened for me recently.

A lot of people have recently concluded that Markdown (in [Pandoc](http://johnmacfarlane.net/pandoc/)) is an easily-maintainable and portable text format suitable for publishing resumes. For example:

[http://sysadvent.blogspot.com/2011/12/day-14-write-your-resume-in-markdown.html](http://sysadvent.blogspot.com/2011/12/day-14-write-your-resume-in-markdown.html)

Problem is that the PDF's I've seen are serviceable, but they're bug-ugly. The Microsoft Word output is nice, but you still want a decent-looking PDF.

This zip file includes a XeTeX template that I like. The Makefile also generates a Windows-formatted text file suitable for a raw copy-and-paste into online forms. Zips all the output formats into one file, so you can just email someone the whole thing. Pick one.

Name your resume something like "your_name.md" and update the "ME=" line in the Makefile to match "your_name", run `make clean && make` and Bob's your uncle. Thanks.

[resume_template.zip]({{ site.url }}/images/resume_template.zip)

E.g.,

#Your Name
1234 Main St., City, State 12345    
(555) 555-5555        
your.name@example.com          
http://www.example.com          
http://www.linkedin.com/in/yourname      

#Summary

Quick Summary (not objective) specifically highlighting why you qualify for the job.

#Work Experience (only last 10 years)

## Company Name 1 (City, State)
*[Company 1][] description, particularly if not well-known.*

**Position Title (include alternate titles in parentheses)** (Start Date - End Date)

Summary of your role

- Accomplishment that contains **bold text**.
- Accomplishment
- Accomplishment
- Accomplishment

## Company Name 2 (City, State)
*[Company 2][] description, particularly if not well-known.*

**Position Title (include alternate titles in parentheses)** (Start Date - End Date)

Summary of your role

- Accomplishment that contains **bold text**.
- Accomplishment
- Accomplishment
- Accomplishment

## Company Name 3 (City, State)
*[Company 3][] description, particularly if not well-known.*

**Position Title (include alternate titles in parentheses)** (Start Date - End Date)

Summary of your role

- Accomplishment
- Accomplishment
- Accomplishment
- Accomplishment





[Company 1]: http://www.example.com/company1
[Company 2]: http://www.example.com/company2
[Company 3]: http://www.example.com/company2
