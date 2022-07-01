
proc template;
    define tagset tagsets.input;   

        mvar some_number;
    
        define event initialize;
           eval $inputn_value  inputn(some_number, '3.')+5;           
           set $set_inputn  inputn(some_number, '3.');           
           eval $input_value  input(some_number, 3.)+1;           
           put ":" putc("hello", '$', 15) ":" nl;
           put ":" put("hello", '$15') ":" nl;
           putvars mem _name_ ":" _value_ nl; 
        end;
    end;
run;

%let some_number=10;

ods tagsets.input file="input.txt";
ods tagsets.inpuc close;

     
 
