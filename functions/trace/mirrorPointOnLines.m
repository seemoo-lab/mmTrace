function [ mirror] = mirrorPointOnLines( point, lines )
%mirrorPointOnLines determines the image of a point by mirroring on a line
%
% 	Project: 		mmTrace
% 	Author: 		Daniel Steinmetzer
% 	Affiliation:	SEEMOO, TU Darmstadt
% 	Date: 			January 2016

% Determine the mirror
nLines		= size(lines,1);
projPoint	= projPointOnLine(point, lines);
projVect	= projPoint - repmat(point, nLines, 1);
mirror		= repmat(point, nLines, 1) + 2 .* projVect;
end

