function [ corners ] = objToCorners( obj )
%OBJTOCORNERS Transform objects to corner representation
%
% 	Project: 		mmTrace
% 	Author: 		Daniel Steinmetzer
% 	Affiliation:	SEEMOO, TU Darmstadt
% 	Date: 			January 2016

	if isempty(obj)
		corners = [];
	else

		c0 = obj(:,1:2);
		
		v = obj(:,3:4)./2;
		al = obj(:,5);
		
		c1 = [  cos(al) .* v(:,1) * 1		- sin(al) .* v(:,2) * 1, ...
			sin(al) .* v(:,1) * 1		+ cos(al) .* v(:,2) * 1];
		c2 = [  cos(al) .* v(:,1) * 1		- sin(al) .* v(:,2) * (-1), ...
			sin(al) .* v(:,1) * 1		+ cos(al) .* v(:,2) * (-1)];
		c3 = [  cos(al) .* v(:,1) * (-1)	- sin(al) .* v(:,2) * (-1), ...
			sin(al) .* v(:,1) * (-1)	+ cos(al) .* v(:,2) * (-1)];
		c4 = [  cos(al) .* v(:,1) * (-1)	- sin(al) .* v(:,2) * 1, ...
			sin(al) .* v(:,1) * (-1)	+ cos(al) .* v(:,2) * 1];
		
		corners = [c0+c1, c0+c2, c0+c3, c0+c4];
	end
end

