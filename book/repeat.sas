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
                do /if cmp(section, 'body');
                    do /if $data_row_count > $header_interval;
                        put $$headers;
                        eval $data_row_count 1;
                    else;
                        eval $data_row_count $data_row_count+1;
                    done;
                done;

                put '<tr>' nl;

            finish:
               put '</tr>' nl;
        end;
    end;
run;

%let header_interval=5;
ods tagsets.repeat file='repeat.html';
options obs=10;
proc print data=sashelp.class; run;
ods _all_ close;
