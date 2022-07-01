proc template;
   define tagset tagsets.regex;   
 
     define event initialize;
         set $papersize getoption('PAPERSIZE');

         put "Papersize" ":" $papersize nl;

         /* tranwrd just makes the regex easier. Get rid of optional quotes */
         set $papersize tranwrd($papersize, '"', " ");
         set $papersize tranwrd($papersize, "'", " ");

         /* could be centimeters, could be quoted, or not...
            default is supposedly inches but could be installation
            dependent.
            (8in 11in);
            ('8in', '11in');
            ("8in", "11in");
            ("8", "11");
         */

        /*---------------------------------------------------------------eric-*/
        /*-- The compiled regular expression is a unique integer.           --*/
        /*------------------------------------------------------------21Nov03-*/
         eval $re prxparse('( *([0-9]+) *(IN|CM)* *[,]+ *([0-9]+) *(IN|CM)*.*)') ;
         put "RE is " ":" $re nl;

         eval $match prxmatch($re, $papersize);
         put "MATCH is " ":" $match nl;

        /*---------------------------------------------------------------eric-*/
        /*-- Get the width and the width unit                               --*/
        /*------------------------------------------------------------21Nov03-*/
         set $pwidth prxposn($re, 1, $papersize) ;
         set $pwidth_unit prxposn($re, 2, $papersize) ;

         set $pwidth_unit lowcase($pwidth_unit) /if $pwidth_unit;
         set $pwidth_unit "in" /if !$pwidth_unit;

        /*---------------------------------------------------------------eric-*/
        /*-- Get the height and the height unit.                            --*/
        /*------------------------------------------------------------21Nov03-*/
         set $pheight prxposn($re, 3, $papersize) ;
         set $pheight_unit prxposn($re, 4, $papersize) ;

         set $pheight_unit lowcase($pheight_unit) /if $pheight_unit;
         set $pheight_unit "in" /if !$pheight_unit;

         /* Only if they are non-zero */
         put ' height="' $pheight $pheight_unit '"' nl /if $pheight;
         put ' width="' $pwidth $pwidth_unit '"' nl /if $pwidth;

         unset $papersize;
         unset $re;
         unset $pwidth;
         unset $pwidth_unit;
         unset $pheight;
         unset $pheight_unit;
     end;

 end;
run;

options papersize=("5in" , 10cm);

ods tagsets.regex file="regex.txt";
ods tagsets.regex close;
