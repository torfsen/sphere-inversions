/*
POV-RAY scene description file.

"Sphere inversion of a Truchet tiling" by Florian Brucker

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
	location <1,1,-1>*3
	look_at y*0.5
}

light_source { <1,2,-3.5>*100 rgb <1,0.8,0.6> }

global_settings { 
	radiosity { Rad_Settings(Radiosity_OutdoorHQ,no,no) brightness 0.9 }
}

/*
Returns a random item from {-1,0,1}. S is a random seed
*/
#macro RR(S)
	(floor(rand(S)*2.99999999)-1)
#end

/*
Returns a random item from {-1,1}. S is a random seed
*/
#macro SR(S)
	(floor(rand(S)*1.9999999)*2-1)
#end


/*
Prepare an array of points in a quarter circle. Because cubic splines
need an additional control point before and after the actual spline
we add these, too.
*/
#local N = 10;           //Number of points in array (at least 2)
#local QC1 = array[N+2]; //Points
#local Angle = 90/(N-1);
#local a = 0;
#while (a<N+2)
	#local QC1[a] = vrotate(0.5*z,y*(a-1)*Angle) - <0.5, 0, 0.5>;
	#local a = a + 1;
#end
#local QC2 = Transform_Array(QC1, transform { rotate x*90  rotate y*180 })
#local QC3 = Transform_Array(QC1, transform { rotate x*-90 rotate y*90  })

/*
Arrange the truchet tiling.
*/
union {
	#local Seed = seed(3895); //Random seed
	#local S = 7;             //Number of tiles to use in each dimension
	#local cx = 0;
	#while (cx<S)
		#local cy = 0;
		#while (cy<S)
			#local cz = 0;
			#while (cz<S)
				#local T = transform {
					rotate 90*<RR(Seed),RR(Seed),RR(Seed)>
					scale <SR(Seed),SR(Seed),SR(Seed)>
					translate -(S-1)/2 + <cx,cy,cz>
				}
				#local A1 = Transform_Array(QC1, T)
				#local A2 = Transform_Array(QC2, T)
				#local A3 = Transform_Array(QC3, T)
				#if (cx!=(S-1)/2 | cy!=(S-1)/2 | cz!=(S-1)/2)
					object { Array_To_SI_Sphere_Sweep(A1,0.1,SPHERE_SWEEP_CUBIC,1e-3,0) } 
					object { Array_To_SI_Sphere_Sweep(A2,0.1,SPHERE_SWEEP_CUBIC,1e-3,0) }
					object { Array_To_SI_Sphere_Sweep(A3,0.1,SPHERE_SWEEP_CUBIC,1e-3,0) }
				#end
				#local cz = cz + 1;
			#end
			#local cy = cy + 1;
		#end
		#local cx = cx + 1;
	#end
	pigment { rgb 1 }
}
/*
cylinder { -1000*x, 1000*x, 0.1 pigment { rgb x } }
cylinder { -1000*y, 1000*y, 0.1 pigment { rgb y } }
cylinder { -1000*z, 1000*z, 0.1 pigment { rgb z } }
*/
