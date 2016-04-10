/*
POV-RAY include file.

"Additional array tools" by Florian Brucker

Contact: mail@florianbrucker.de
Web:     http://www.florianbrucker.de

Released under the GPL, see http://www.gnu.org/copyleft/gpl.html
*/

#ifndef (MOREARRAY_INC)
#declare MOREARRAY_INC = version;
#version 3.6;

#include "transforms.inc"


/*
	Transforms an array of points P with a
	given transform T. Returns the new array.
*/
#macro Transform_Array(P,T)
	#if (dimensions(P) != 1)
		#error("Transform_Array only works for 1D-arrays!\n")
	#end
	#local N = dimension_size(P,1);
	#local A = array[N];
	#local a = 0;
	#while (a<N)
		#local A[a] = vtransform(P[a],T);
		#local a = a + 1;
	#end
	A
#end

/*
	Connects an array of points P with
	cylinders of radius R. If S>0 spheres
	of the same radius will be placed at
	the points, too.
*/
#macro Array_To_Cylinders(P,R,S)
	#if (dimensions(P) != 1)
		#error("Array_To_Cylinders only works for 1D-arrays!\n")
	#end
	union {
		#local N = dimension_size(P,1);
		#local a = 1;
		#local P1 = P[0];
		#while (a<N)
			#local P2 = P[a];
			#if (S)
				sphere { P1, R }
			#end
			cylinder { P1, P2, R }
			#local P1 = P2;
			#local a = a + 1;
		#end
		#if (S)
			sphere { P1, R }
		#end
	}
#end

/* Type constants for sphere sweep macros */
#declare SPHERE_SWEEP_LINEAR = 0;
#declare SPHERE_SWEEP_BSPLINE = 1;
#declare SPHERE_SWEEP_CUBIC = 2;

/*
	Creates a sphere_sweep from an array of points
	P using constant radius R. T specifies the
	spline type used: SPHERE_SWEEP_LINEAR, SPHERE_SWEEP_BSPLINE
	or SPHERE_SWEEP_CUBIC.
*/
#macro Array_To_Sphere_Sweep(P,R,T,Tol)
	#if (dimensions(P) != 1)
		#error("Array_To_Sphere_Sweep only works for 1D-arrays!\n")
	#end
	#local N = dimension_size(P,1);
	sphere_sweep {
		#switch (T)
			#case (0) linear_spline #break
			#case (1) b_spline #break
			#case (2) cubic_spline #break
			#else #error("Array_To_Sphere_Sweep: T must be 0, 1 or 2\n")
		#end
		N,
		#local a = 0;
		#while (a<N)
			#if (a>0) , #end
			P[a], R
			#local a = a + 1;
		#end
		#if (Tol>0)
			tolerance Tol
		#end
	}
#end

/*
	Same as Array_To_Sphere_Sweep, but the result is
	a sphere inversion of the sphere_sweep. The additional
	parameter I specifies how many additional points are
	linear interpolated between array elements. Set I to 0 if
	you want to use only the original points. Use the
*/
#macro Array_To_SI_Sphere_Sweep(P,R,T,Tol,I)
	#if (dimensions(P) != 1)
		#error("Array_To_SI_Sphere_Sweep only works for 1D-Arrays!\n")
	#end
	#local N = dimension_size(P,1);
	#local I = max(ceil(I)+1,1);  // Count points in array as interpolated
	sphere_sweep {
		#switch (T)
			#case (0) linear_spline #break
			#case (1) b_spline #break
			#case (2) cubic_spline #break
			#else #error("Array_To_Sphere_Sweep: T must be 0, 1 or 2\n")
		#end
		N+(N-1)*(I-1),
		#local a = 0;
		#while (a<N)
			#if (a<N-1)
				// Insert interpolated points
				#local b = 0;
				#local P1 = P[a];
				#local P2 = P[a+1];
				#while (b<I)
					#local CP = P1 + (P2-P1)*b/I;
					#local L = max(1e-8,CP.x*CP.x + CP.y*CP.y + CP.z*CP.z);
					#if (a>0 | b>0) , #end
					CP/L, R/L
					#local b = b + 1;
				#end
			#else
				// Insert last point without interpolated points
				#local L = max(1e-8,P[a].x*P[a].x + P[a].y*P[a].y + P[a].z*P[a].z);
				#if (a>0) , #end
				P[a]/L, R/L
			#end
			#local a = a + 1;
		#end
		#if (Tol>0)
			tolerance Tol
		#end
	}
#end


#version MOREARRAY_INC;
#end // MOREARRAY_INC
