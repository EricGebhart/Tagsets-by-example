
proc template;

    define tagset tagsets.striped_latex;
        parent=tagsets.colorlatex;

        define event initialize;
            set $alt_row_style tagset_alias;
            set $alt_row_style 'DataStrong' /if !$alt_row_style;
        end;

        define event table_body;
            start:
                set $row_class 'Data';
            finish:
                unset $row_class;
        end;

        define event row;
            finish:
                put CR '\\\hline' CR;

                do /if cmp(section, 'body');
                    do /if cmp($row_class, 'Data');
                        set $row_class $alt_row_style;
                    else;
                        set $row_class 'Data';
                    done;
                done;
        end;

        define event data;
            start:
                put VALUE /if cmp($sascaption, 'true');
                break /if cmp($sascaption, 'true');
                put ' & ' CR / if !cmp(COLSTART, '1') ;

                /* Print cell formatting including class name and alignment. */
                put '   ';
                put '\multicolumn{';
                put colspan;
                put '1' / if !exists(colspan);
                put '}';
                put '{|S{';
                put $row_class /if !cmp(event_name, 'header');
                put htmlclass  /if cmp(event_name, 'header');
                put '}{';
                put just;
                put '}|}';
                put '{';
                put VALUE;

            finish:
                break /if cmp($sascaption, 'true');
                put '}';
        end;
 
    end;
run;

ods tagsets.striped_latex file='striped.tex' style=stripes alias="DataStriped";
options obs=5;
proc print data=sashelp.class; run;
ods _all_ close;
