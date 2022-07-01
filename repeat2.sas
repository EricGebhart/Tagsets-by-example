proc template;

    define tagset tagsets.repeat;
        parent=tagsets.html4;

        mvar header_interval;

        define event set_interval;
    
            eval $data_row_count 1;

            do /if header_interval;
                eval $header_interval inputn(header_interval, "3.");
            else;
                eval $header_interval 0;
            done;

        end;

        define event table_head;
            start:
                put '<thead>';

                trigger set_interval;

                open headers;

            finish:

                close;

                put $$headers;

                do /if !$header_interval;
                    unset $$headers;
                done;
                    

                put '</thead>';
        end;
                
        define event row;
            start:

                open data_row /if cmp(section, 'body');
            
                put '<tr>' nl;

            finish:
                put '</tr>' nl;

                close /if cmp(section, 'body');
              
                do /if cmp(section, 'body');
                    do /if $data_row_count > $header_interval;
                        do /if cmp($first_column, "1");
                            put $$headers;
                            eval $data_row_count 0;
                        done;
                    done;
                    eval $data_row_count $data_row_count+1;
                    unset $first_column;
                done;
                
                put $$data_row;
                unset $$data_row;
        end;

        define event header;
            start:
                set $first_column colstart /if !$first_column;

                put "<th";
                putq " title=" flyover;
                trigger classheadalign;
                trigger style_inline;
                trigger rowcol;
                put ">";
                trigger cell_value;
            finish:
                trigger cell_value;
                put "</th>" CR;
        end;

        define event data;
            start:
                /* this would work but sometimes htmlclass is empty... */
                trigger header /breakif cmp(htmlclass, "RowHeader");
                trigger header /breakif cmp(htmlclass, "Header");

                set $first_column colstart /if !$first_column;
 
                put "<td";
                putq " title=" flyover;
                do /if !cmp(htmlclass,'batch');
                    trigger classalign;
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
    end;
run;

%let header_interval=10;
*options obs=10;
ods tagsets.repeat file='repeat2.html';
proc tabulate missing data=sashelp.revhub2;                                                               
   class type;                                                                                            
   class hub source;                                                                                      
   var revenue;                                                                                           
   table hub*source, type*(revenue="Average Revenue"*(mean*f=10.0))                                       
      / rts=40;                                                                                           
   keylabel mean=' ';                                                                                     
run;     
ods _all_ close;
