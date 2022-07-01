libname mapxml xml 'map.xml'
tagset=tagsets.short_map;
proc copy in=sashelp out=mapxml;
select class;
run;
