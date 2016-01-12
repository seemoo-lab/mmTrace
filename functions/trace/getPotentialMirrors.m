function [ mirrors, ids ] = getPotentialMirrors( facingEdges, objects, source)
%GETPOTENTIALMIRRORS Searches for potential mirros in object space
%
% 	Project: 		mmTrace
% 	Author: 		Daniel Steinmetzer
% 	Affiliation:	SEEMOO, TU Darmstadt
% 	Date: 			January 2016

	nObjects = size(facingEdges,1);

	if length(source) == 2
		origin = source;
	elseif length(source) > 2
		origin = [source(1:2);source(3:4)];
	end
	
	nOrigin = size(origin,1);
	
	% Determine the lines to check for intersection
	lines = [	repmat(origin, nObjects*3,1), ...
				kron(reshape(facingEdges.', 2, []).', ones(nOrigin,1)) ];
			
	% Determine the intersections of lines and objects
	myintersects = intersectEdgeObject(lines, objects);
	
	% Find with which objects intersections appear
	myintersects = squeeze(logical(sum(~isnan(myintersects),2)));
	myintersects = reshape(myintersects.', 3 * nOrigin, []).';
	myintersects = reshape(sum(myintersects,2)==(3*nOrigin), [], nObjects);
	
	myintersects = myintersects - eye(nObjects);
	
	% Remove the current reflector
	if length(source) > 2
		cur = source(5);
		myintersects(:,cur)=[];
	end
	
	% The hidden objects are those that are completely blocked by another
	% objects from the mirrors perspective
	hidden		= any(myintersects,2);
	mirrors		= facingEdges(~hidden,:);
	ids			= (1:nObjects).';
	ids			= ids(~hidden);
end

