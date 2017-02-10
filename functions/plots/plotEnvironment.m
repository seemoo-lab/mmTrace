function plotEnvironment( h, trace, id )
%PLOTENVIRONMENT Plots the environment
%   Detailed explanation goes here

	figure(h);
	hold on;

	% Select the traces to print
	paths	= trace.paths{trace.utid(id)};

	% Get the paths
	ind_x = [1,3:5:size(paths,2)];
	ind_y = [2,4:5:size(paths,2)];	
	points_x = paths(:, ind_x);
	points_y = paths(:, ind_y);
	reflections = sum(~isnan(points_x),2)-2;

	% Specify the colors to use for paths
	mycolors = copper(max(reflections)+1);
	mycolors = mycolors(reflections+1,:);

	% Plot the paths
	for n = size(points_x,1):-1:1
		plot(points_x(n,:), points_y(n,:), 'Color', mycolors(n,:));
	end

	% Plot the room
	room = setRoom(trace.cfg.room_dims(1), trace.cfg.room_dims(2));
	room = objToCorners(room);
	room = [room, room(1:2)];
	rx = room(1:2:end);
	ry = room(2:2:end);
	
	h = plot(rx,ry, 'Color', 'k', 'LineWidth', 1.5);
	xlim([min(rx), max(rx)]);
	ylim([min(ry), max(ry)]);
	axis off;
	
	% Plot the obstacles
	c = objToCorners(trace.cfg.obstacles);
	if ~isempty(c)
		c = [c, c(:,1:2)];
		
		x = c(:,1:2:end);
		y = c(:,2:2:end);
		
		fill(x.',y.',[0.3,0.3,0.3]);
	end
	
	plot(trace.tx_set(id,1), trace.tx_set(id,2),'or');
	plot(trace.rx_set(id,1), trace.rx_set(id,2),'ob');

	hold off;
	
end

