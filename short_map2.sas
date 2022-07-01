options obs=1;
ods tagsets.short_map file='test.xml';
proc print data=sashelp.class; run;
ods tagsets.short_map close;
