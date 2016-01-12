function [ room ] = setRoom( width, length )
%SETROOM Create a geometrical expression of a room with given width and
%length
%
% 	Project: 		mmTrace
% 	Author: 		Daniel Steinmetzer
% 	Affiliation:	SEEMOO, TU Darmstadt
% 	Date: 			January 2016

	room = [0, 0, width, length, 0];
end

