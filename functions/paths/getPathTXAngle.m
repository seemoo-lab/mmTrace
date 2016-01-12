function [ angle ] = getPathTXAngle( paths )
%GETPATHTXANGLE Get the TX angle of a path
%
% 	Project: 		mmTrace
% 	Author: 		Daniel Steinmetzer
% 	Affiliation:	SEEMOO, TU Darmstadt
% 	Date: 			January 2016

% Select the outbound edge
angle = angle2Points(paths(:,1:2), paths(:,3:4));
angle = normalizeAngle(angle,0);
end

