% Get current m-file location
[filePath,~,~] = fileparts(mfilename('fullpath'));

% Make some kernels
kernels = rtKernels([256,256],9,'lognormal',[96,0.65]);

for j = 0:9
    imagesc(real(kernels(:,:,j+9+1)));
    colormap(gray(256));
    imageFillWindow([256,256],1);
    saveFigure([filePath '/Results/log-normal-kernel-r-' num2str(j) '.png'],gcf,300);
    
    if j ~= 0
        imagesc(imag(kernels(:,:,j+9+1)));
        colormap(gray(256));
        imageFillWindow([256,256],1);
        saveFigure([filePath '/Results/log-normal-kernel-i-' num2str(j) '.png'],gcf,300);
    end
end