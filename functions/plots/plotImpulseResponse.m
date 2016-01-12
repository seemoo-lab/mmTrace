function plotImpulseResponse( h, impulse_res, f_samp)
%PLOTIMPULSERESPONSE Summary of this function goes here
%   Detailed explanation goes here

	figure(h);
	set(gcf,'name','impulse response');
	hold on;
	
	t=(1:length(impulse_res)) / f_samp *1e9;
	
	subplot(2,1,1);
	plot(t,impulse_res .* conj(impulse_res));
	xlabel('time [ns]');
	ylabel('pdp');
	
	subplot(2,1,2);
	plot(t,angle(impulse_res));
	xlabel('time [ns]');
	ylabel('phase');

end

