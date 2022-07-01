 proc template;

     Define tagset tagsets.plain_text;

         Define event table;
             start:
                 put '-----------------------------------------' nl;
             finish:
                 put '-----------------------------------------' nl;
         end;

         Define event row;
             finish:
             put nl;
         end;

         Define event data;
             put value '   ';
         end;

         Define event header;
             put value ' ';
         end;


     end; 

 run;

     
 ods latex file='test.tex' stylesheet="test.sty" (url="test");
 ods tagsets.plain_text file='test.txt';
 option obs=1;
 proc print data=sashelp.class; run;
 ods tagsets.plain_text close;
