function [ distance, distances ] = getPathLength( paths )
%GETPATHLENGTH Determines the length of a path
%
% 	Project: 		mmTrace
% 	Author: 		Daniel Steinmetzer
% 	Affiliation:	SEEMOO, TU Darmstadt
% 	Date: 			January 2016

p_ids = [1,3:5:size(paths,2); 2,4:5:size(paths,2)];
p_ids = p_ids(:);
pathpoints = paths(:,p_ids);

p1 = (pathpoints(:,1:end-2));
p1 = reshape(p1.', 2, []).';
p2 = (pathpoints(:,3:end));
p2 = reshape(p2.', 2, []).';

distances = distancePoints(p1,p2, 'diag');
distances = reshape(distances, size(pathpoints,2)/2-1, []).';

distances(isnan(distances))=0;
distance = sum(distances, 2);
end

