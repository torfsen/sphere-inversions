/*
POV-RAY include file.

"Additional functions for isosurfaces" by Florian Brucker

Contact: mail@florianbrucker.de
Web:     http://www.florianbrucker.de

Released under the GPL, see http://www.gnu.org/copyleft/gpl.html
*/

#ifndef (MOREFUNCTIONS_INC)
#declare MOREFUNCTIONS_INC = version;
#version 3.6;

#include "functions.inc"

/*
f_Cross is a union of infinitely long boxes around each axis. The
boxes have width 2*w.
*/
#declare f_Cross_H = function(x,y,z) { min(max(y,z),max(x,y),max(x,z)) }
#declare f_Cross = function(x,y,z,w) { f_Cross_H(abs(x)-w,abs(y)-w,abs(z)-w) }

/*
f_Grid is a 3D grid of bars which have distance s and width w. Note:
this function only works if s>2*w
*/
#declare f_Grid = function(x,y,z,w,s) {
	f_Cross(mod(abs(x),s)-s/2,mod(abs(y),s)-s/2,mod(abs(z),s)-s/2,w)
}


/*
f_Tori_Net is a 3D net of tori, where R is the major, r the minor Radius and
S the spacing between the tori.
*/
#local f_Tori_Net_H = function(x,y,z,x2,y2,R,r,S) {
	min(
		f_torus(x,y,z,R,r),
		f_torus(z,x2,y2,R,r),
		f_torus(x2,z,y,R,r)
	)
}
#declare f_Tori_Net = function(x,y,z,R,r,S) {
	f_Tori_Net_H(
		mod(abs(x),S)-S/2,
		mod(abs(y),S)-S/2,
		mod(abs(z),S)-S/2,
		mod(abs(x)+S/2,S)-S/2,
		mod(abs(y)+S/2,S)-S/2,
		R,
		r,
		S
	)
}

#version MOREFUNCTIONS_INC;
#end // MOREFUNCTIONS_INC
