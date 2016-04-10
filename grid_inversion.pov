/*
POV-RAY scene description file.

"Sphere inversion of a grid" by Florian Brucker

Contact: mail@florianbrucker.de
Web:     http://www.florianbrucker.de/index.php?p=sphereinversions

Released under the GPL, see http://www.gnu.org/copyleft/gpl.html
*/

#version 3.6;

#default { finish { ambient 0 } }
global_settings { assumed_gamma 1 }

#include "morefunctions.inc"
#include "rad_def.inc"

background { rgb 1 }

camera { 
	location vnormalize(<1,1,-2>)*4 
	look_at y*-0.2 
}

global_settings { 
	radiosity { Rad_Settings(Radiosity_OutdoorHQ,no,no) brightness 0.9 }
}

#local f_Grid_SI_H = function(x,y,z,w,s,length) { f_Grid(x/length,y/length,z/length,w,s) }
#local f_Grid_SI = function(x,y,z,w,s) { f_Grid_SI_H(x,y,z,w,s,(x*x + y*y + z*z)) }

light_source { <1,5,-0.5>*100 rgb <1,0.8,0.6> }


isosurface {
	function {
		f_Grid_SI(x,y,z,0.1,1)
	}
	#local BB = <1.3,1.3,1.3>;
	contained_by { box { -BB, BB } }
	max_gradient 10
	pigment { rgb 1 }
}

