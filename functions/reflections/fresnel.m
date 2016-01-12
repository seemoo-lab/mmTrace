%% fresnel: determines the fresnel coeefficients
function [r_s, r_p, t_s, t_p] = fresnel(theta_in, n1, n2)
%
% 	Project: 		mmTrace
% 	Author: 		Daniel Steinmetzer
% 	Affiliation:	SEEMOO, TU Darmstadt
% 	Date: 			January 2016

	% Determine the angle of the refracted signal
    theta_out = asin( sin(theta_in)  .* n1 ./ n2 );

	n1cos_in 	= n1 .* cos(theta_in);
	n2cos_out 	= n2 .* cos(theta_out);
	n2cos_in 	= n2 .* cos(theta_in);
	n1cos_out 	= n1 .* cos(theta_out);

	r_s = (n1cos_in - n2cos_out) ./ (n1cos_in + n2cos_out);
	
	r_p = (n2cos_in - n1cos_out) ./ (n2cos_in + n1cos_out);

	t_s = 2 .* n1cos_in ./ (n1cos_in + n2cos_out);

	t_p = 2 .* n1cos_in ./ ( n2cos_in + n1cos_out );
