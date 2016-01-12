function [ n ] = normEdge( edge )
%NORMEDGE Determines the orthonormal vector of an edge
%
% 	Project: 		mmTrace
% 	Author: 		Daniel Steinmetzer
% 	Affiliation:	SEEMOO, TU Darmstadt
% 	Date: 			January 2016

	n = orthogonalLine(edgeToLine(edge), edge(1:2));
	n = normalizeVector(n(3:4));
end

