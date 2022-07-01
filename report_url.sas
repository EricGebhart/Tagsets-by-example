data x; x=1; x2=1; x3=1; x4=1; run;

ods tagsets.event_map file="report_url.xml";
ods html file="report_url.html";

proc report data=x nowd;
  column x x2 x3 x4;
  define x / display;
  define x2 / display;

  compute x2;
    call define( _COL_, "URL", "URL-from-REPORT" );
    endcomp;

  run;

  proc print data=x;
    var x;
    var x2 / style(data) = [url="URL-from-Print"];
    var x3;
    var x4;
  run;

ods _all_ close;
  
