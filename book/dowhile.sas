proc template;
define tagset tagsets.dowhile;
    default_event = 'count';

    define event initialize;
        eval $count 1;

        do /while $count <3;
            put "Count < 3 " $count nl;
            eval $count $count + 1;
        else;
            put "Else from: Count < 3: " $count nl;
        done;

        do /while $count <3;
            put "Second Count < 3:" $count nl;
            eval $count $count + 1;
        else;
            put "Second Else: Count > 3: " $count nl;
        done;
        
    end;
end;
run;

ods tagsets.dowhile file="dowhile.txt";
ods tagsets.dowhile close;
