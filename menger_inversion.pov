/*
POV-RAY scene description file.

"Sphere inversion of a Menger sponge" by Florian Brucker

Contact: mail@florianbrucker.de
Web:     http://www.florianbrucker.de/index.php?p=sphereinversions

Released under the GPL, see http://www.gnu.org/copyleft/gpl.html
*/

#version 3.6;
#default { finish { ambient 0 } }
global_settings { assumed_gamma 1 }

#include "rad_def.inc"

background { rgb 1 }

camera { 
	location <0.75,0.25,-1.5>*6
	look_at 0
}

global_settings { 
	radiosity { Rad_Settings(Radiosity_OutdoorLQ,no,no) brightness 0.9 }
}

light_source { <0.5,1,-3>*100 rgb <1,0.8,0.6> }

#declare Menger_Level = 6;

#local f_Menger_H = function(x,y,z) { min(max(x,y),max(x,z),max(y,z)) }

#local f_Menger = function(x,y,z) {
	-min(
		#local a = 0;
		#while (a<Menger_Level)
			#local W = 1 / pow(3,a+1);
			#local W2 = W/2;
			#local W3 = 3*W;
			#local W32 = 3*W/2;
			f_Menger_H(
				abs(mod(abs(x-W32),W3)-W32)-W2,
				abs(mod(abs(y-W32),W3)-W32)-W2,
				abs(mod(abs(z-W32),W3)-W32)-W2
			),
			#local a = a + 1;
		#end
		1
	)
}

#local f_Menger_Cube = function(x,y,z) {
	max(
		f_Menger(x,y,z),
		abs(x)-0.5,
		abs(y)-0.5,
		abs(z)-0.5
	)
}

#local f_Menger_Cube_Scale = function(x,y,z,factor) {
	f_Menger(x/factor,y/factor,z/factor)
}

#declare f_Menger_Cube_SI = function(x,y,z) {
	f_Menger_Cube_Scale(x,y,z,max(x*x + y*y + z*z, 1e-8))
}


isosurface {
	function {
		f_Menger_Cube_SI(x,y,z)
	}
	#local BB = 3.25*<1,1,1>;
	contained_by { box { -BB, BB } }
	max_gradient 3
	pigment { rgb 1 }
}


