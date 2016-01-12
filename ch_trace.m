function [ trace, ccomps ] = ch_trace( varargin )
%CH_TRACE Summary of this function goes here
%   Usage:
%		trace = ch_trace(tx_pos, rx_pos);
%		trace = ch_trace(tx_pos, rx_pos, tx_az, rx_az);
% 		trace = ch_trace(tx_pos, rx_pos, tx_az, rx_az, ...);
%
% Inputs:
%	tx_pos:			Position of transmitters	
%	tx_az:			Orientation of transmitters
%	rx_pos:			Positions of receivers
%	rx_az:			Orientation of receivers
%	room_dims:		Dimension of rooms			
%	permit_wall:	Permittivity of walls				
%	permit_ceiling:	Permittivity of ceiling	
%	ant_altitude:	Altitude of antenna mounting				
%	obstacles:		Structure of obstacles		
%	frequency:		Carrier frequency of signals
%	max_refl:		Maximum number of reflections to consider				
%	refl_model:		Function handle of reflection model		
%	tx_sectors:		Sectors at transmit antennas		
%	rx_sectors:		Sectors at receive antennas		
%	suppress_los:	Flag to suppress the line-of-sight			
%	blur_clusters:	Flag to blur the clusters				
%	interpl_3d:		Flag to interpolate to 3D and consider ceiling reflections
%	tx_radpat:		Function handle of transmitter radiation pattern		
%	rx_radpat:		Function handle of receiver radiation pattern
%
% Outputs:
%	trace:			Trace file of all statistics
%   ccomps:			Channel components	
%
% 	Project: 		mmTrace
% 	Author: 		Daniel Steinmetzer
% 	Affiliation:	SEEMOO, TU Darmstadt
% 	Date: 			January 2016


	%% Parse the inputs
	p = inputParser();
	
	p.addRequired('tx_set', @ismatrix);
	p.addRequired('rx_set', @ismatrix);
	
	p.addOptional('room_dims', [4.5, 3, 3], @isvector);
	
	% The permittivities are taken from the channel models as default
	p.addParameter('permit_wall', 3.24, @isnumeric);
	p.addParameter('permit_ceiling', 3.24, @isnumeric);
	p.addParameter('ant_altitude', 1, @isnumeric);
	
	p.addParameter('obstacles', [], @ismatrix);
	
	p.addParameter('frequency', 60e9, @isnumeric);
	p.addParameter('f_sample', 2.56e9 , @isnumeric);
	p.addParameter('max_refl', 4, @isnumeric);
	
	p.addParameter('refl_model', @(t,e)refModFresnel(t,e), @(x)(isa(x,'function_handle')));
	p.addParameter('radpattern', @antGainDirectional, @(x)(isa(x,'function_handle')));
	
	p.addParameter('suppress_los', false, @islogical);
	p.addParameter('blur_clusters', false, @islogical);
	p.addParameter('interpl_3d', false, @islogical);
	
	p.addParameter('evaAllCombinations', true, @islogical);
	
	p.parse(varargin{:});
	cfg = p.Results();
	
	% Parse the anntenna position
	if cfg.evaAllCombinations
		[tx_id, rx_id]	= ndgrid(1:size(cfg.tx_set,1),1:size(cfg.rx_set,1));
		tx_id			= tx_id(:); 
		rx_id			= rx_id(:);
	else
		tx_id			= 1:size(cfg.tx_set,1);
		rx_id			= 1:size(cfg.rx_set,1);
		
		if numel(tx_id) ~= numel(rx_id)
			error('number of tx and rx setting must be equal if evaAllCombinations is deactivated');
		end
	end
	
	trace.tx_set = cfg.tx_set(tx_id,:);
	trace.rx_set = cfg.rx_set(rx_id,:);
	
	% Validate that antenna locations are inside the room
	% TODO: Implement validation of antenna locations

	
	%% 0) Setup
	% Specify the room
	room = setRoom(cfg.room_dims(1), cfg.room_dims(2));
	room = [room, cfg.permit_wall];
	
	% Combine room and objects in one structure
	myobjects = [room; cfg.obstacles];
	
	
	% Determine the combinations of tranceiver pair positions
	% and iterate over all uniques
	[uniquetraces, ~, utid] = unique([cfg.tx_set(tx_id,1:2),cfg.rx_set(rx_id,1:2)], 'rows');
	paths	= cell(size(uniquetraces,1),1); 
	ccomps	= cell(size(uniquetraces,1),1);
	for p = 1:size(uniquetraces,1)
		tx_pos = uniquetraces(p,1:2); rx_pos = uniquetraces(p,3:4);

		%% 1) Trace the paths between TX and RX
		paths{p} = tracePaths(tx_pos, rx_pos, myobjects, cfg.max_refl);
	
		%% 2) Obtain the channel components
		ccomps{p} = channelCompsFromPaths(paths{p}, ...
						distancePoints(tx_pos, rx_pos), ...
						cfg.frequency, ...
						cfg.refl_model, ...
						myobjects(:,6));
	
		% Suppress the los if a nlos scenario should be considered
		if cfg.suppress_los
			ccomps{p}.g_p(ccomps{p}.type==1) = db2mag(-200);
		end
	
		%% 3) Extend the channel properties with statistical approaches
		% Part 1: Add ceiling interpolation
		if cfg.interpl_3d
			ccomps{p} = addCeilingReflections(	ccomps{p}, ...
						cfg.room_dims(3) - cfg.ant_altitude, ...
						cfg.frequency, ...
						cfg.refl_model, ...
						cfg.permit_ceiling, ...
						paths{p});
		end
	
		% Part 2: % Induce inter cluster fading effects and blur the impulse
		% response
		if cfg.blur_clusters
			ccomps{p} = induceClusterFading(ccomps{p});
		end
	end

	
	%% Iterate over all positions
	% Determine the unique transceiver position and beamwidth pairs
	[uniquechannels, cid, ucid] = unique([cfg.tx_set(tx_id,1:3),cfg.rx_set(rx_id,1:3)], 'rows');
	
	gains	= zeros(length(ucid), ccomps_maxlength(ccomps));
	
	for p = 1:size(uniquechannels,1)
		% find the corresponding traceid
		tid = utid(cid(p));
		
		% get the antenna orientation for this combination
		tx_az = trace.tx_set(ucid==p,4);
		rx_az = trace.rx_set(ucid==p,4);
		
		% Determine the appropriate radiation patterns
		tx_radpat = @(x,y) (cfg.radpattern(x,y,uniquechannels(p,3)));
		rx_radpat = @(x,y) (cfg.radpattern(x,y,uniquechannels(p,6)));
		
		% compute the channel gains for this combination
		mygains = applyAntennaGains(...
					ccomps{tid}, ...		% The channel components
					tx_az, ...
					rx_az, ...				% The antenna orientation
					tx_radpat, ...			% Transmitter radiation pattern
					rx_radpat);				% Receiver radiation pattern
				
		% Store the channel component gains along with toa values
		gains(ucid==p,1:size(mygains,1))	= mygains.';
	end
	
	% Convert channel components to structure array
	
	ccomps = ccomps_celltostruct(ccomps);
	
	%% 5) Extract channel characteristics
	% The power of channel components
	p	= gains.*conj(gains);
	
	% The commulative channel power
	trace.power	= pow2db(sum(p,2));
	
	% The mean delay and spread
	toa = ccomps.toa(utid, :);
	toa(isnan(toa)) = 0;
	trace.tau_mean	= sum(p .* toa, 2) ./ sum(p,2);
	trace.tau_rms	= sqrt( ...
		sum( (toa - repmat(trace.tau_mean,1,size(p,2))).^2 .* p, 2) ./ sum(p,2));
	
	% The discrete channel impulse response
	N = round(max(toa(:)).*cfg.f_sample.*1e-9) + 1;
	impres		= zeros(size(toa,1), N);
	for n = 1:size(gains,1)
		myimpres = ct2dt(gains(n,:), toa(n,:), cfg.f_sample/1e9);
		impres(n, 1:length(myimpres)) = myimpres;
	end
	
	trace.impres = impres;
	trace.ccomps = ccomps;

	% Store the environment for plotting
	trace.paths	= paths;
	trace.cfg	= cfg;
	trace.utid	= utid;
	trace.gains = gains;
	trace.toa	= toa;
end

function ml = ccomps_maxlength(ccomps)
	ml = 0;
	for n = 1:numel(ccomps)
		ml = max(length(ccomps{1}.d),ml);
	end
end

function str = ccomps_celltostruct(ccomps)
	fnames = fieldnames(ccomps{1});
	for n = 1:numel(fnames)
		f		= char(fnames(n));
		if strcmp(f, 'r_a') || strcmp(f, 'r_e')
			continue;
		end
		data	= nan(length(ccomps), ccomps_maxlength(ccomps));
		
		for k = 1:length(ccomps)
			data(k, 1: length(ccomps{k}.d)) = ccomps{k}.(f);
		end
		str.(f) = data;
	end
end


