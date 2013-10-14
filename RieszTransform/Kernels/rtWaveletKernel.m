function [ wavelet, waveletKernel ] = rtWaveletKernel( rtVector, kernels )
%rtWaveletKernel Creates a 2D steerable wavelet
%   Inputs:
%   rtVector        rtVector of wavelet
%   kernels         Base kernels from rtKernels()
%
%   Outputs:
%   wavelet         Wavelet decomposition
%   waveletConv     Convolution kernel for filtering
%
%   Example:
%
%   [ wavelet ] = rtWaveletKernel([1 0 1 0 1 0 1 0 1],...
%                   rtKernels([512,512],9,'lognormal',[64,0.65]))
%
%   Written by:
%
%   Ross Marchant
%   James Cook University
%   ross.marchant@my.jcu.edu.au
%



wavelet = zeros(size(kernels(:,:,1)));
waveletKernel = zeros(size(kernels(:,:,1)));

sizeRT = numel(rtVector);

for k = 1:sizeRT
    wavelet = wavelet + rtVector(k) * kernels(:,:,sizeRT+1-k);
    waveletKernel = waveletKernel + conj(rtVector(k)) * kernels(:,:,k);
end

wavelet = real(wavelet) ./ max(max(kernels(:,:,floor(sizeRT/2)+1)));
waveletKernel = real(waveletKernel);

end

