% Get current m-file location
[filePath,~,~] = fileparts(mfilename('fullpath'));

% Make some kernels
kernels = rtKernels([256,256],9,'lognormal',[96,0.65]);

% Sinusoidal wavelet
sinusoidType = rtSinusoidArchetypeVector(1,pi/4,pi/4,9,0);

for j = 1:9
    sinusoidType = rtSinusoidArchetypeVector(1,pi/2,pi/4,9,0);
    wavelet = rtWaveletKernel(sinusoidType(10-j:10+j), kernels(:,:,10-j:10+j));
    imagesc(wavelet);
    colormap(gray(256));
    imageFillWindow([256,256],1);
    saveFigure([filePath '/Results/log-normal-kernel-r-' num2str(j) '.png'],gcf,300);
    
    sinusoidType = rtSinusoidArchetypeVector(1,0,pi/4,9,0);
    wavelet = rtWaveletKernel(sinusoidType(10-j:10+j), kernels(:,:,10-j:10+j));
    imagesc(wavelet);
    colormap(gray(256));
    imageFillWindow([256,256],1);
    saveFigure([filePath '/Results/log-normal-kernel-i-' num2str(j) '.png'],gcf,300);
end