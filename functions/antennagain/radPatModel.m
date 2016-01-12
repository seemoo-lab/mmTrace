function [ g ] = radPatModel( az_off, el_off, hpbw )
%RADPATCOSINE Summary of this function goes here
%   Detailed explanation goes here

% Use the implementation of the channel models

	mytheta	= normalizeAngle(az_off(:)) ./ pi * 180;
	myelev	= normalizeAngle(pi/2 + el_off(:)) ./ pi * 180;
	hpbw	= rad2deg(hpbw);
	s		= size(mytheta);
	
	g = ant_gain(1, hpbw, ones(s), mytheta, myelev, ...
					0, 90);
				
	g = reshape(g,size(az_off));

				
end

