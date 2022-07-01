 /*----------------------------------------------------------
  *
  *                 SAS  TEST  LIBRARY
  *
  *  NAME    :  OSRTAB01
  *  TITLE   :  Tests tabulate problems with ods sasreport
  *          :
  *  INPUT   :
  *  OUTPUT  :
  *  SPECIAL :
  *  REQUIREMENTS :
  *---------------------------------------------------------*/
title1 'OSRTAB01: tabulate defects with sasreport';


 /**************************************************************

  BUG/F:  S0360055   H   DNT  9.2
  BUG/F:  Fixed/9.2
  BUG/F:  EMPTY COLUMNS GIVEN IN TABULATE TABLE
  BUG/F:

  *************************************************************/


  /*-- Create sasreport and html output --*/
  /*--------------------------------------*/
%filename (a, srtab01a, xml);
%filename (b, srtab01b, htm);


ods sasreport file=a style=seaside;
ods html file=b style=seaside;


footnote1 "Numerators are red.";
footnote2 "Column totals are yellow.";
footnote3 "Row totals are blue.";

data fundrais;
   length name $ 8 classrm $ 1;
   input @1 team $ @6 grade @8 classrm $ @10 name $
      @19 pencils @23 tablets;
   totsale=pencils + tablets;
   cards;
BLUE 4 A ANN       4   8
RED  4 A MARY      5  10
BLUE 4 A JOHN      6   4
RED  4 A BOB       2   3
BLUE 4 B FRED      6   8
RED  4 B LOUISE   12   2
BLUE 4 B ANNETTE   .   9
RED  4 B HENRY     8  10
BLUE 4 C KATHY     4   7
BLUE 4 C JIM       3   9
RED  4 C STEVE    13   7
BLUE 5 A ANDREW    3   5
RED  5 A SAMUEL   12  10
BLUE 5 A LINDA     7  12
RED  5 A SARA      4   .
BLUE 5 B MARTIN    9  13
RED  5 B MATTHEW   7   6
BLUE 5 B BETH     15  10
RED  5 B LAURA     4   3
;


options ls=132;

title2 "Calculating Various Percentages with TABULATE - values were missing";
proc tabulate format=4.;
  class team grade classrm;
  var pencils totsale;
  table team all, (grade all)*totsale,
        (classrm all)*(sum
                 colpctsum*f=6.
                 rowpctsum*f=6.
                 reppctsum*f=6.
                 pagepctsum*f=6.)
        all / condense;
run;

ods sasreport close;
ods html close;


footnote;


 /**************************************************************

  BUG/F:  S0359369   H   DNT  9.2
  BUG/F:  Fixed/9.2
  BUG/F:  LABEL STYLE MISSING
  BUG/F:

  *************************************************************/

  /*-- Create sasreport and html output --*/
  /*--------------------------------------*/
%filename (c, srtab01c, xml);
%filename (d, srtab01d, htm);


ods sasreport file=c;
ods html file=d;


data sales;
   input sale_rep $8. +1 dept $8. +1 price 7.2;
   cards;
Agile    Camping    26.27
Agile    Tennis     10.17
Agile    Tennis         .
Agile    Hunting     7.37
Agile    Hunting     0.75
Agile    Camping    38.68
Agile    Tennis     20.57
Agile    Hunting     5.57
Agile    Tennis     15.69
Burley   Camping    12.02
Burley   Tennis      5.70
Burley              27.53
Burley   Camping     9.24
Clever   Camping    11.04
Clever   Tennis     30.54
Clever   Tennis     40.19
Clever   Camping     9.07
;

PROC FORMAT;
  value $dept 'Camping'='C' 'Hunting'='H' 'Fishing'='F';
  RUN;

title2 'STYLE= ATTRIBUTE for BOX option on TABLE statement';
title3 'style=[font_style=italic background=pink]';
PROC TABULATE data=sales ;
  class dept sale_rep;
  format dept $dept.;
  var price;
  table dept*price , sale_rep*sum / box=[label='Departmental Numbers'
     style=[font_style=italic background=pink]];
  run;


title2 'STYLE= ATTRIBUTE for BOX option on TABLE statement';
title3 'style=[font_style=slant background=yellow]';
PROC TABULATE data=sales ;
  class dept sale_rep;
  format dept $dept.;
  var price;
  table dept, price, sale_rep*sum / box=[label=_page_
     style=[font_style=slant  background=yellow]];
  run;


title2 'STYLE= ATTRIBUTE for BOX option on TABLE statement';
title3 'style=[font_style=italic background=pink font_size=8]';
PROC TABULATE data=sales ;
  class dept sale_rep;
  format dept $dept.;
  var price;
  table dept*price , sale_rep*sum / box=[label=sale_rep
     style=[font_style=italic background=pink font_size=8]];
  run;

ods sasreport close;
ods html close;


  /*------------------------------------------------------
   *
   *               SAS  TEST  LIBRARY  TRAILER
   *
   *    SYSTEMS:  ALL
   *    PRODUCT:  sas
   *       KEYS:
   *        REF:
   *   COMMENTS:
   *    SUPPORT:  SASNCL
   *    CHANGES:  24may06.ncl.  Created for s0360055, s0359369
   *-----------------------------------------------------*/
