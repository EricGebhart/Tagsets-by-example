
proc template;

    define style styles.showstyle;

        style table /
          Font = ("Verdana, Helvetica, sans-serif", 4, bold)
          Foreground = black
          background = White
          bordercolor = green
          cellspacing = 1
          cellpadding = 3
          rules = groups
          frame = box
        ;

        style darkbox /
          Font = ("Times", 6, bold)
          Foreground = black
          background = White
          bordercolor = Black
          cellspacing = 0
          cellpadding = 1
          rules = none
          frame = box
        ;
    end;

    define tagset tagsets.showstyle;

        indent=4;
        embedded_stylesheet = yes;

        define event style_class;
           trigger put_style;
        end;

        define event table;
           style=darkbox;
           trigger put_style;
        end;

        define event put_style;
            put nl 'Event: ' Event_Name nl;
            ndent;
            putvars style _name_ ' : ' _value_ nl;
            xdent;
        end;

     end;
run;

ods tagsets.showstyle style=showstyle file='style.txt';
proc print data=sashelp.class; run;
ods tagsets.showstyle close;
