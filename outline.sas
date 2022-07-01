proc template;
    define tagset tagsets.leaf;
       parent = tagsets.short_map;
       image_formats = "gif,jpeg";
           
       define event data; end;
       define event row; end;
       define event table_body; end;
       define event table_head; end;
       define event cell_is_empty; end;
       define event rowspec; end;
       define event colgroup; end;
       define event colspecs; end;
       define event colspec_entry; end;
       define event colspecsep; end;
       define event header_spec; end;
       define event span_header_colspec; end;
       define event span_group; end;
       define event row_group; end;
       define event sub_rowheader_colspec; end;
       define event row_header_spec; end;
       define event col_header_label; end;
       define event cellspec; end;
       define event cellspecsep; end;
       define event doc_head; end;
       define event doc_meta; end;   
       define event auth_oper; end;   
       define event doc_title; end;
       define event stylesheet_link; end;
       define event code_link; end;
       define event javascript; end;
       define event startup_function; end;
       define event shutdown_function; end;
       define event table_headers; end;
       define event col_header_spec; end;
       define event sub_header_colspec; end;
       define event sub_colspec_header; end;
       define event header; end;
       define event cellspecspan; end;
       define event colspanfillsep; end;
       define event colspanfill; end;
       define event rowspancolspanfill; end;
       define event rowspanfill; end;
       define event system_title_setup_group; end;
       define event system_title_setup; end;
       define event system_footer_setup_group; end;
       define event system_footer_setup; end;
       define event title_setup_format_section; end;
       define event title_format_section; end;
       define event page_setup; end;
       define event title_setup_container; end;
       define event title_setup_container_specs; end;
       define event title_setup_container_spec; end;
       define event title_setup_container_row; end;
       define event title_container_row; end;
       define event title_container_specs; end;
       define event title_container_spec; end;
       define event put_value; end;
   end;
run;

   data plants;
      input type $ @;
      do block=1 to 3;
         input stemleng @;
         output;
         end;
      cards;
   clarion  32.7 32.3 31.5
   clinton  32.1 29.7 29.1
   knox     35.7 35.9 33.1
   o'neill  36.0 34.2 31.2
   compost  31.8 28.0 29.2
   wabash   38.2 37.8 31.9
   webster  32.5 31.1 29.7
   ;

   data mileage;
      input mph mpg @@;
      cards;
   20 15.4 30 20.2 40 25.7 50 26.2 50 26.6 50 27.4 55  . 60 24.8
   ;

options ls=100;

ods select  GLM.Data.ClassLevels;
ods select  GLM.Means.type.stemleng.MCLines.Waller.MCLinesInfo;
ods select  GLM.Means.type.stemleng.MCLines.Waller.MCLines;


title 'A system title';
title2 'Another system title';
footnote 'A system Footer';
footnote2 'Another system Footer';

ods tagsets.event_map file="outline2.xml";
ods tagsets.leaf file="outline.xml";

   proc glm order=data data = plants;
      class type block;
      model stemleng=type block / solution;
      means type / waller regwq;

   *-type-order------------clrn-cltn-knox-onel-cpst-wbsh-wstr;
      contrast 'compost vs others'  type -1 -1 -1 -1  6 -1 -1;
      contrast 'river soils vs.non' type -1 -1 -1 -1  0  5 -1,
                                    type -1  4 -1 -1  0  0 -1;
      contrast 'glacial vs drift'   type -1  0  1  1  0  0 -1;
      contrast 'clarion vs webster' type -1  0  0  0  0  0  1;
      contrast 'knox vs oneill'     type  0  0  1 -1  0  0  0;
   run;
    
ods _all_ close;    
