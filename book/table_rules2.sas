
proc template;

    define style styles.table_rules;

        style table /
          borderwidth=3
          bordercolor=black
          rules=cols
        ;

        style table_head /
          borderbottomstyle=solid
        ;

     end;

    define tagset tagsets.table_rules;
        parent=tagsets.html4;

        define event table_head;
            style=table_head;
            
            start:
                put '<thead';
                putq ' class=' htmlclass;
                put '>' nl;
            finish:
                put '</thead>' nl;
        end;
    end;
run;

ods tagsets.table_rules file='table.html' style=table_rules;
options obs=3;
proc print data=sashelp.class; run;
ods _all_ close;
