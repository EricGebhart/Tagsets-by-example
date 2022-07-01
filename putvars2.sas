
proc template;

    define tagset tagsets.my_map;

        indent=2;

        define event table;
            put 'Event: ' event_name nl;
            ndent;

            put 'Event:' nl;
            ndent;
            putvars event _name_ ' : ' _value_ nl;
            xdent;

            put 'Style:' nl;
            ndent;
            putvars style _name_ ' : ' _value_ nl;
            xdent;

            put 'Memory:' nl;
            ndent;
            putvars memory _name_ ' : ' _value_ nl;
            xdent;

            put 'Stream:' nl;
            ndent;
            putvars stream _name_ ' : ' _value_ nl;
            xdent;

            put 'Dynamic:' nl;
            ndent;
            putvars dynamic _name_ ' : ' _value_ nl;
            xdent;

            xdent;
            put nl;
        end;

     end;
run;

ods tagsets.my_map file='putvars.txt';
proc print data=sashelp.class; run;
ods tagsets.my_map close;
