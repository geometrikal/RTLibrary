%
% Process an image and show result
%

% Get current m-file location
[filePath,~,~] = fileparts(mfilename('fullpath'));

% Read image
I = imread('blocksTest.gif');
I = double(I(:,:,1));
I = I(50:end,:);

% Range of N
Nrange = [3,5,7];

imagesc(I);
colormap(gray(256));
imageFillWindow(size(I),1);
saveFigure([filePath '/Results/blocks.png'],gcf,300);

%% Monogenic Signal (N=1)
f = rtVector(I,1,'lognormal',[8, 0.65]);
A = sqrt(f(:,:,2).^2 + abs(f(:,:,3)).^2);
phase = -angle(f(:,:,2) + 1i*sign(real(f(:,:,3))).*abs(f(:,:,3)));
theta = mod(-atan(real(f(:,:,3))./imag(f(:,:,3))),pi);

imagesc(A);
colormap(gray(256));
imageFillWindow(size(I),1);
saveFigure([filePath '/Results/blocks-N1-A.png'],gcf,300);

imagesc(phase);
colormap(gray(256));
imageFillWindow(size(I),1);
saveFigure([filePath '/Results/blocks-N1-phase.png'],gcf,300);

imagesc(theta);
colormap(hsv(256));
imageFillWindow(size(I),1);
saveFigure([filePath '/Results/blocks-N1-orient.png'],gcf,300);

imagescHSV(theta,1,abs(sin(phase)));
imageFillWindow(size(I),1);
saveFigure([filePath '/Results/blocks-N1-edge.png'],gcf,300);

%% SSSM
for N = Nrange
    % Process (takes awhile)
    [A, phase, theta, rN, fN] = rtSSSM(I,N,'lognormal',[8, 0.65]);
    f = rtVector(I,N,'lognormal',[8, 0.65]);

    %
    Nstr = num2str(N);
    
    imagesc(A);
    colormap(gray(256));
    imageFillWindow(size(I),1);
    saveFigure([filePath '/Results/blocks-N' Nstr '-A.png'],gcf,300);

    imagesc(phase);
    colormap(gray(256));
    imageFillWindow(size(I),1);
    saveFigure([filePath '/Results/blocks-N' Nstr '-phase.png'],gcf,300);

    imagesc(theta);
    colormap(hsv(256));
    imageFillWindow(size(I),1);
    saveFigure([filePath '/Results/blocks-N' Nstr '-orient.png'],gcf,300);
 
    imagesc(f(:,:,N+1));
    colormap(gray(256));
    imageFillWindow(size(I),1);
    saveFigure([filePath '/Results/blocks-N' Nstr '-R0.png'],gcf,300);
    
    imagesc(A .* cos(phase));
    colormap(gray(256));
    imageFillWindow(size(I),1);
    saveFigure([filePath '/Results/blocks-N' Nstr '-approx.png'],gcf,300);
    
    imagesc(f(:,:,N+1) - A .* cos(phase));
    colormap(gray(256));
    imageFillWindow(size(I),1);
    saveFigure([filePath '/Results/blocks-N' Nstr '-res.png'],gcf,300);
    
    imagesc(rN);
    colormap(gray(256));
    imageFillWindow(size(I),1);
    saveFigure([filePath '/Results/blocks-N' Nstr '-resmag.png'],gcf,300);
    
    imagesc(1-rN./fN);
    colormap(gray(256));
    imageFillWindow(size(I),1);
    saveFigure([filePath '/Results/blocks-N' Nstr '-i1D.png'],gcf,300);
    
    imagescHSV(theta,1,(1-rN./fN).*abs(sin(phase)));
    imageFillWindow(size(I),1);
    saveFigure([filePath '/Results/blocks-N' Nstr '-edge.png'],gcf,300);
end
