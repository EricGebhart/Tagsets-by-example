proc template;
    define tagset tagsets.startpage;
        parent=tagsets.html4;
        
        define event initialize;
            set $start_page_no "true" /if cmp(tagset_alias, 'no');
        end;    

        /*-------------------------------------------------------eric-*/
        /*-- All titles happen between this event's start           --*/
        /*-- and finish.  redirect them to a stream or              --*/
        /*-- throw them away.                                       --*/
        /*----------------------------------------------------14Aug03-*/
        define event system_title_group;
            start:
                do /if $start_page_no;
                    do /if $titles_printed;
                        trigger block_title;
                        trigger block_title_container;
                    done;
                    set $titles_printed "true";

                    /*------------------------------------------eric-*/
                    /*-- Block the page breaks after the first     --*/
                    /*-- titles have been printed.  Otherwise we   --*/
                    /*-- don't get a pagebreak when we switch from --*/
                    /*-- start_page=yes to start_page=no.          --*/
                    /*---------------------------------------11Aug03-*/
                    trigger block_page_breaks start;
                done;
            finish:
                trigger block_title;
                trigger block_title_container;
        end;
        
        
        /*-------------------------------------------------------eric-*/
        /*-- All footnotes happen between this event's start        --*/
        /*-- and finish.  redirect them to a stream or              --*/
        /*-- throw them away.                                       --*/
        /*----------------------------------------------------14Aug03-*/
        define event system_footer_group;
            start:
                do /if exists($$footnotes);
                    trigger block_footnote;
                    trigger block_title_container;
                else;
                    open footnotes;
                done;

            finish:
                close;
                unset $footnotes_open;
                trigger block_footnote;
                trigger block_title_container;

                trigger put_footnotes /if ^$start_page_no;
        end;
            

        /*-------------------------------------------------------eric-*/
        /*-- Write out the footnotes we saved earlier.              --*/
        /*----------------------------------------------------14Aug03-*/
        define event put_footnotes;
            put $$footnotes;
            unset $$footnotes;
        end;
        
            
        /*--------------------------------------------------eric-*/
        /*-- Block/unblock the titles or footnotes.            --*/
        /*-----------------------------------------------11Aug03-*/
        define event block_title_container;
            start:
                break /if $title_container_blocked;
 
                unblock title_container;
                unblock title_row;
                set $title_container_blocked "true";
             finish:
                unblock title_container;
                unblock title_row;
                unset $title_container_blocked;
        end;
         

        define event block_title;
            start:
                break /if $title_blocked;
 
                block system_title;
                set $title_blocked "true";
            finish:
                unblock system_title;
                unset $title_blocked;
        end;

 
        define event block_footnote;
            start:
                break /if $footnote_blocked;

                block system_footer;
                set $footnote_blocked "true";
             finish:
                 unblock system_footer;
                 unset $footnote_blocked;
        end;
         

        /*-------------------------------------------------------eric-*/
        /*-- block the page breaks so we don't get them inside the panel.--*/
        /*----------------------------------------------------1Aug 03-*/
        define event block_page_breaks;
            start:
                /*-----------------------------------------------eric-*/
                /*-- Only block it once.  Keep the reference count  --*/
                /*-- to one.                                        --*/
                /*--------------------------------------------14Aug03-*/
                do / if ^exists($page_blocked);
                    set $page_blocked "true";
                    block line;
                    block pagebreak;
                done;                   
            finish:
                unblock line;
                unblock pagebreak;
                unset $page_blocked;
        end;

    end;
run;

Title '!!!!!!!!! My New Title !!!!!!!!!';
Footnote '######## My New Footnote ########';

options obs=1;

ods tagsets.startpage file='startpage.html' alias='no';
proc print data=sashelp.class;run;
proc print data=sashelp.class;run;
ods _all_ close;

