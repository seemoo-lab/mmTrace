function [ set ] = sweepingTransceiver( pos, hpbw, nSec, dir )
%SWEEPING TRANSCEIVER Generates a sweeping transceiver for mmTrace
%evaluation
%
% 	Project: 		mmTrace
% 	Author: 		Daniel Steinmetzer
% 	Affiliation:	SEEMOO, TU Darmstadt
% 	Date: 			January 2016

if ~exist('dir','var'), dir=0; end

set = repmat([pos, deg2rad(hpbw)], nSec, 1);
sdir = getSectorDirections(nSec);
set = [set, normalizeAngle(dir + sdir.',0)];

end

function sectors = getSectorDirections(nSectors)
	sectors = (0:nSectors-1)*2*pi/nSectors-(pi*sign(nSectors-1));
end