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

        style DataStrong from data /
            background=cxD5E5D2
        ;

        style nobs_label from data /
            font_size = 3
        ;

        style table_head
        ;

        style byline /
           font_size = 5
           font_weight = bold
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


    /*-----------------------------------------------------------eric-*/
    /*-- This tagset adds an observation count to the top           --*/
    /*-- of the label.  It does this by redirecting the             --*/
    /*-- table to an itemstore stream while it counts.              --*/
    /*-- Then it prints the label and then the stream.              --*/
    /*--------------------------------------------------------7Aug 03-*/
    define tagset tagsets.nobs_label;
        parent=tagsets.stripes;
        mvar do_nobs_label;

        /*-------------------------------------------------------eric-*/
        /*-- Add the date and time to the document title.  Save it  --*/
        /*-- away for later.                                        --*/
        /*----------------------------------------------------7Aug 03-*/
        define event doc_title;
              break /if ^value;
              set $title value '&nbsp;-&nbsp;' date " at " time; 
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
        define event table ;
            start:
                eval $nobs 0;
                
                /*-----------------------------------------------eric-*/
                /*-- if we aren't going to print the nobs label     --*/
                /*-- then there's no point in doing extra work.     --*/
                /*--------------------------------------------7Aug 03-*/
                set $do_nobs do_nobs_label;
                open table /if cmp($do_nobs, 'true');
                set $row_class 'data';
                
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
                trigger swapclass /if cmp(section, 'body');
        end;
        

        /*-------------------------------------------------------eric-*/
        /*-- Print a small heading above the table.                 --*/
        /*-- (## entries)                                           --*/
        /*----------------------------------------------------7Aug 03-*/
        define event table_nobs_label;
            style=nobs_label;
            put '<p><h4';
            putq ' class=' htmlclass; 
            put ' style="text-align: center">(' $nobs ' ';
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
    define tagset tagsets.by_age;
        parent=tagsets.nobs_label;
        mvar modify_by;
        
        /*-------------------------------------------------------eric-*/
        /*-- Add some extra comments to the doc event.              --*/
        /*----------------------------------------------------8Aug 03-*/
        define event initialize;
            eval $modify_by inputn(modify_by, '7.');
            do /if missing($modify_by);
                eval $modify_by 0;
            done;
            /*---------------------------------------------------eric-*/
            /*-- From the stripes tagset.                           --*/
            /*------------------------------------------------9Nov 03-*/
            set $alt_row_style tagset_alias;
            set $alt_row_style 'DataStrong' /if !$alt_row_style;
        end;
        

        /*-------------------------------------------------------eric-*/
        /*-- We want to say two different things depending on the   --*/
        /*-- value in the byline.                                   --*/
        /*----------------------------------------------------7Aug 03-*/
        define event byline;
            /*---------------------------------------------------eric-*/
            /*-- Convert age to a numeric.                          --*/
            /*------------------------------------------------7Aug 03-*/
            eval $byval inputn(scan(value, -1, '='), '7.');
        
            put '<p><div';
            putq ' class=' htmlclass ;
            put ' style="text-align: center;">' nl;

            do /if $byval = $modify_by ;
                put 'The Oldest';
            else;
                put 'Age is ' $byval ;
            done;
            
            /*---------------------------------------------------eric-*/
            /*-- A newline would do, but one way or another we need --*/
            /*-- to flush.  Otherwise the timing goes sour.         --*/
            /*------------------------------------------------8Aug 03-*/
            flush;
            set $byline "true";
        end;
        

        /*-------------------------------------------------------eric-*/
        /*-- The nobs title finishes up the paragraph started with  --*/
        /*-- the byline.                                            --*/
        /*----------------------------------------------------7Aug 03-*/
        define event table_nobs_label;
            style=nobs_label;

            /*---------------------------------------------------eric-*/
            /*-- If we didn't get a byline then we want to make     --*/
            /*-- sure the html is still well formed.                --*/
            /*------------------------------------------------8Aug 03-*/
            do /if ^$byline;
                put '<p><div';
                putq ' class=' htmlclass;
                put ' style="text-align: center>' nl;
                unset $byline;
            done;

            put '&nbsp;&nbsp;<span class="' htmlclass '">(' $nobs ' ';

            do /if $nobs = 1; 
                put 'entry)' ;
            else;
                put 'entries)' ;
            done;

            put '</span></div></p>' nl;
        end;

    end;


    define tagset tagsets.mod_by_line;
        parent=tagsets.nobs_label;
        mvar modify_by;
        mvar by_label;
        
        define event bygroup;
            start:
                /*-----------------------------------------------eric-*/
                /*-- Don't do this if there is no need.             --*/
                /*--------------------------------------------9Nov 03-*/
                break /if ^modify_by;

                break /if cmp($modify_by, modify_by);
                
                unset $byval_subs;
                set $modify_by modify_by;
                
                eval $count 1;
                trigger set_byval_pair;

                do /while !cmp($byval_pair, ' ');

                    set $byval_subs[$byval] $substitution;

                    eval $count $count+1;

                    trigger set_byval_pair;
                done;

        end;

        define event set_byval_pair;     
            set $byval_pair scan($modify_by, $count, '|');
            set $byval scan($byval_pair, 1, ':');
            set $substitution scan($byval_pair, 2, ':');
        end;   
        

        define event byline;
            /*---------------------------------------------------eric-*/
            /*-- Get the by value in string form                    --*/
            /*------------------------------------------------7Aug 03-*/
            eval $byval trim(scan(value, -1, '='));
            
            put '<p><div';
            putq ' class=' htmlclass ;
            put ' style="text-align: center;">' nl;

            do /if $byval_subs[$byval];
                put $byval_subs[$byval];
            else;
                do /if by_label;
                    put by_label $byval;
                else;
                    put value;
                done;
            done;
            
            /*---------------------------------------------------eric-*/
            /*-- A newline would do, but one way or another we need --*/
            /*-- to flush.  Otherwise the timing goes sour.         --*/
            /*------------------------------------------------8Aug 03-*/
            flush;
            set $byline "true";
        end;
        

        define event table_nobs_label;
            style=nobs_label;

            /*---------------------------------------------------eric-*/
            /*-- If we didn't get a byline then we want to make     --*/
            /*-- sure the html is still well formed.                --*/
            /*------------------------------------------------8Aug 03-*/
            do /if ^$byline;
                put '<p><div';
                putq ' class=' htmlclass;
                put ' style="text-align: center>' nl;
                unset $byline;
            done;

            put '&nbsp;&nbsp;<span class="' htmlclass '">(' $nobs ' ';

            do /if $nobs = 1; 
                put 'entry)' ;
            else;
                put 'entries)' ;
            done;

            put '</span></div></p>' nl;
        end;

    end;

run;
