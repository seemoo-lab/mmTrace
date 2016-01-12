%% refModFresnel: ReflectionModelUsingFresnel Equations
function [r] = refModFresnel(theta, epsilon)
%
% 	Project: 		mmTrace
% 	Author: 		Daniel Steinmetzer
% 	Affiliation:	SEEMOO, TU Darmstadt
% 	Date: 			January 2016

    % Assume the first medium to be air
    n1 = 1;
    
    % For the second medium, the permeability is zero (non magnetic)
    n2 = sqrt(epsilon);
    
    [r_s, r_p] = fresnel(theta, n1, n2);
    r = sqrt((r_p.^2 + r_s.^2)./2);
end
   