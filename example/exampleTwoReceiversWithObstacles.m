%% Example script to demonstrate the usage of mm-trace
% 	Project: 		mmTrace
% 	Author: 		Daniel Steinmetzer
% 	Affiliation:	SEEMOO, TU Darmstadt
% 	Date: 			January 2016

clear; close all;
mytime = tic;

% Place a transmitter at [-1,1], a receiver at [1,-1] and a second receiver
% at [1,1]. The transmitter performs a sector sweep while both receivers are
% oriented towards the transmitter
tx_set = sweepingTransceiver([-1,1], 60, 64);
rx_set = [	sweepingTransceiver([1,1],60,1, angle2Points([1,-1],[-1,1])); ...
			sweepingTransceiver([1,-1],60,1, angle2Points([1,1],[-1,1]))];
        
% Create some obstacles
obstacles = [   0.6, 0.1, 0.5, 0.2, 0, 3.24; ...
                -1.5, -0.5, 0.3, 0.6, 1, 3.24; ];

% Trace the channels
[trace, tr_ccomps] = ch_trace( ...
    tx_set, rx_set, [4.5, 3, 3], ...
    'max_refl', 4, ...
    'obstacles', obstacles);

toc(mytime);

%% Plot the received power for both receivers
figure(1);
set(gcf,'name','channel power in tx sector sweep');
x	= trace.tx_set(1:64,4); 
plot(rad2deg(x), trace.power(1:64), rad2deg(x), trace.power(65:end));
legend('rx1', 'rx2');
xlabel('tx direction');
ylabel('channel power');

% Find the optimal sectors for serving the receivers
[~, s1] = max(trace.power(1:64));
[~, s2] = max(trace.power(65:end));

disp(['Optimal direction for rx1: ', num2str(rad2deg(tx_set(s1,4))), ' degree']);
disp(['Optimal direction for rx2: ', num2str(rad2deg(tx_set(s2,4))), ' degree']);

plotImpulseResponse(figure(2), trace.impres(s1,:), 2.56e9);
plotImpulseResponse(figure(3), trace.impres(64+s2,:), 2.56e9);

% Plot the environment
plotEnvironment(figure(4), trace, 1);
plotEnvironment(figure(5), trace, 65);

