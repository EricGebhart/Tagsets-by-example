/*----------------------------------------------------------------*/
/*-- Reading a file in using datastep functions.  This example  --*/
/*-- comes straight out of the online documentation             --*/
/*-- for fread().                                               --*/
/*----------------------------------------------------------------*/
proc template;
    define tagset tagsets.readfile;
        parent=tagsets.html4;
        embedded_stylesheet=no;

        mvar infile;


        /*-------------------------------------------------------------eric-*/
        /*-- The files should be given as a list with spaces between them.--*/
        /*----------------------------------------------------------8Nov 03-*/
        define event initialize;
            set $filename 'Default.txt';

            set $filrf "myfile";
            trigger readfile;
        end;

        define event readfile;
            
            /*--------------------------------------------------------*/
            /*-- Set up the file and open it.                       --*/
            /*--------------------------------------------------------*/
            putlog "Reading in file: " $filename;

            eval $fid 0;

            eval $rc filename($filrf, $filename);
            putlog "Filename Return Code" ":" $rc;
            
            eval $fid fopen($filrf);

            do /if missing($fid);
                putlog "Error: File Not Found, " $filename;
                break;
            done;
                
            putlog "File ID" ":" $fid;

            /*--------------------------------------------------------*/
            /*-- datastep functions  will bind directly to the      --*/
            /*-- variable space as it exists.                       --*/
            /*--                                                    --*/
            /*-- Tagset variables are not like datastep             --*/
            /*-- variables but we can create a big one full         --*/
            /*-- of spaces and let the functions write to it.       --*/
            /*--                                                    --*/
            /*-- This creates a variable that is 200 spaces so      --*/
            /*-- that the function can write directly to the        --*/
            /*-- memory location held by the variable.              --*/
            /*-- in VI, 200i<space>                                 --*/
            /*--------------------------------------------------------*/
            set $file_record  "                                                                                                                                                                                                        ";

            /*--------------------------------------------------------*/
            /*-- Loop over the records in the file                  --*/
            /*--------------------------------------------------------*/
            do /if $fid > 0 ;

                do /while fread($fid) = 0;

                    set $rc fget($fid,$file_record ,200);
                    putlog "FGet rc" ":" $rc;

                    putlog "Record:" trimn($file_record);
                done;
            done;

           /*----------------------------------------------------------*/
           /*-- close up the file.  set works fine for this.         --*/
           /*----------------------------------------------------------*/

            set $rc fclose($fid);
            putlog "close rc" ":" $rc;
            set $rc filename($filrf);
            putlog "filename rc" ":" $rc;

        end;
    end;
run;


ods tagsets.readfile file="file.txt";
ods tagsets.readfile close;


