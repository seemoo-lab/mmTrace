function [ edges ] = objToEdges( object )
%OBJTOEDGES Transform object to edge representation
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
	
	edges = 

end

