
proc template;

    define tagset tagsets.my_map;

        define event table;
            putvars event _name_ ' : ' _value_ nl;
        end;

     end;
run;

ods tagsets.my_map file='putvars.txt';
proc print data=sashelp.class; run;
ods tagsets.my_map close;
