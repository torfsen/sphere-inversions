/*
POV-RAY scene description file.

"Sphere inversion of a Hilbert curve" by Florian Brucker

Contact: mail@florianbrucker.de
Web:     http://www.florianbrucker.de/index.php?p=sphereinversions

Released under the GPL, see http://www.gnu.org/copyleft/gpl.html
*/

#version 3.6;
#default { finish { ambient 0 } }
global_settings { assumed_gamma 1 }

#include "morearray.inc"
#include "rad_def.inc"

background { rgb 1 }

camera {
	/*
		Distance per per level of recursion:
		2 ~ 18
		3 ~ 35
	*/
	location <1,1,-1.2>*20
	look_at -y
}

light_source { <1,0.5,0>*100 rgb <1,0.8,0.6> }

global_settings { 
	radiosity { Rad_Settings(Radiosity_OutdoorLQ,no,no) brightness 0.9 }
}


/* Initial piece */
#local F = 0.25;
#local Curve = array[8] { 
	F*<1,1,-1>, F*<1,-1,-1>,
	F*<-1,-1,-1>, F*<-1,1,-1>,
	F*<-1,1,1>, F*<-1,-1,1>,
	F*<1,-1,1>, F*<1,1,1>
}

/* Subdivision */
#local Level = 3;
#local Transforms = array[8] {
	transform { scale 0.5 rotate x*90  rotate y*90  translate <  0.25,  0.25, -0.25> },
	transform { scale 0.5 rotate z*90  rotate y*-90 translate <  0.25, -0.25, -0.25> },
	transform { scale 0.5 rotate z*90  rotate y*-90 translate < -0.25, -0.25, -0.25> },
	transform { scale 0.5 rotate z*180              translate < -0.25,  0.25, -0.25> },
	transform { scale 0.5 rotate z*180              translate < -0.25,  0.25,  0.25> },
	transform { scale 0.5 rotate z*90  rotate y*90  translate < -0.25, -0.25,  0.25> },
	transform { scale 0.5 rotate z*90  rotate y*90  translate <  0.25, -0.25,  0.25> },
	transform { scale 0.5 rotate x*-90 rotate y*-90 translate <  0.25,  0.25,  0.25> }
}
#local a = 0;
#while (a<Level)
	#local Old_Length = dimension_size(Curve,1);
	#local New_Curve = array[Old_Length*8];
	#local b = 0;
	#while (b<8)
		#local c = 0;
		#while (c<Old_Length)
			#local New_Curve[b*Old_Length+c] = vtransform(Curve[c],Transforms[b]);
			#local c = c + 1;
		#end
		#local b = b + 1;
	#end
	#local a = a + 1;
	#local Curve = New_Curve;
#end

/* Object */
#local R = 0.01;  // Radius
object {
	Array_To_SI_Sphere_Sweep(Curve,R,1,1e-4,0)
	pigment { rgb 1 }
	rotate y*-30
}
