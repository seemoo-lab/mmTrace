function [ g ] = antGainDirectional( az_off, el_off, hpbw )
%ANTGAINDIRECTIONAL Determines the anntena gain for certain azimuth and
%elevation offset angles.
%
% 	Project: 		mmTrace
% 	Author: 		Daniel Steinmetzer
% 	Affiliation:	SEEMOO, TU Darmstadt
% 	Date: 			January 2016
%
% Requires: normalizeAngle, ant_gain
	
	g_max	= (1.6162./sin(hpbw/2));
	az_off	= normalizeAngle(az_off, 0);
	el_off	= normalizeAngle(el_off, 0);
	n		= -3 ./ (20*log10(cos(hpbw/4)));
	g		= g_max .* (cos(az_off./2)).^n ...
					.* (cos(el_off./2)).^n;
end