ods listing close;

goptions dev=gif xpixels=480 ypixels=320;


ods tagsets.event_map file="map.xml";

ods tagsets.supermap file="supermap.xml" data="map_gif.ini"
	options( 
             basic_verbosity="some" 
             value_match="/Alfred/" 
             match_any="/gif/" 
             doc="settings"
             debug_level="2"
            );

 proc gplot data=sashelp.class;
     plot height*weight;
     by name;
 run;
 quit;

     
ods _all_ close;
     
