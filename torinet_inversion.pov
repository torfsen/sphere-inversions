/*
POV-RAY scene description file.

"Sphere inversion of a net of tori" by Florian Brucker

Contact: mail@florianbrucker.de
Web:     http://www.florianbrucker.de/index.php?p=sphereinversions

Released under the GPL, see http://www.gnu.org/copyleft/gpl.html
*/

#version 3.6;

#default { finish { ambient 0 } }

#include "transforms.inc"
#include "rad_def.inc"
#include "morearray.inc"

background { rgb 1 }

#local NS = 3;  //Net size
#local MajorR = 1;
#local MinorR = 0.2;
#local S = 2.5*(MajorR + MinorR);

camera {
	location <1,1,-1>*1.3
	look_at 0
}


global_settings { 
	assumed_gamma 1.0
	radiosity { Rad_Settings(Radiosity_OutdoorHQ,no,no) brightness 0.9 }
}

light_source { <2,1.5,-1>*100 rgb <1,0.8,0.6> }

/*
	Returns an array of N+2*D points on a circle
	of radius R that is transformed using the 
	transformation T. D gives the number of points
	that overlap in each direction (For splines that
	don't show up at every control point).
*/
#macro Circle_Points(R,N,T,D)
	#local Points = array[N+2*D];
	#local a = 0;
	#while (a<N+2*D)
		#local A = 360*(a-D)/(N-D);
		#local Points[a] = vtransform(vrotate(x*R,y*A),T);
		#local a = a + 1;
	#end
	Points
#end


union {
	#local cx = 0;
	#while (cx<NS)
		#local cy = 0;
		#while (cy<NS)
			#local cz = 0;
			#while (cz<NS)
				#local NX = S*(cx-NS/2);
				#local NX2 = S*(cx+0.5-NS/2);
				#local NY = S*(cy-NS/2);
				#local NY2 = S*(cy+0.5-NS/2);
				#local NZ = S*(cz-NS/2);
				#local NZ2 = S*(cz+0.5-NS/2);
				#local Trans = array[6] {
					transform {             translate <NX2,NY, NZ2> },
					transform { rotate x*90 translate <NX, NY, NZ2> },
					transform { rotate z*90 translate <NX2,NY, NZ>  },
					transform { rotate z*90 translate <NX, NY2,NZ2> },
					transform { rotate x*90 translate <NX2,NY2,NZ>  },
					transform {             translate <NX, NY2,NZ>  }
				}
				#local ct = 0;
				#while (ct<6)
					#local P = Circle_Points(MajorR,20,Trans[ct],2)
					object { Array_To_SI_Sphere_Sweep(P,MinorR,1,0,0) }
					#local ct = ct + 1;
				#end
				#local cz = cz + 1;
			#end
			#local cy = cy + 1;
		#end
		#local cx = cx + 1;
	#end
	pigment { rgb 1 }
	rotate y*20
	rotate x*10
}

