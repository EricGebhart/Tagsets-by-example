proc template;
    define tagset tagsets.verbose_html;
        parent=tagsets.html4;
        embedded_stylesheet=no;
        pure_style=yes;
    end;
run;
ods html file='simple.html';
ods tagsets.verbose_html file='verbose.html';
ods _all_ close;