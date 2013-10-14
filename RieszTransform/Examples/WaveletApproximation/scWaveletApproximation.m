%
% This shows the difference between an image and its wavelet approximation
%

% Image
I = imread('blocksTest.gif');
I = double(I(:,:,1));

% Parameters
wavelength = 8;
sigma = 0.85;
N = 9;
windowWidth = 49;
windowHalfWidth = floor(windowWidth/2);
[imageHeight, imageWidth] = size(I);

% RT vector
f = rtVector(I,N,'lognormal',[wavelength, sigma]);

% Choose point in image
imagesc(I);
colormap(gray(256));
title('Image. Select point to analyse...');
[x,y] = ginput(1);
x = round(x);
y = round(y);

% Show filtered image
imagesc(f(:,:,N+1));
colormap(gray(256));
title(['Image filtered using log-normal kernel, wavelength '...
      num2str(wavelength) ', sigma ' num2str(sigma) ...
      '. Press enter to continue.']);
pause;

% Show selected point
closeUp = f(max(1,y-windowHalfWidth):min(imageHeight,y+windowHalfWidth),...
          max(1,x-windowHalfWidth):min(imageWidth,x+windowHalfWidth),...
          N+1);
imagesc(closeUp);
colorbar;
colormap(gray(256));
title('Close up of selected point. Press enter to continue.');
pause;

% Show kernels
waveletKernel = rtWaveletKernel(f(y,x,:),...
    rtKernels([windowWidth,windowWidth],N,'lognormal',[wavelength,sigma]));
imagesc(waveletKernel);
colorbar;
colormap(gray(256));
title('Wavelet approximation. Press enter to continue.');
pause;

% Show difference
imagesc(abs(closeUp - waveletKernel));
colormap(gray(256));
colorbar;
title(['Absolute difference between close up and wavelet approximation.'...
       'Example finished.']);
