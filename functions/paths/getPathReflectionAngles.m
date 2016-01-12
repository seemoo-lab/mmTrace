function [ angles ] = getPathReflectionAngles( paths )
%GETPATHREFLECTIONANGLES Get the reflection angles within the paths
%
% 	Project: 		mmTrace
% 	Author: 		Daniel Steinmetzer
% 	Affiliation:	SEEMOO, TU Darmstadt
% 	Date: 			January 2016

nReflections = (size(paths,2)-4)/5;

% extract the source of the inbound paths
p_ids = [1,3:5:(size(paths,2)-7); 2,4:5:(size(paths,2)-7)];
points = paths(:,p_ids(:));
points = reshape(points.', 2,[]).';

% extract the reflection points
r_ids = [3:5:(size(paths,2)-2); 4:5:(size(paths,2)-2)];
ref = paths(:,r_ids(:));
ref = reshape(ref.', 2,[]).';

% extract the reflection norms
n_ids = [5:5:(size(paths,2)-2); 6:5:(size(paths,2)-2)];
norms = paths(:,n_ids(:));
norms = reshape(norms.', 2,[]).';

inbound = edgeToLine([ref, points]);
inbound = normalizeVector(inbound(:,3:4));

% Determine the angles
angles = acos(inbound(:,1).*norms(:,1)+inbound(:,2).*norms(:,2));

% Adjust the angles if greater than pi/2
angles(angles>(pi/2)) = pi - angles(angles>(pi/2));

angles = reshape(angles, nReflections, []).';

end

