
%inc "ages.tpl";

title;

%let do_nobs_label=true;

ods tagsets.nobs_label 
    file="ages2.html" (title='Class List')
    style=minimal_striped;

proc sort data=sashelp.class out=myclasssrt;
  by age name sex height weight;
run;

*options obs=6;

proc print data=work.myclasssrt noobs;
    by age;
    pageby age;
run;

ods tagsets.table_nobs close;


