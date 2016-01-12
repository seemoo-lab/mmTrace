function [ face ] = facingEdges( obj, P )
%OBJFACINGEDGES Determines the facing edges of an object towards a point
%
% 	Project: 		mmTrace
% 	Author: 		Daniel Steinmetzer
% 	Affiliation:	SEEMOO, TU Darmstadt
% 	Date: 			January 2016

	if size(obj,2) == 8
		% Objects are in corner format
		mycorners = obj;
	elseif size(obj,2) == 5
		% Objects are in center format
		mycorners = objToCorners(obj);
	else
		error('Objects are represented in wrong format');
	end

	% Determine the distance to points
	distance	= distancePoints( reshape(mycorners', 2, [])', P);
	distance	= reshape(distance, 4, [])';
	
	% Get the minimum distance
	[~,ind_min] = min(distance, [], 2);
	
	% Obtain the three points forming the closest edges towards P
	ind_min = mod([	(ind_min-2)*2,	(ind_min-2)*2+1, ...
					(ind_min-1)*2,	(ind_min-1)*2+1, ...
					(ind_min)*2,	(ind_min)*2+1],		8)+1;
	
	% Get the matching subindices and convert to index
	s1 = kron((1:size(obj,1))',ones(6,1));
	s2 = reshape(ind_min',[],1);
	myindex = sub2ind(size(mycorners), s1, s2);
	
	% Extract the points
	face = mycorners(myindex);
	face = reshape(face, 6, [])';
end

