ODS CSV file='test.csv';
ODS CSVAll file='testall.csv';
ODS tagsets.CSVByline file='testby.csv';

options obs=6;

proc sort data=sashelp.class out=sorted;
     by sex;

Proc print data=sorted;
     by sex;
run;

ODS _all_ close;
