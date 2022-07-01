proc template;
    
    define tagset tagsets.colorlatex; 
        parent=tagsets.latex;

        define event stylesheet_link;
            put CR '\usepackage[color]{';
            put scan(URL, 1, '.');
            put '}' CR CR;
        end;

    end;
run

*ods tagsets.colorlatex file="test.tex" stylesheet="test.sty";
ods tagsets.colorlatex file="test.tex" stylesheet="test.sty"(url="test");

ods _all_ close;
