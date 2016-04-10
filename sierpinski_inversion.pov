/*
POV-RAY scene description file.

"Sphere inversion of a Sierpinski tetrahedron" by Florian Brucker

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
	location <1,1,-1>*3.75
	look_at y*0.1
}

global_settings { 
	radiosity { Rad_Settings(Radiosity_OutdoorHQ,no,no) brightness 0.8 }
}

light_source { <-1,2,-3>*100 rgb <1,0.8,0.6> }


/* 
Vertices of a tetrahedron inscribed in the unit sphere
*/
#local V1 = x;
#local V2 = vrotate(x,y*120);
#local V3 = vrotate(x,y*240);
#local V4 = y*sqrt(2);
#local C = (V1 + V2 + V3 + V4)/4;
#local V1 = V1 - C;
#local V2 = V2 - C;
#local V3 = V3 - C;
#local V4 = V4 - C;



/* 
Unit normals of its faces (pointing outward)
*/
#local N1 = vnormalize(vcross(V4-V1,V2-V1));  // V1, V2, V4
#local N2 = vnormalize(vcross(V4-V2,V3-V2));  // V2, V3, V4
#local N3 = vnormalize(vcross(V4-V3,V1-V3));  // V3, V1, V4
#local N4 = -y;                               // V1, V2, V3 

/*
Create the Sierpinski version by recursion
*/
#local Level = 6;                             // Recursion depth

#macro Sierpinski(P1,P2,P3,P4,L)
	#if (L>0)
		#local N1 = (P1+P2)/2;
		#local N2 = (P2+P3)/2;
		#local N3 = (P3+P1)/2;
		#local N4 = (P2+P4)/2;
		#local N5 = (P3+P4)/2;
		#local N6 = (P1+P4)/2;
		Sierpinski(P1,N1,N3,N6,L-1)
		Sierpinski(N1,P2,N2,N4,L-1)
		Sierpinski(N3,N2,P3,N5,L-1)
		Sierpinski(N6,N4,N5,P4,L-1)
	#else
		// Sphere inversion
		#local T1 = P1/max(1e-8,P1.x*P1.x + P1.y*P1.y + P1.z*P1.z);
		#local T2 = P2/max(1e-8,P2.x*P2.x + P2.y*P2.y + P2.z*P2.z);
		#local T3 = P3/max(1e-8,P3.x*P3.x + P3.y*P3.y + P3.z*P3.z);
		#local T4 = P4/max(1e-8,P4.x*P4.x + P4.y*P4.y + P4.z*P4.z);
		
		
		triangle { T1, T2, T4 }
		triangle { T2, T3, T4 }
		triangle { T3, T1, T4 }
		triangle { T1, T2, T3 }
	#end
#end

mesh {
	Sierpinski(V1,V2,V3,V4,Level)
	pigment { rgb 1 }
}

