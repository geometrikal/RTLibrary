function [ spectrum ] = rtFilterSpectrumLogNormal( sizeM, wavelength, sigma )
%RTFILTERLOGNORMAL Summary of this function goes here
%   Detailed explanation goes here

[~,~,r,~] = rtFFTMesh(sizeM);

r2(1,1) = 1;        		      % Radius fudge
f1 = 1.0/wavelength;              % Centre frequency of filter.
spectrum = exp((-(log(r/f1)).^2) / (2 * log(sigma)^2));
spectrum(1,1) = 0;

end

