proc template;

    /*-----------------------------------------------------------eric-*/
    /*-- Define a minimalistic style that will stripe it's          --*/
    /*-- table rows.  This is specifically to work with the         --*/
    /*-- striped html tagset.  Any style can be modified to         --*/
    /*-- work with that tagset just by adding light and             --*/
    /*-- dark style elements.                                       --*/
    /*--------------------------------------------------------7Aug 03-*/
    define Style styles.minimal_striped; 
        parent = styles.minimal;

        style header/
            font = (, 4,bold)
        ;

        style Data/
            font = (, 3,normal)
        ;

        style DataStripe from data /
            background=cxD5E5D2
        ;

        replace Output /
            BorderWidth = 0
            CellSpacing = 1
            CellPadding = 7
            Frame = void
            Rules = none
        ;

    end;

    /*---------------------------------------------------------------eric-*/
    /*-- 3 tagsets.                                                     --*/
    /*--                                                                --*/
    /*-- The idea is to create reusable code while                      --*/
    /*-- addressing a job specific problem.  The first two tagsets      --*/
    /*-- will work for any number of applications.  The third is        --*/
    /*-- specific to particular problem and sas job.                    --*/
    /*--                                                                --*/
    /*-- 1. striped. - this alternates between light and dark styles    --*/
    /*-- for each data row of a table.  Starting with dark.             --*/
    /*--                                                                --*/
    /*-- If a title is provided on the ods statement, It will appear    --*/
    /*-- on the first page as a heading along with the date and time.   --*/
    /*--                                                                --*/
    /*-- 2. nobs_label - this one inherits from striped and adds a      --*/
    /*-- label above each table indicating how many observations are    --*/
    /*-- in the table.  The event table_nobs_label can be modified      --*/
    /*-- to change the format.  By default the labeling is turned off.  --*/
    /*-- It can be turned on at any time by setting the macro variable  --*/
    /*-- do_nobs_label to true.  %let do_nobs_label true;               --*/
    /*--                                                                --*/
    /*-- 3. defects.  This is a very specialized tagset that modifys    --*/
    /*-- the byline based upon the value of a macro variable.  It also  --*/
    /*-- combines the byline with the nobs label to form one heading    --*/
    /*-- above the table.                                               --*/
    /*------------------------------------------------------------7Aug 03-*/

    define tagset tagsets.striped_html;
        parent=tagsets.html4;
        
        /*-------------------------------------------------------eric-*/
        /*-- Add the date and time to the document title.  Save it  --*/
        /*-- away for later.                                        --*/
        /*----------------------------------------------------7Aug 03-*/
        define event doc_title;
              set $title body_title title '&nbsp;-&nbsp;' date " at " time; 
              putl '<TITLE>' $title '</TITLE>';
        end;

        define event doc_body;
            start:
                put '<body onload="startup()"';
                put ' onunload="shutdown()"';
                put  ' bgproperties="fixed"' / WATERMARK;
                putq " class=" HTMLCLASS;
                putq " background=" BACKGROUNDIMAGE;
                trigger style_inline;
                put ">" nl;
                trigger pre_post;
                put          nl;
                trigger ie_check;

                /*-----------------------------------------------eric-*/
                /*-- This is the part that changed.                 --*/
                /*-- Add in the title if we have one.               --*/
                /*--------------------------------------------7Aug 03-*/
                do /if $title;
                    putl '<h3';
                    trigger align;
                    putl '>' $title '</h3>';
                done;

            finish:
                trigger pre_post;
                put "</body>" nl;
        end;

        define event output;
            finish:
                put "<br>" nl;
        end;

        define event proc;
        end;
        define event colspecs;
        end;
        define event colspec_entry;
        end;
        define event colgroup;
        end;

        /*-------------------------------------------------------eric-*/
        /*-- Set the row class to light.  Set the                   --*/
        /*-- nobs count to 0.  Everything else was                  --*/
        /*-- pasted from our parent.                                --*/
        /*----------------------------------------------------7Aug 03-*/
        define event table;
            start:
                set $rowclass "dark";
                eval $nobs 0;

                put "<div";
                trigger alt_align;
                put ">" CR;
                trigger pre_post;
                put "<table";
                putq " class=" HTMLCLASS;
                trigger style_inline;
                putq " cellspacing=" CELLSPACING;
                putq " cellpadding=" CELLPADDING;
                putq " rules=" LOWCASE(RULES);
                putq " frame=" LOWCASE(FRAME);
                trigger table_summary;       /* 508 */
                put ">" CR;
            finish:
                put "</table>" CR;
                trigger pre_post;
                put "</div>" CR;
        end;

        
        /*-------------------------------------------------------eric-*/
        /*-- Count the data rows.  Swap colors.                     --*/
        /*----------------------------------------------------7Aug 03-*/
        define event row;
            start:
                /*-----------------------------------------------eric-*/
                /*-- Don't count unless we are in the data.         --*/
                /*--------------------------------------------7Aug 03-*/
                putq '<tr>' nl;
                do /if cmp(section, 'body');
                    eval $nobs $nobs+1 ;
                done;
            finish:
                put '</tr>' nl;
                /*-----------------------------------------------eric-*/
                /*-- Swap the row style at the end of the row.      --*/
                /*-- That way the first row is the one we set in    --*/
                /*-- table start.                                   --*/
                /*--------------------------------------------7Aug 03-*/
                trigger swapclass; 
        end;

        /*-------------------------------------------------------eric-*/
        /*-- We need a different class attribute that uses our      --*/
        /*-- rowclass variable instead of the usual htmlclass.      --*/
        /*-- So, a new data event and an entirely new - mostly      --*/
        /*-- paste - data_class_align.                              --*/
        /*----------------------------------------------------7Aug 03-*/
        define event data;
            start:
                /* this would work but sometimes htmlclass is empty... */
                trigger header /breakif cmp(htmlclass, "RowHeader");
                trigger header /breakif cmp(htmlclass, "Header");

                put "<td";
                putq " title=" flyover;
                do /if !cmp(htmlclass,'batch');
                    /* changed this line from the parent.  */
                    trigger data_class_align;
                    trigger style_inline;
                done;
                trigger rowcol;
                put " nowrap" /if no_wrap;
                put ">";
                trigger cell_value;
            finish:
                trigger header /breakif cmp(htmlclass, "RowHeader");
                trigger header /breakif cmp(htmlclass, "Header");
   
                trigger cell_value;
                put "</td>" CR;
        end;

        define event data_class_align;
            unset $vjust;
            unset $just;
            set $vjust vjust / when !cmp("t", vjust);
            set $just just / when !cmp("l", just);
            set $just "r" /when cmp("d", $just);
            put ' class="';
            put $just ' ' $vjust;
            put ' ' $rowclass;
            put '"';
        end;

        /*-------------------------------------------------------eric-*/
        /*-- alternate the style class for each row.                --*/
        /*----------------------------------------------------7Aug 03-*/
        define event swapclass;
            do /if cmp($rowclass, "dark"); 
                set $rowclass "light"; 
            else;
                set $rowclass "dark";
            done;
        end;


    end;  


    /*-----------------------------------------------------------eric-*/
    /*-- This tagset adds an observation count to the top           --*/
    /*-- of the label.  It does this by redirecting the             --*/
    /*-- table to an itemstore stream while it counts.              --*/
    /*-- Then it prints the label and then the stream.              --*/
    /*--------------------------------------------------------7Aug 03-*/
    define tagset tagsets.nobs_label;
        parent=tagsets.striped_html;
        mvar do_nobs_label;

        define event table ;
            start:
                set $rowclass "dark";
                eval $nobs 0;
                
                /*-----------------------------------------------eric-*/
                /*-- if we aren't going to print the nobs label     --*/
                /*-- then there's no point in doing extra work.     --*/
                /*--------------------------------------------7Aug 03-*/
                set $do_nobs do_nobs_label;
                open table /if cmp($do_nobs, 'true');
                
                put "<div";
                trigger alt_align;
                put ">" CR;
                put '<table>' nl;
            finish:
                put '</table>' nl;
                put "</div>" nl;
                
                /*-----------------------------------------------eric-*/
                /*-- if we aren't going to print the nobs label     --*/
                /*-- then there's no point in doing extra work.     --*/
                /*--------------------------------------------7Aug 03-*/
                do /if cmp($do_nobs, 'true');
                    close;
                    /* print the nobs */
                    trigger table_nobs_label; 

                    /* print the table */
                    put $$table;
                    unset $$table;
                done;
        end;
        

        /*-------------------------------------------------------eric-*/
        /*-- Print a small heading above the table.                 --*/
        /*-- (## entries)                                           --*/
        /*----------------------------------------------------7Aug 03-*/
        define event table_nobs_label;
            put '<p><h4>(' $nobs ' ';
            do /if $nobs = 1; 
                put 'entry)' ;
            else;
                put 'entries)' ;
            done;
            put '</h4></p>';
        end;
        
    end;
    
    /*-----------------------------------------------------------eric-*/
    /*-- Most of the work is already done by the other tagsets.     --*/
    /*-- This one just needs to combine the byline and the nobs     --*/
    /*-- label into one heading.                                    --*/
    /*--------------------------------------------------------7Aug 03-*/
    define tagset tagsets.defects;
        parent=tagsets.nobs_label;
        mvar numfuture;
        
        /*-------------------------------------------------------eric-*/
        /*-- Add some extra comments to the doc event.              --*/
        /*----------------------------------------------------8Aug 03-*/
        define event initialize;
                set $numfuture numfuture;
                eval $numfuture inputn($numfuture, '7.');
        end;
        

        /*-------------------------------------------------------eric-*/
        /*-- We want to say two different things depending on the   --*/
        /*-- value in the byline.                                   --*/
        /*----------------------------------------------------7Aug 03-*/
        define event byline;
            /*-------------------------------------------------------------eric-*/
            /*-- Convert numfuture to a numeric.                              --*/
            /*----------------------------------------------------------7Aug 03-*/
            eval $version inputn(scan(value, -1, '='), '7.');
        
            put '<p><div style="text-align: center; font-weight: bold; font-size: x-large;">';

            do /if $version >= $numfuture ;
                put 'Future / SASWARE Ballot';
            else;
                put 'Version ' $version ;
            done;
            
            /*---------------------------------------------------eric-*/
            /*-- A newline would do, but one way or another we need --*/
            /*-- to flush.  Otherwise the timing goes sour.         --*/
            /*------------------------------------------------8Aug 03-*/
            flush;
            set $byline "true";
            /*put '</h3> ' nl;*/
        end;
        

        /*-------------------------------------------------------eric-*/
        /*-- The nobs title finishes up the paragraph started with  --*/
        /*-- the byline.                                            --*/
        /*----------------------------------------------------7Aug 03-*/
        define event table_nobs_label;

            /*---------------------------------------------------eric-*/
            /*-- If we didn't get a byline then we want to make     --*/
            /*-- sure the html is still well formed.                --*/
            /*------------------------------------------------8Aug 03-*/
            put '<p><div style="text-align: center; font-weight: bold;">' /if ^$byline;
            unset $byline;

            put '&nbsp;&nbsp;<span style="font-size: medium">(' $nobs ' ';

            do /if $nobs = 1; 
                put 'entry)' ;
            else;
                put 'entries)' ;
            done;

            put '</span></div></p>' nl;
        end;

    end;

run;
