function [ fN, A, theta ] = rtVector( I, N, filterType, filterParams )
%rtVector Multi-order Riesz transform response
%   Inputs:
%   I               Image to process
%   filterType      Base filter type:
%                       'lognormal' - log-normal filter
%   filterParams    Vector of filter parameters:
%                       log-normal:  [wavlength, sigma]
%
%   Outputs:
%   f               Matrix containing each response
%                       f(:,:,1)     : -Nth order
%                       f(:,:,N+1)   :  0th order
%                       f(:,:,2*N+1) :  Nth order
%   A               Amplitude of polar form
%   theta           Orientation of polar form
%
%
%   Example:
%   
%   [f, A, theta] = rtVector(I,9,'lognormal',[32,0.65])
%
%   Written by:
%
%   Ross Marchant
%   James Cook University
%   ross.marchant@my.jcu.edu.au
%

% Ensure image is double type and single channel
I = double(I(:,:,1));

% Create FFT mesh
[ux,uy,r,th] = rtFFTMesh(size(I));

% FFT of image
Ifft = fft2(I);

% Apply filter
switch lower(filterType)
    
    case {'lognormal','log-normal','loggabor','log-gabor'}
        wavelength = filterParams(1);
        sigma = filterParams(2);
        filterFFT = 1.0/wavelength;
        filterFFT = exp((-(log(r/filterFFT)).^2) / (2 * log(sigma)^2));
        filterFFT(1,1) = 0;
        
    otherwise
        error('Unknown filter type');
end

Ifft = Ifft .* filterFFT;

% RT
RT = (ux + 1i*uy) ./ abs(ux + 1i*uy);
RT(1,1) = 0;

% RT Vector
fN(:,:,N+1) = real(ifft2(Ifft));
A(:,:,N+1) = fN(:,:,N+1);
theta(:,:,N+1) = zeros(size(fN(:,:,N+1)));

RTN = RT;
for j = 1:N
    % Complex form
    fN(:,:,N+1+j) = ifft2(RTN.*Ifft);
    fN(:,:,N+1-j) = ifft2(conj(RTN).*Ifft);
    % Polar form
    A(:,:,N+1+j) = abs(fN(:,:,N+1+j));
    A(:,:,N+1-j) = abs(fN(:,:,N+1-j));
    theta(:,:,N+1+j) = angle(fN(:,:,N+1+j));
    theta(:,:,N+1+j) = angle(fN(:,:,N+1+j));
    RTN = RTN .* RT;
end
        

end

