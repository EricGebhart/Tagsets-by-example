proc template;

    Define tagset tagsets.SSV;
        parent=tagsets.csv;

        mvar csv_delimiter;

        define event initialize;
           set $delimiter csv_delimiter;
           set $delimiter ',' /if !$delimiter;
        end;

        define event header;
            start:
                put $delimiter / if !cmp(COLSTART, "1");
                put '"';
                put VALUE;
            finish:
                put '"';
        end;

        define event data;
            start:
                put $delimiter / if !cmp(COLSTART, "1");
                put '"';
                put VALUE;
            finish:
                put '"';
        end;

        define event colspanfill;
            put $delimiter;
        end;    

        define event rowspanfill;
            put $delimiter /if ! exists(VALUE);
        end;

     end; 
run;

%let csv_delimiter=|;

options obs=3;
ods tagsets.ssv file='test.ssv';
proc print data=sashelp.class;run;
ods tagsets.ssv close;
