
%inc "ages.tpl";

title;

%let do_nobs_label=true;
%let modify_by=16:The Oldest|11:The Youngest;
%let by_label=Age is;

ods tagsets.mod_by_line
    file="ages4.html" (title='Class List')
    style=minimal_striped;

proc sort data=sashelp.class out=myclasssrt;
  by age name sex height weight;
run;

*options obs=6;

proc print data=work.myclasssrt noobs;
    by age;
    pageby age;
run;

ods tagsets.mod_by_line close;


