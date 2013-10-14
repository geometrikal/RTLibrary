function [ kN ] = rtKernels(kernelSize, N, filterType, filterParams )
%rtKernels Riesz transform kernels
%   Inputs:
%   kernelSize      Size of kernel to make: [rows, columns]
%   N               Maximum order of Riesz transform used
%   filterType      Base filter type:
%                       'lognormal' - log-normal filter
%   filterParams    Vector of filter parameters:
%                       log-normal:  [wavlength, sigma]
%
%   Outputs:
%   kN               Matrix of RT spatial kernels
%                       kN(:,:,1)     : -Nth order
%                       kN(:,:,N+1)   :  0th order
%                       kN(:,:,2*N+1) :  Nth order
%   kNfft            Matrix of RT spectrums
%
%   Example:
%   
%   [ kN ] = rtKernels([512,512],9,'lognormal',[64,0.65])
%
%   Written by:
%
%   Ross Marchant
%   James Cook University
%   ross.marchant@my.jcu.edu.au
%

% Create FFT mesh
[ux,uy,r,th] = rtFFTMesh(kernelSize);

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

% RT
RT = (ux + 1i*uy) ./ abs(ux + 1i*uy);
RT(1,1) = 0;

% RT Vector
kN(:,:,N+1) = real(fftshift(ifft2(filterFFT)));
kNfft(:,:,N+1) = ifftshift(filterFFT);

RTN = RT;
for j = 1:N
    kN(:,:,N+1+j) = fftshift(ifft2(RTN.*filterFFT));
    kN(:,:,N+1-j) = fftshift(ifft2(conj(RTN).*filterFFT));
    kNfft(:,:,N+1+j) = ifftshift(RTN.*filterFFT);
    kNfft(:,:,N+1-j) = ifftshift(conj(RTN).*filterFFT);
    RTN = RTN .* RT;
end


end

