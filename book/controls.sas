proc template;

    define tagset tagsets.controls;

        define event bif;
            put 'Hello Eric' nl /break_if $is_eric;
            put 'Greetings ' operator nl;
        end;

        define event initialize;
            set $is_elmo 'True' /if cmp(operator, 'elmo');
            set $is_eric 'True' /if cmp(operator, 'eric');
            put 'Hello Eric' nl /if $is_eric;
            put 'Greetings ' operator nl /if ^$is_eric;
            put 'RIC' nl /if contains(operator, 'ric');
            put 'This might be Eric' nl /if any(operator, $is_eric);
            put 'This is Eric' nl /if exists(operator, $is_eric);

            trigger bif;

            do /if $is_eric;
                put 'Go away' nl;

            else /if $is_elmo;
                put "What's up?" nl;

            else;
                put 'Hello ' operator ' How are you?' nl;
            done;


            eval $i 0;

            put nl 'i is ' $i nl;

            put "Going into a Loop to 10" nl;
            put "Continue at 5" nl;
            put "stop at 8" nl;

            do /while $i < 10;

                eval $i $i+1;

                continue /if $i eq 5;
                stop     /if $i eq 8;

                put 'I is ' $i nl;

            else;
                put 'do this if i started out > 10' nl;

            done;

            set $dogs['Ernie'] 'Was a great dog';
            set $dogs['Pola'] 'Was really sweet.';
            set $dogs['Arkas'] 'Is a big dog';
            set $dogs['Luna'] 'Is super sweet';

            put nl 'iterating on a dictionary' nl;
            iterate $dogs;
            do /while _value_;
                put "Key: " _name_ " Value: " _value_ nl;
                next $dogs;
            done;
      
            set $dog_keys[] 'Ernie';
            set $dog_keys[] 'Pola';
            set $dog_keys[] 'Arkas';
            set $dog_keys[] 'Luna';
      
            put nl 'iterating on a list' nl;
            iterate $dog_keys;
            do /while _value_;
                put "Key: " _name_ " Value: " _value_ nl;
                next $dog_keys;
            done;

        end;
    end;
run;

ods tagsets.controls operator='eric' file='test.txt';
ods tagsets.controls close;
      
