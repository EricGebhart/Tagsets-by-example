filename webout 'ages.html';

%let numfuture=16;

proc sort data=sashelp.class out=myclasssrt;
  by age name weight;
run;

/* Count number of items in each BY group */
data cnt_by_obs;
   keep cnt;

   set work.myclasssrt;
   by age;

   if first.age then curcnt = 0;
   curcnt + 1;
   if last.age then do; cnt = curcnt; output; end;
run;

options missing='-';
data _null_;
   file webout;
   if _N_ = 1 then do;
      length title $ 128;
      length stoday stime $ 8;
      retain linecnt 1;

      stoday = put( today(), date7. );
      stime = put( time(), time5. ); 
      title = 'Class List &nbsp;-&nbsp; ' || stoday || "at " || stime;
      put '<!DOCTYPE HTML PUBLIC "-//IETF//DTD HTML//EN">';
      put '<HTML><HEAD>';
      put '<TITLE>' title '</TITLE>';
      put '</HEAD><BODY>';
      put '<CENTER><H3>' title '</H3></CENTER>';
   end;

   set work.myclasssrt;
   by age;

   if _N_ = 1 or FIRST.age then do;
      length lab $ 32;
      set work.cnt_by_obs;
      if age >= &numfuture then do;
         put '<CENTER><B><FONT SIZE=+2>The Oldest</FONT> ' @;
         put '<FONT SIZE=-1>(' cnt +(-1) ' '@;
         if cnt = 1 then
            put 'entry)' @;
         else
            put 'entries)' @;
         put '</FONT></B></CENTER>';
      end;
      else do;
         put '<CENTER><B><FONT SIZE=+2>Age is ' age '</FONT> ' @;
         put '<FONT SIZE=-1>(' cnt +(-1) ' '@;
         if cnt = 1 then
            put 'entry)' @;
         else
            put 'entries)' @;
         put '</FONT></B></CENTER>';
      end;
      put '<TABLE ALIGN=CENTER VALIGN=MIDDLE>';
      put '<TR>';
      lab = vlabel(Name);         put '<TH>' lab '</TH>';
      lab = vlabel(Weight);       put '<TH>' lab '</TH>';
      lab = vlabel(Height);       put '<TH>' lab '</TH>';
      lab = vlabel(Sex);          put '<TH>' lab '</TH>';
      put '</TR>';
   end;

   if mod(linecnt,2) then
      put '<TR ALIGN=CENTER VALIGN=MIDDLE BGCOLOR="D5E5D2">';
   else
      put '<TR ALIGN=CENTER VALIGN=MIDDLE>';

   put '<TD ALIGN=CENTER>' name '</TD>';
   put '<TD><FONT SIZE=-1>' weight '</FONT></TD>';
   put '<TD><FONT SIZE=-1>' height '</FONT></TD>';
   put '<TD><FONT SIZE=-1>' sex '</FONT></TD>';
   put '</TR>';

   linecnt + 1;

   if LAST.age then do;
      put '</TABLE>';
      linecnt = 1;
      put '<BR><HR><BR>';
      put '</BODY></HTML>';
   end;
run;
