function [ object_id ] = getPathReflectionObject( paths )
%GETPATHREFLECTIONOBJECT Get the obejct id that cause a refelction on paths
%
% 	Project: 		mmTrace
% 	Author: 		Daniel Steinmetzer
% 	Affiliation:	SEEMOO, TU Darmstadt
% 	Date: 			January 2016

ids			= [7:5:(size(paths,2)-2)];
object_id	= paths(:,ids); 
end

