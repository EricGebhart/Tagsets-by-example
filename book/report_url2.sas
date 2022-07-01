proc template;
    define tagset tagsets.targethtml;
    parent=tagsets.html4;
    
    mvar target_column;
    mvar target_value;
    
    /* Web Accessibility Feature 1194.22 (G&H) */
    /*-----------------------------------------*/
     define event data;
         start:
            /* this would work but sometimes htmlclass is empty... */
            trigger header /breakif cmp(htmlclass, "RowHeader");
            trigger header /breakif cmp(htmlclass, "Header");


            /* The only new line here */
            set $column colstart;

            put "<td";
            putq " title=" flyover;
            do /if !cmp(htmlclass,'batch');
              trigger classalign;
              trigger style_inline;
            done;
            trigger rowcol;
            put " nowrap" /if no_wrap;
            put ">";
            trigger cell_value;
         finish:
            trigger header /breakif cmp(htmlclass, "RowHeader");
            trigger header /breakif cmp(htmlclass, "Header");

            trigger cell_value;
            put "</td>" CR;
            unset $column;
            
       end;
    
        define event hyperlink;
          start:
            put '<a href="' URL;
            /*put "#" ANCHOR;*/
            put '"';

            do /if hreftarget;
                putq " target=" HREFTARGET;
            else /if cmp($column, target_column);
                putq " target=" target_value /if target_value;
            done;
            
            put ">";
            trigger do_value;
          finish:
            put "</a>" CR;
        end;
    end;
run;


data x; x=1; x2=1; x3=1; x4=1; run;

%let target_column=2;
%let target_value=_blank_;

ods tagsets.targethtml file="report_url.html";

proc report data=x nowd;
  column x x2 x3 x4;
  define x / display;
  define x2 / display;

  compute x2;
    call define( _COL_, "URL", "URL-from-REPORT" );
    endcomp;

  run;

ods _all_ close;
