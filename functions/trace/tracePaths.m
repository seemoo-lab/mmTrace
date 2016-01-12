%% tracePaths: determine paths between objects
function [paths] = tracePaths(p1, p2, objects, max_depth)
%
% 	Project: 		mmTrace
% 	Author: 		Daniel Steinmetzer
% 	Affiliation:	SEEMOO, TU Darmstadt
% 	Date: 			January 2016

	% Convert the objects to corners
	corners = objToCorners(objects); 

	% Call the recursive method
	paths = tracePathsRecursion(p2, p1, corners, [], max_depth);
	
	paths = [repmat(p1, size(paths,1),1), paths];
end