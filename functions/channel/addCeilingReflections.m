function [ ccomps ] = addCeilingReflections( ccomps, vspace, f, reflpattern, permittivity, path )
%ADDCEILINGREFLECTIONS Adds an interpolated reflection over the ceiling to
% the los and first order reflections.
%
% 	Project: 		mmTrace
% 	Author: 		Daniel Steinmetzer
% 	Affiliation:	SEEMOO, TU Darmstadt
% 	Date: 			January 2016
%   Detailed explanation goes here
	
	% Find the los
	id_los		= ccomps.reflections==0;
	if sum(id_los)>1
		error('There should be only one LOS path');
	end
	
	%% Add ceiling reflections
	% Locate the first level wall reflections
	idx = (ccomps.reflections == 1 & ccomps.type == 2) | id_los;
	
	% Interpolate the distance over the path over ceiling
	direct_dist		= ccomps.d(idx);
	los_dist		= ccomps.d(id_los);
	ceiling_dist	= 2 * sqrt( vspace^2 + (direct_dist./2).^2); 
	
	toa = (ceiling_dist - los_dist) ./ physconst('LightSpeed') * 1e9;
	reflections = ccomps.reflections(idx) + 1;
	
	% Find the elevation angle at both transceiver and the reflection on
	% the ceiling
	myangle		= atan(vspace ./ direct_dist .* 2);
	
	ref_ceiling = reflpattern(pi/2 - myangle, permittivity);
	
	oldangles		= ccomps.r_a(idx,:);
	[X,Y,Z]			= sph2cart(oldangles(:), kron(myangle,ones(size(oldangles,2),1)),1);
	[X0, Y0, Z0]	= sph2cart(0,0,ones(numel(oldangles),1));
	refangles		= anglePoints3d([X0, Y0, Z0], [X,Y,Z]);
	refangles		= reshape(refangles, size(oldangles));
	
	ref_new			= reflpattern(refangles, ccomps.r_e(idx,:));
	ref_new(isnan(ref_new)) = 1;
	g_r				= prod([ref_new, ref_ceiling],2);
	
	%g_r		= ccomps.g_r(idx) .* ref_ceiling;
	
	ploss	= db2mag(fspl(ceiling_dist, lambda(f)));
	phase	= exp(-1j * 2 * pi / lambda(f) .* ceiling_dist);
	g_p		= phase ./ ploss;
	
	% Write values to struct
	ccomps.d	= [ccomps.d; ceiling_dist];
	ccomps.toa	= [ccomps.toa; toa];
	ccomps.reflections = [ccomps.reflections; reflections];
	ccomps.g_r	= [ccomps.g_r; g_r];
	ccomps.g_p	= [ccomps.g_p; g_p];
	ccomps.g_s	= [ccomps.g_s; ones(size(g_p))];
	
	ccomps.tx_az = [ccomps.tx_az; ccomps.tx_az(idx)];
	ccomps.rx_az = [ccomps.rx_az; ccomps.rx_az(idx)];
	ccomps.tx_el = [ccomps.tx_el; myangle];
	ccomps.rx_el = [ccomps.rx_el; myangle];
	
	ccomps.type = [ccomps.type; repmat(4, size(toa))];
	
end

