
%inc "ages.tpl";

title;

%let do_nobs_label=true;
%let modify_by=16;

ods tagsets.short_map file="map.xml";

ods tagsets.by_age
    file="ages3.html" (title='Class List')
    style=minimal_striped;

proc sort data=sashelp.class out=myclasssrt;
  by age name sex height weight;
run;

*options obs=6;

proc print data=work.myclasssrt noobs;
    by age;
    pageby age;
run;

ods tagsets.by_age close;
ods tagsets.short_map close;


