%% lambda: Determines the wavelength for a given frequency
function [l] = lambda(f)
	c0 = physconst('LightSpeed');		
	l = c0 / f;
