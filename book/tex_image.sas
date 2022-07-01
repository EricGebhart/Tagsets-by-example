


 proc template;
    define tagset tagsets.mylatex;
       parent = tagsets.latex;

       image_formats = 'ps,psepsf,png,jpeg,gif';

        define event image;
            put '\sasgraph{';
            put BASENAME / if !exists(NOBASE);

            /* convert gif extension to ps.          */
            /* use eps if you use the psepsf driver. */
            put tranwrd(URL, 'gif', 'ps');

            put '}' CR;
        end;
    end;
 run;          

filename junk ".";

ods listing close;

ods tagsets.mylatex file="graph.tex";
goptions dev=gif target=ps;

proc gchart data=sashelp.class;
vbar age / pattid=midpoint;
run;
quit;

proc gplot data=sashelp.class;
plot height*weight;
run;
quit;

ods _all_ close;
ods listing;

/*------------------------------------------------eric-*/
/*-- Replay the graphs to generate postscript.       --*/
/*---------------------------------------------16Oct03-*/
goptions dev=ps gsfname=junk;
proc greplay nofs;
   igout work.gseg;
   replay _all_;
run;
quit;
