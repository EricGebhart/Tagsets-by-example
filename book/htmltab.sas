
ods chtml file="chtml.html";
ods imode file="imode.html";
ods htmlcss file="htmlcss.html";
ods phtml file="phtml.html";
ods tagsets.MSOffice2K file="msoffice2k.html";
ods html file="html.html";


  title3 height=15pt color=orange
         justify=right '15 pt first right'
         justify=left 'first left';
  title4 height=10pt color=red 'no justify red'
         justify=right 'Second right'
         justify=left 'Second left';



proc sort data=sashelp.class out=work.class;
    by age  sex;
run;

options obs=2;


PROC TABULATE DATA=class;
   VAR Height Weight;
   CLASS Sex Age;
   TABLE Age*Mean ALL*Sex*Mean,
         Weight;
   by age;
   
RUN;

ods _all_ close;
