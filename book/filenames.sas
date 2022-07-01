proc template;
    define tagset tagsets.filenames;
        define event initialize;
            putvars event _name_ ': ' _value_ nl;
        end;
    end;
run;

ods tagsets.filenames file='body.xml' (url='b.html')
                  contents='contents.xml'(url='c.html') 
                      page='pages.xml' (url='p.html')
                     frame='frame.xml' (url='f.html')
                stylesheet='style.xml' (url='s.html')
                      code='code.xml' (url='cd.html')
                      data='data.xml' (url='d.html');
ods tagsets.filenames close;
