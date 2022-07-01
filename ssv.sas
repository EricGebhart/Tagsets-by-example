proc template;
    
    Define tagset tagsets.SSV;

        parent=tagsets.csv;

        define event header;
            start:
                put ';' / if !cmp(COLSTART, "1");
                put '"';
                put VALUE;
            finish:
                put '"';
        end;

        define event data;
            start:
                put ';' / if !cmp(COLSTART, "1");
                put '"';
                put VALUE;
            finish:
                put '"';
        end;

        define event colspanfill;
            put ';';
        end;    

        define event rowspanfill;
            put ';' /if ! exists(VALUE);
        end;

     end; 
run;

options obs=3;
ods tagsets.ssv file='test.ssv';
proc print data=sashelp.class;run;
ods tagsets.ssv close;
