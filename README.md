# The AS Enemies List

> Always remember that others may hate you, but those who hate you don't win unless you hate them. And then you destroy yourself.

-- [Richard Milhouse Nixon](http://www.youtube.com/watch?v=1Ff1jxlVPEQ)

This is a minimalistic web app to aid in keeping tabs on Internet ASes of ones
choosing.  I expect that there is a very small, boring audience for this sort
of thing, but I'm amongst it, so here it is. 

Basically, it consists of two parts: 

1. whois.pl, which takes a list of ASes and looks up any (new) IP addresses
belonging to an AS, runs it past whatever RDNSBL(s) you choose, and then
finally records the results.  This part is meant to run as a regular cronjob.
In other words, it can show you which portions of a given AS may have been
dealt with by said RDNSBL(s) and which haven't. More generally, it aids in
showing the growth or shrinkage of various entities on the Internet.

2. A CGI::Application portion which presents the data and allows some amount
of manipulation and tracking thereof.

## Using the Enemies List

To start off, add a line like this via the "Edit Enemies List" page:

    123456 SPAMMERS-R-US spammers

The first field is the ASN, the second is the AS name, and the third is whatever
dispensation you might feel is apropriate.  Conversely, you can just dump stuff
directly into data/enemies.json, which works with a format like this:

    { "enemies" : [{ "name" : "SPAMMERS-R-US", "asn" : "123456", "disp" : "spammers" },
        { "name" : "HIJACKED-AS", "asn" : "111111", "disp" : "hijacked" },
        { "name" : "CRACKERZ", "asn" : "101010101", "disp" : "crackers" },
        { "name" : "UNKNOWN", "asn" : "22222222", "disp" : "unknown" }, 
        ... 
    ] 
    ...  
    }

Your choice. 

The "Activity Log" page shows the past activity of the app.  The "Browse
Enemies List" page is self-explanatory.

I'm guessing that anybody who could possibly be interested in this app would
already have the knowledge and the means to process the results it produces, so
I'll say no more in that regard.

## Modifications

- Right now, whois.pl just samples a single IP address in each allocation
 belonging to an AS.  That is sufficient for my own use, but it could be
modified to sample more than one IP.  It is probably not a good idea to test
every single IP address though.

- The [CGI::Application](http://cgi-app.org/) library has a nice web page.  

- Since everything is stored as structured text files in JSON format, it would be
quite easy to tack on MongoDB to the app, or conversely, with some further
modifications, another kind of database.

## Requirements

The following Perl modules are required:

- CGI::Application
- CGI::Session
- JSON
- Net::DNS
- CGI::Session::Driver
- CGI::Carp 
- HTML::Template
