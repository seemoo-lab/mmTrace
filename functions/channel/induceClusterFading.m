function [ ccomps_ext ] = induceClusterFading( ccomps )
%INDUCECLUSTERFADING Add statistical cluster fading effects to
%
% 	Project: 		mmTrace
% 	Author: 		Daniel Steinmetzer
% 	Affiliation:	SEEMOO, TU Darmstadt
% 	Date: 			January 2016

	% Determine the parameter length
	elements = length(ccomps.d);
	
	% Verify channel components lengths
	% TODO:
	
	ccomps_ext=struct();
	ccomps_ext.d			= [];
	ccomps_ext.toa			= [];
	ccomps_ext.reflections	= [];
	ccomps_ext.g_r			= [];
	ccomps_ext.g_p			= [];
	ccomps_ext.g_s			= [];
	ccomps_ext.tx_az		= [];
	ccomps_ext.rx_az		= [];
	ccomps_ext.tx_el		= [];
	ccomps_ext.rx_el		= [];
	ccomps_ext.type			= [];
	
	%% Iterate over all elements
	for n=1:elements
		
		% To not touch the LOS path that has zero time of arrival
		if ccomps.type(n) == 1
			
			ccomps_ext.d			= [ccomps_ext.d; 		ccomps.d(n)];
			ccomps_ext.toa			= [ccomps_ext.toa; 		ccomps.toa(n)];
			ccomps_ext.reflections	= [ccomps_ext.reflections; ccomps.reflections(n)];
			ccomps_ext.g_r			= [ccomps_ext.g_r; 		ccomps.g_r(n)];
			ccomps_ext.g_p			= [ccomps_ext.g_p; 		ccomps.g_p(n)];
			ccomps_ext.g_s			= [ccomps_ext.g_s; 		ccomps.g_s(n)];
			ccomps_ext.tx_az		= [ccomps_ext.tx_az; 	ccomps.tx_az(n)];
			ccomps_ext.rx_az		= [ccomps_ext.rx_az; 	ccomps.rx_az(n)];
			ccomps_ext.tx_el		= [ccomps_ext.tx_el; 	ccomps.tx_el(n)];
			ccomps_ext.rx_el		= [ccomps_ext.rx_el; 	ccomps.rx_el(n)];
			ccomps_ext.type			= [ccomps_ext.type; 	ccomps.type(n)];
			
		% Apply fading to all NLOS paths
		else
			
			% Call the statistical methods from the channel model
			intcls	= cr_gen_intra_cls(ccomps.toa(n));
			s		= size(intcls.am);
			
			% Rewrite the channel statistics with new parameters
			ccomps_ext.toa			= [ccomps_ext.toa; ...
				ccomps.toa(n) + intcls.toa];
			ccomps_ext.d			= [ccomps_ext.d; ...
				ccomps.d(ccomps.type==1) + ...
				(ccomps.toa(n) + intcls.toa) .* physconst('LightSpeed') * 1e-9];
			ccomps_ext.reflections	= [ccomps_ext.reflections; ...
				repmat(ccomps.reflections(n), s)];
			ccomps_ext.g_r			= [ccomps_ext.g_r; ...
				repmat(ccomps.g_r(n),s)];
			ccomps_ext.g_p			= [ccomps_ext.g_p; ...
				repmat(ccomps.g_p(n), s)];
			ccomps_ext.tx_az		= [ccomps_ext.tx_az; ...
				ccomps.tx_az(n) + deg2rad(intcls.tx_az)];
			ccomps_ext.rx_az		= [ccomps_ext.rx_az; ...
				ccomps.rx_az(n) + deg2rad(intcls.rx_az)];
			ccomps_ext.tx_el		= [ccomps_ext.tx_el; ...
				ccomps.tx_el(n) + deg2rad(intcls.tx_el)];
			ccomps_ext.rx_el		= [ccomps_ext.rx_el; ...
				ccomps.rx_el(n) + deg2rad(intcls.rx_el)];
			ccomps_ext.type			= [ccomps_ext.type; ...
				repmat(ccomps.type(n), s)];
			ccomps_ext.g_s			= [ccomps_ext.g_s; ...
				ccomps.g_s(n) * intcls.am];
		end
	end
end

