 proc template;

     Define tagset tagsets.plain_text;

         Define event data;
             put 'Data: ' value nl;
         end;

         Define event header;
             put 'Header: ' value nl;
         end;

     end; 

 run;

     
 ods latex file='test.tex' stylesheet="test.sty" (url="test");
 ods tagsets.plain_text file='test.txt';
 option obs=3;
 proc print data=sashelp.class; run;
 ods tagsets.plain_text close;
 ods latex close;
