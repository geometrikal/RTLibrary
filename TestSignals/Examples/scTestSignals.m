% Get current m-file location
[filePath,~,~] = fileparts(mfilename('fullpath'));

% Make each test signal

% Monogenic Signal
I = sinusoidImage(256,64,1,0,pi/6);
imagesc(I);
colormap(gray(256));
imageFillWindow([256,256],1);
saveFigure([filePath '/Results/sinusoid-image.png'],gcf,300);

% Structure Multi-vector
I = sinusoidImage(256,[64,64],[1,0.7],[0,0],[pi/6 pi/6+pi/2]);
imagesc(I);
colormap(gray(256));
imageFillWindow([256,256],1);
saveFigure([filePath '/Results/two-sinusoids-perpendicular-image.png'],gcf,300);

% Signal Multi-vector
I = sinusoidImage(256,[64,64],[1,0.5],[0,0],[pi/6 pi/6+pi/3]);
imagesc(I);
colormap(gray(256));
imageFillWindow([256,256],1);
hold on;
a = 2*pi/6;
line([128 - 256*cos(a), 128 + 256*cos(a)],...
     [128 - 256*sin(a), 128 + 256*sin(a)],...
     'Color','red','LineWidth',3);
hold off;
saveFigure([filePath '/Results/two-sinusoids-same-phase-image.png'],gcf,300);

% Signal Multi-vector
I = sinusoidImage(256,[64,64],[1,0.5],[0,0],[pi/6 pi/6+pi/3]);
imagesc(I);
colormap(gray(256));
imageFillWindow([256,256],1);
saveFigure([filePath '/Results/two-sinusoids-image.png'],gcf,300);


