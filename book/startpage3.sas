proc template;
    define tagset tagsets.startpage3;
        parent=tagsets.startpage2;

        
        define event initialize;
            trigger startpage;
        end;    

        define event startpage;
            /*---------------------------------------------------eric-*/
            /*-- if we got a value check set start page,            --*/
            /*-- if we didn't get a value then set it               --*/
            /*-- to the alias we got on the initial ods             --*/
            /*-- statement.                                         --*/
            /*------------------------------------------------11Aug03-*/
            unset $start_page_no;

            do /if value;
                set $start_page_no 'true' /if cmp(value, 'no');
            else;
                set $start_page_no 'true' /if cmp(tagset_alias, 'no');
            done;

            putlog "STARTPAGE" ":" $start_page_no;
            
            do /if !$start_page_no;
                unset $start_page_no;
                unset $titles_printed;
            done;
        end;
    end;
run;

Title '!!!!!!!!! My New Title !!!!!!!!!';
Footnote '######## My New Footnote ########';

options obs=1;

/* start it off with startpage=no. */
ods tagsets.startpage3 alias="no" file="startpage.html";

proc print data=sashelp.class; run;

proc print data=sashelp.class; run;

ods tagsets.startpage3 event=startpage(text="yes");

proc print data=sashelp.class; run;

proc print data=sashelp.class; run;

/* set it back to the default as defined by alias */
ods tagsets.startpage3 event=startpage;

proc print data=sashelp.class; run;

proc print data=sashelp.class; run;

ods _all_ close;
