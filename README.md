# ODS Markup: Tagsets by example

This is a book I wrote over a period of about 3 months sometime
around 2002. I have forgotten the details. It was accepted and
slated for publishing by the SAS Press. I do not recall why 
it stalled in the process and was never published. Perhaps
because it is written in LaTeX which I remember being a problem
for them.

I no longer have any interest in this, I enjoyed creating all
of things I did for SAS. Helping our users, writing papers and
extending the possibilities of the software. That was a long time ago.
I have no respect for SAS. 

ODS Markup and Tagsets are still in use, so maybe there are people
interested in this. So here it is. I´m not sure what it might take
to get it compiled into a pdf, but should not be too difficult.


## Introduction

At first glance, the ODS Markup destination looks just like all the
other ODS destinations. It has the same syntax and options as ODS HTML.
But ODS Markup is different.  The other ODS destinations have a
fixed output type.  The RTF destination can only create RTF output.
The printer destination can create postscript, PCL, and PDF.  But ODS
Markup can create any number of output types, all of which can be
created or modified by anyone.

ODS Markup is able to do this because it is really a framework which
uses a tagset to define what it should print to it's files.  The other
destinations, including the old HTML destination were hard coded
and compiled as a part of the SAS executable.  We can create and
use as many different tagsets as we like.  SAS ships 52 different
tagsets.  ODS Markup is rather chameleon-like because of this.  ODS
HTML is really ODS Markup.  So is the CSV destination, and CHTML,
excelXP, LaTeX, Troff, etc.  The only difference between these different
ODS destinations is the tagset that is in use.  They are all really
ODS Markup.
 
When we use ODS Markup we are using a tagset.  The tagset determines
the type of output. Therefore, a tagset defines an output destination!
This realization has far reaching implications.  It means that we
can change the html that ODS HTML generates.  It means we can create
a new HTML destination with your corporate style and headings.  We
can create a new XML destination to allow data interchange with a
business partner or client.  The possiblities are endless.

It stands to reason, that if we want to use ODS Markup to our best
advantage, what we really want to do is use tagsets.  So that
is what we are going to explore.  What are these tagsets and how
do we use them?  You will find that tagsets can simplify otherwise
complex problems in a way that allows reuse and flexibility that
would not be available with out them.


