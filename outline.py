#!/usr/bin/env python

import os, re, sys, smtplib, shutil
from ConfigParser import ConfigParser    
from UserList import UserList    
from string import split, join, find, strip, replace, upper, lower

class Outline:

    def __init__(self):
        self.read_par = None;
        print "\documentclass{book}"
        print "\usepackage{fancyhdr, flafter, makeidx, float, times}"
        print "\usepackage[T1]{fontenc}"
        print "\usepackage{graphicx}"
        print "\usepackage{fancyvrb}"
        print "\usepackage[color]{ods}"
        print "\pagestyle{fancy}"

        print "\makeindex"

        print "%includeonly{Introduction, chap1}"

        print "\\begin{document}"

        print "\\fancyhead{} %clear all fields"
        print "\\fancyhead[LO,RE]{\\thepage}"
        print "\\fancyhead[RO]{}"
        print "\\fancyhead[LE]{}"
        print "\\fancyfoot[CO,CE]{}"

        print "\\frontmatter"
        print "\\title{ODS Markup: \\"
        print "Tagsets by Example}"
        print "\\renewcommand{\\today}{September 22, 2003}"
        print "\pagenumbering{roman}"
        print "\\maketitle"
        print "  \section*{Preface}"
        print "\include{preface}"
        print "\cleardoublepage"
        print "\tableofcontents"
        print "\cleardoublepage"
        print "\\mainmatter"
        print "\cleardoublepage"
        print "\pagenumbering{arabic}"
        print "\setlength{\headrulewidth}{1pt}"
        print "\lhead[\rm\thepage]{\sl\rightmark}"
        print "\rhead[\sl\leftmark]{\rm\thepage}"

        print '\part{Introduction}'
        self.readfile('introduction.tex')
        self.readfile('chapter1.tex')
        self.readfile('chapter2.tex')
        self.readfile('chapter3.tex')
        self.readfile('chapter6.tex')
        self.readfile('chapter7a.tex')

        print '\part{Technicalities}'
        self.readfile('chapter6a.tex')
        self.readfile('chapter4.tex')
        self.readfile('chapter5.tex')
        self.readfile('chapter5a.tex')
        self.readfile('chapter4a.tex')

        print '\part{Intermediate Examples}'
        self.readfile('chapter7.tex')
        self.readfile('chapter8.tex')
        self.readfile('chapter9.tex')

        print '\part{Advanced Examples}'
        self.readfile('chapter10.tex')
        self.readfile('chapter11.tex')
        self.readfile('chapter12.tex')

        print "\part{Usage Notes and Caveat's}"
        self.readfile('chapter13.tex')
        self.readfile('chapter14.tex')
        self.readfile('chapter15.tex')
        self.readfile('chapter16.tex')
        self.readfile('chapter17.tex')

        print "\\backmatter"
        print "\part{Appendices}"
        print "\appendix"
        print "\begin{appendix}"
        print self.readfile('appendix1.tex')
        print self.readfile('appendix3.tex')
        print self.readfile('appendix2.tex')
        print "\end{appendix}"
        print "\end{document}"


    def readfile(self, filename):
        file = open(filename)
 
        for line in file.readlines():
            newline = self.filter(line)
            if strip(newline):
               print "%s" % newline[0:-1];

       
    def filter(self, line):
        if len(strip(line)) == 0:
           self.read_par = None
           return ''

        if find(line, "\\begin") != -1:
           self.read_par = None
           return ''

        if find(line, "\index") != -1:
           return ''

        if self.read_par == 1:
           if len(strip(line)):
              return line;

        if find(line, "\chapter") != -1:
            self.read_par = 1
            return line;

        if find(line, "\section") != -1:
            self.read_par = 1
            self.read_par = None
            return line + '\n'

        if find(line, "\subsection") != -1:
            self.read_par = None
            return line + '\n'
            #return ''

        return ''

if __name__ == "__main__":
   Outline()
