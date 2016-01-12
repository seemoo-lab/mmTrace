%% tracePathsRecursion: recursively determine paths between objects
function [paths] = tracePathsRecursion(p1, p2, corners, mirrors, depth)
%
% Input:
% 	p1: 		origin of the paths
% 	p2: 		destination of the paths
% 	corners: 	Object in the environment expressed by corners
% 	mirrors: 	list of mirrors of the actual path
% 	depth:		Depth of recursion, maximum number of reflections
%
% Output:
% 	paths: 		Expression of paths
%
% A path consists of the point that reflect a paths each path_element is consists of [x_P, y_P, x_n, y_n, obj] where x_P and y_P are the coordinates of an interception point, x_n, y_n, is the norm of the reflecting edge and obj is the id of the reflecting object.
%
% 	Project: 		mmTrace
% 	Author: 		Daniel Steinmetzer
% 	Affiliation:	SEEMOO, TU Darmstadt
% 	Date: 			January 2016



% Determine the direct paths between P1 and P2
paths = [p1, nan(1,5*(depth))];

if depth > 0

	% Choose the potential mirrors
	% Mirrors are edges of objects that face p2 and are not completely blocked between the actual mirror (or p2 if no mirror is available)
	myMirrors					= facingEdges(corners, p2);
	[myMirrors, myMirrors_id]	= getPotentialMirrors(myMirrors, corners, [mirrors, p2]);
	
	% Overwrite the room facing edges for improoved performance
	myMirrors(myMirrors_id==1,:)	= [];
	myMirrors_id(myMirrors_id==1)	= [];
	myMirrors = [corners(1,1:6); corners(1,5:8), corners(1,1:2); myMirrors];
	myMirrors_id = [1;1;myMirrors_id];
	
	% Exclude the current mirror 
	if ~isempty(mirrors)
		if mirrors(5) ~=1
			cur_mirror = mirrors(5);
			myMirrors(myMirrors_id==cur_mirror,:)	= [];
			myMirrors_id(myMirrors_id==cur_mirror)	= [];
		else
			% Exlude the same object as before
			
		end
	end
	% Exclude the same mirror surface of the
	
	
	if ~isempty(myMirrors)
	
		% Determine the images of p2 in the mirrors
		myMirrors = [myMirrors(:,1:4), myMirrors(:,3:6)];
		myMirrors = reshape(myMirrors.',4,[]).';
		myMirrors_id = kron(myMirrors_id, [1;1]);
	
		images = mirrorPointOnLines(p2, edgeToLine(myMirrors));

		% Iterate over all mirrors
		for m = 1:size(myMirrors)

			% Set new p2 to reflection point and decrease the depth
			p_r			= images(m,:);
			new_mirrors = [myMirrors(m,:), myMirrors_id(m), mirrors ];
			paths_rec	= tracePathsRecursion(p1, p_r, corners, new_mirrors, depth-1);
			nPaths		= size(paths_rec,1);
			
			if isempty(paths_rec)
				continue;
			end
			
			% Add the current mirror to the received paths
			% Determine the extact mirror point
			p_mirr	= intersectEdges(myMirrors(m,:), [repmat(images(m,:), nPaths,1), paths_rec(:,1:2)]);
			n_edge	= repmat(normEdge(myMirrors(m,:)), nPaths, 1);
			o_id	= repmat(myMirrors_id(m),nPaths,1);
			
			paths_rec	= [p_mirr, n_edge, o_id, paths_rec];
			
			% Remove invalid
			paths_rec(isnan(p_mirr(:,1)),:) = [];
			idx = distancePoints(paths_rec(:,1:2), paths_rec(:,6:7),'diag')<1e-4;
			paths_rec(idx,:) = [];
			
			paths = [paths; paths_rec];
		end
	end
	% Combine the recursivepath with the direct ones.
end

% Validate the last path element
mypaths = [paths(:,1:2), repmat(p2, size(paths,1),1)];
if ~isempty(mirrors)
	% Check if the paths hit the mirror and remove if they don't
	mymirror	= mirrors(1:4);
	P_mirr		= intersectEdges(mypaths, mymirror);
	paths(isnan(P_mirr(:,1)),:) = [];
	
	% Overwrite mypath for the following test
	if ~isempty(paths)
		mypaths = [paths(:,1:2), P_mirr(~isnan(P_mirr(:,1)),:)];
	else
		mypaths = [];
	end
end

if ~isempty(paths)
	% Check that nothing is in the way, blocks mypaths
	intersects = intersectEdgeObject(mypaths, corners);
	intersects = any(~isnan(intersects),2);
	
	if size(paths,1) > 1
		%intersects = squeeze(intersects);
		intersects = permute(intersects, [1,3,2]);
	end
	intersects = intersects.';
	
	if ~isempty(mirrors)
		mymirror = mirrors(5);
		intersects(:, mymirror) = 0;
	end
	
	% Remove the intercepts with the next objects
	if depth > 0
		nextmirror = paths(:,5);
		ind = sub2ind(size(intersects), find(~isnan(nextmirror)), nextmirror(~isnan(nextmirror)));
		intersects(ind) = 0;
	end
	
	paths(any(intersects,2), :) = [];
end
end
	

