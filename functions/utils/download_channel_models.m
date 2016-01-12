function download_channel_models( libfolder )
%DOWNLOAD_CHANNEL_MODELS Script to download the 60 GHz channel models from
%IEEE

	document_url	= 'https://mentor.ieee.org/802.11/dcn/09/11-09-0854-03-00ad-implementation-of-60ghz-wlan-channel-model.doc';
	filename		= '60ghz-wlan-channel-model';
	
	% Download the file
	if ~exist([libfolder, filename, '.doc'], 'file')
		websave([libfolder, filename, '.doc'],document_url);
	end
	
	% Extract the zip from the embedded document
	fileId	= fopen([libfolder, filename, '.doc']);
	data	= fread(fileId);
	fclose(fileId);
	
	% Cut the data for the embedded zip file
	data	= data(86727:end);
	data	= data(1:85912);
	
	% Write the zip file
	fileId	= fopen([libfolder, filename, '.zip'], 'w');
	fwrite(fileId, data);
	fclose(fileId);
	
	% Unzip the content
	unzip([libfolder, filename, '.zip'], libfolder);
end

