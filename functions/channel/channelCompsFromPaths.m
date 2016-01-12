function [ ccomp ] = channelCompsFromPaths( paths, distance, f, reflpattern, permittivities)
%CHANNELCOMPS Determine the channel components from paths representations
%
% Inputs:
%	paths:			The paths between transceiver obtained from RT
%	distance:		distance between transceivers; required to normalize
%					the toa to minimum propagation time
%	reflpattern:	Reflection pattern function
%
% 	Project: 		mmTrace
% 	Author: 		Daniel Steinmetzer
% 	Affiliation:	SEEMOO, TU Darmstadt
% 	Date: 			January 2016
%
% Requirements: getPathLength, getPathReflectionObject
	
	%% Validate inputs
	if distance == 0
		warning('Transceiver distance of null might lead to incorrect values');
	end

	%% Determine the distance of channel components (ccomp)
	ccomp.d	= getPathLength(paths);
	
	%% Determine the delay / time of arrival of components
	ccomp.toa	= ccomp.d ./ physconst('LightSpeed') * 1e9;
	toa_min		= distance ./ physconst('LightSpeed') * 1e9;
	ccomp.toa	= ccomp.toa - toa_min;
	
	%% Check the number of reflections
	ccomp.reflections = sum(~isnan(getPathReflectionObject(paths)),2);
	
	%% Determine the reflection coeeficients
	[ccomp.g_r, ccomp.r_a, ccomp.r_e] = reflectioncoefficients(paths, reflpattern, permittivities);
	
	%% The complex amplitude describing path loss and phase shift
	ploss		= db2mag(fspl(ccomp.d, lambda(f)));
	phase		= exp(-1j * 2 * pi / lambda(f) .* ccomp.d);
	ccomp.g_p	= phase ./ ploss;
	
	%% The angles at transmitter and receiver
	ccomp.tx_az = getPathTXAngle(paths);
	ccomp.rx_az = getPathRXAngle(paths);
	ccomp.tx_el = zeros(size(ccomp.tx_az));
	ccomp.rx_el = zeros(size(ccomp.rx_az));
	
	%% Set the type of channel component, usefull for statistical evaluation
	% Type 2: Wall reflections
	ccomp.type = 2 * ones(size(ccomp.d));
	% Type 1: LOS
	idx				= ccomp.reflections==0;
	ccomp.type(idx) = 1;
	% Type 3: obstacle reflections
	idx				= any(getPathReflectionObject(paths)>1,2);
	ccomp.type(idx) = 3;
	
	ccomp.g_s	= ones(size(ccomp.toa));
	
end

% Determine the reflection coefficients
function [rcoef, rang, reps] = reflectioncoefficients(paths, ref_pat, ref_perm)
	ref_angles	= getPathReflectionAngles(paths);
	ref_obs		= getPathReflectionObject(paths);
	ref_eps		= nan(size(ref_obs));
	ref_eps(~isnan(ref_obs)) = ref_perm(ref_obs(~isnan(ref_obs)));
	r			= ref_pat(ref_angles, ref_eps);
	r(isnan(r)) = 1;
	rcoef		= prod(r,2);
	rang		= ref_angles;
	reps		= ref_eps;
end




