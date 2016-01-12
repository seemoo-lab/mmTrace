function [ G_ir] = applyAntennaGains( ccomps, tx_ant_az, rx_ant_az, tx_pattern, rx_pattern )
%APPLYANTENNAGAINS Apply the antenna gains on the channel impulse responses
%
% 	Project: 		mmTrace
% 	Author: 		Daniel Steinmetzer
% 	Affiliation:	SEEMOO, TU Darmstadt
% 	Date: 			January 2016

% determine the size of elements								
nPaths		= size(ccomps.toa,1);		
nSectors	= numel(tx_ant_az);

% linearize the parameters for all path components
tx_ant_az = repmat(tx_ant_az(:).', nPaths, 1);
rx_ant_az = repmat(rx_ant_az(:).', nPaths, 1);

% Determine the antenna gain at the transmitter and receiver
normAngle	= @(x) (normalizeAngle(x,0));

tx_az_off	= normAngle( tx_ant_az - repmat(ccomps.tx_az,1,nSectors));
tx_el_off	= normAngle( 0 - repmat(ccomps.tx_el,1,nSectors));
g_ant_tx	= tx_pattern(tx_az_off, tx_el_off);

rx_az_off	= normAngle( rx_ant_az - repmat(ccomps.rx_az,1,nSectors));
rx_el_off	= normAngle( 0 - repmat(ccomps.rx_el,1,nSectors));
g_ant_rx	= rx_pattern(rx_az_off, rx_el_off);

% Compute the impulse reponse gain
G_ir		= repmat(ccomps.g_p .* ccomps.g_r .* ccomps.g_s, 1, nSectors) ...
				.* g_ant_tx .* g_ant_rx;
end

