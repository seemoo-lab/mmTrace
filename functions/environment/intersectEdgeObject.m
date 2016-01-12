function [ intersects ] = intersectEdgeObject( edge, object )
%INTERSECTEDGEOBJECT Intersect an edge with objects
%
% 	Project: 		mmTrace
% 	Author: 		Daniel Steinmetzer
% 	Affiliation:	SEEMOO, TU Darmstadt
% 	Date: 			January 2016

	if size(object,2) == 8
		% Objects are in corner format
		mycorners = object;
	elseif size(object,2) == 5
		% Objects are in center format
		mycorners = objToCorners(object);
	else
		error('Objects are represented in wrong format');
	end
	
	intersects = nan(size(object,1), 8, size(edge,1));
	for ne = 1:size(edge,1)
		%% Transfrom corners to edges
		edges = [	mycorners(:,1:4), ...
					mycorners(:,3:6), ...
					mycorners(:,5:8), ...
					mycorners(:,7:8), mycorners(:,1:2)];
		edges = reshape(edges.', 4, []).';
	
		thisintersects = intersectEdges(edge(ne,:), edges);
		intersects(:,:,ne) = reshape(thisintersects.', 8, []).';
	end
	
	% Todo: Can be simplified to facing edges

end

