Title '!!!!!!!!! My New Title !!!!!!!!!';
Footnote '######## My New Footnote ########';
ods tagsets.short_map file='map.xml';
proc print data=sashelp.class; run;
ods tagsets.short_map close;
