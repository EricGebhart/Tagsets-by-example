options obs=1;
libname mapxml xml 'map.xml'
tagset=tagsets.event_map;
proc copy in=sashelp out=mapxml;
select class;
run;
