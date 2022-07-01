proc template;

   define tagset tagsets.triggers;
       indent = 4;

       define event doc; 
          start:
              trigger do_stuff;
              trigger do_stuff start;
              trigger inbetween;
              trigger do_stuff finish;
          finish:
              trigger do_stuff start;
              trigger inbetween;
              trigger do_stuff finish;
              trigger do_stuff;
       end;

       define event do_stuff;
           start:
               put state ': ' trigger_name nl;
               ndent;
               trigger more_stuff;
           finish:
               trigger more_stuff;
               xdent;
               put state ': ' trigger_name nl;
       end;

       define event more_stuff;
           start:
               put state ': ' trigger_name nl;
       end;

       define event inbetween;
           put state ': ' trigger_name nl;
       end;

   end;
run;

ods tagsets.triggers file='test.txt';
ods tagsets.triggers close;

