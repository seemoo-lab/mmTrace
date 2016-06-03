%% Initalize the environment
%
% 	Project: 		mmTrace
% 	Author: 		Daniel Steinmetzer
% 	Affiliation:	SEEMOO, TU Darmstadt
% 	Date: 			January 2016

% Set the actual paths
filedir = mfilename('fullpath');
rootdir = fileparts(filedir);

sep = filesep;

%% Add required paths to system
disp('Checking for dependencies and updating adding mmTrace functions to MATLAB path environment ...');
fprintf('Adding module: %-20s', 'mmTrace');  
addpath( ...
	rootdir, ...
	strcat(rootdir, sep, 'functions', sep, 'antennagain'), ...
	strcat(rootdir, sep, 'functions', sep, 'utils'), ...
	strcat(rootdir, sep, 'functions', sep, 'channel'), ...
	strcat(rootdir, sep, 'functions', sep, 'environment'), ...
	strcat(rootdir, sep, 'functions', sep, 'paths'), ...
	strcat(rootdir, sep, 'functions', sep, 'plots'), ...
	strcat(rootdir, sep, 'functions', sep, 'reflections'), ...
	strcat(rootdir, sep, 'functions', sep, 'trace'), ...
	strcat(rootdir, sep, 'functions', sep, 'transceivers'), ...
	strcat(rootdir, sep, 'example') ...
);
disp(' (ok)');

%% Add library paths
% Check if libfolder exists
disp('Checking libraries ...');
libdir = strcat(rootdir, sep, 'lib');
if ~exist(libdir, 'dir')
	disp('Creating folder: lib');
	mkdir(libdir);
end

% Check if matgeom is available
if isempty(strfind(path, 'geom2d'))	
	disp('Adding Library: matGeom ...');
	
	% Try adding the submodule
	matgeompath = strcat(rootdir, sep, 'lib', sep, 'matgeom', sep, 'matGeom');
	if exist(matgeompath, 'dir')
		addpath(matgeompath);
		setupMatGeom;
	else
		warning('MatGeom library appears to be missing. Download and install manually from http://matgeom.sourceforge.net or update your git submodules.');
	end
end

% Check the channel models
chanmodpath = strcat(rootdir, sep, 'lib', sep, '60_ghz_channel_model');
disp('Checking Library: 60 GHz Channel Model ...');
if ~exist(chanmodpath, 'dir')
	msg = 'The 60 GHz Channel Model appears to be missing, do you want me to download this for you? Y/N [N]:';
	str = input(msg,'s');
	if upper(str) == 'Y'
		disp('Downloading Library: 60 GHz Channel Model ...');
		download_channel_models([rootdir, sep, 'lib', sep]);
		
		disp('Adding Library: 60 GHz Channel Model ...');
		addpath(	strcat(chanmodpath, sep, 'beamforming', sep, 'matlab_code'), ...
				strcat(chanmodpath, sep, 'common'), ...
				strcat(chanmodpath, sep, 'conference_room'), ...
				strcat(chanmodpath, sep, 'cubicle'), ...
				strcat(chanmodpath, sep, 'living_room'), ...
				strcat(chanmodpath, sep, 'work'));
	else
		disp('Skipping installation of channel models, mmTrace might not work correctly.');
	end
else
	disp('Adding Library: 60 GHz Channel Model ...');
	addpath(	strcat(chanmodpath, sep, 'beamforming', sep, 'matlab_code'), ...
				strcat(chanmodpath, sep, 'common'), ...
				strcat(chanmodpath, sep, 'conference_room'), ...
				strcat(chanmodpath, sep, 'cubicle'), ...
				strcat(chanmodpath, sep, 'living_room'), ...
				strcat(chanmodpath, sep, 'work'));
end
