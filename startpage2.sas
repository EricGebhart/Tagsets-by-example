proc template;
    define tagset tagsets.startpage2;
        parent=tagsets.startpage;
        
        define event doc_body;
            start:
                put '<body onload="startup()"';
                put ' onunload="shutdown()"';
                put  ' bgproperties="fixed"' / WATERMARK;
                putq " class=" HTMLCLASS;
                putq " background=" BACKGROUNDIMAGE;
                trigger style_inline;
                put ">" CR;
                trigger pre_post;
                put          CR;
                trigger ie_check;

            finish:
                trigger put_footnotes;

                trigger pre_post;
                put "</body>" CR;
        end;
    end;
run;

Title '!!!!!!!!! My New Title !!!!!!!!!';
Footnote '######## My New Footnote ########';

options obs=1;

ods tagsets.startpage2 file='startpage.html' alias='no';
proc print data=sashelp.class;run;
proc print data=sashelp.class;run;
ods _all_ close;
