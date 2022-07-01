proc template;

    define tagset tagsets.variables;

        /* define event doc;  */
        define event initialize;

            set $test  operator ' ran this job.';           
            set $test2 $test ' On this date: ' date;           
            set $test3 compress($test2, ':.');

            put 'Simple string Variables' nl;
            putvars memory _name_ ': ' _value_ nl;

            set $test[]  operator ' ran this job.';           
            set $test[] $test[1] ' On this date: ' date;           
            set $test[] compress($test[2], ':.');
         
            put nl 'A List' nl;
            putvars $test _name_ ': ' _value_ nl;

            set $test[] 'Entry 1';
            set $test[] 'Entry 2';
            set $test[] 'Entry 3'; 

            set $test[2] 'The New 2';

            put nl 'The same List' nl;
            put 'Test now has a length of ' $test nl;

            putvars $test _name_ ': ' _value_ nl;

            put nl 'Print the last 3 in reverse' nl;
            /* print them in reverse order */
            put $test[-1] nl;
            put $test[-2] nl;
            put $test[-3] nl;

            /* delete the first entry */
            put 'Deleting test[1]' nl;
            unset $test[1];
       
            put 'Test now has a length of ' $test nl;
 
            putvars $test _name_ ': ' _value_ nl;

            /* delete the whole thing */

            unset $test;

            put 'Test has a length of ' $test nl;

            set $test['one']  operator ' ran this job.';           
            set $test['one plus'] $test['one'] ' On this date: ' date;           
            set $test['one sentence'] compress($test['one plus'], ':.') '.';

            put nl 'A Dictionary' nl;
            put 'Test has a length of ' $test nl;

            putvars $test _name_ ': ' _value_ nl;

            put nl 'Print a dictionary entry with a key' nl;
            set $key 'one sentence';
            put $test[$key] nl;

            unset $test;

            eval $count 1;
            eval $count $count+1;
            eval $position index($key, 's');
            eval $string1 substr($key, $position);
            set $string2 substr($key, $position);

            put nl 'Miscellaneous variables' nl;
            putvars memory _name_ ': ' _value_ nl;

            open deferred;
                put 'we will print this later.  Goodbye.' nl;
            close;
            put nl 'This will print now.' nl;
   
            put $$deferred;
   
            unset $$deferred;

        end;
    end;
run;

ods tagsets.variables file='test.txt';
ods tagsets.variables close;
