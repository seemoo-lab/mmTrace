function [ angle ] = getPathRXAngle( paths )
%GETPATHRXANGLE Get the RX angle of a path
%
% 	Project: 		mmTrace
% 	Author: 		Daniel Steinmetzer
% 	Affiliation:	SEEMOO, TU Darmstadt
% 	Date: 			January 2016

p_ids = [1,3:5:size(paths,2); 2,4:5:size(paths,2)];
p_ids = p_ids(:);
pathpoints = paths(:,p_ids);

p_ids = sum(~isnan(pathpoints),2);
p_ind = sub2ind(size(pathpoints), repmat((1:length(p_ids)).',1,4), [p_ids-3,p_ids-2,p_ids-1, p_ids]);

points = pathpoints(p_ind);

angle = angle2Points(points(:,3:4), points(:,1:2));
angle = normalizeAngle(angle,0);
end

