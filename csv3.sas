proc template;

    Define tagset tagsets.SSV2;
        parent=tagsets.ssv;

        mvar csv_delimiter;

        define event initialize;
           set $delimiter tagset_alias;
           set $delimiter csv_delimiter /if !$delimiter;
           set $delimiter ',' /if !$delimiter;
        end;
     end; 
run;

%let csv_delimiter=|;

options obs=3;
ods tagsets.ssv2 file='test.ssv' alias="!";
proc print data=sashelp.class;run;
ods tagsets.ssv2 close;
