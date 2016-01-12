function [ isin ] = PointinObject( p, objects )
%PointinObject Check if point lies within object
%
% 	Project: 		mmTrace
% 	Author: 		Daniel Steinmetzer
% 	Affiliation:	SEEMOO, TU Darmstadt
% 	Date: 			January 2016

corners = objToCorners(objects);
isin = false;

for n = 1:size(corners,1)
	if isPointInPolygon(p, reshape(corners(n,:),2,[]).')
		isin = true;
		break;
	end
end
end

