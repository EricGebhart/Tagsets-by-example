
proc template;

    define tagset tagsets.showstyle;

        define event table;
            putvars style _name_ ' : ' _value_ nl;
        end;

     end;
run;

ods tagsets.showstyle file='style.txt';
proc print data=sashelp.class; run;
ods tagsets.showstyle close;

