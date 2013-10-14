%
% Process an image and show result
%
I = imread('blocksTest.gif');
I = double(I(:,:,1));
Nrange = [3,5,7];

% Monogenic Signal
f = rtVector(I,1,'lognormal',[8, 0.65]);
A = sqrt(f(:,:,2).^2 + abs(f(:,:,3)).^2);
phase = -angle(f(:,:,2) + 1i*sign(real(f(:,:,3))).*abs(f(:,:,3)));
theta = mod(atan(real(f(:,:,3))./imag(f(:,:,3))),pi);

imagesc(A);
colormap(gray(256));
colorbar;
title('Amplitude');
pause;

imagesc(phase);
colormap(gray(256));
colorbar;
title('Phase');
pause;

imagesc(theta);
colormap(hsv(256));
colorbar;
title('Orientation');
pause;

%%

% Process (takes awhile)
[A, phase, theta, rN, fN] = rtSSSM(I,N,'lognormal',[8, 0.65]);
f = rtVector(I,N,'lognormal',[8, 0.65]);

%% Show the results
imagesc(A);
colormap(gray(256));
colorbar;
title('Amplitude');
pause;

imagesc(phase);
colormap(gray(256));
colorbar;
title('Phase');
pause;

imagesc(theta);
colormap(hsv(256));
colorbar;
title('Orientation');
pause;

imagesc(rN);
colormap(gray(256));
colorbar;
title('Residual magnitude');
pause;

imagesc(f(:,:,N+1));
colormap(gray(256));
colorbar;
title('Original');
clims = caxis;
pause;


imagesc(A.*cos(phase));
colormap(gray(256));
colorbar;
title('A * cos(phase)');
caxis(clims)
pause;

imagesc(A.*cos(phase) - f(:,:,N+1));
colormap(gray(256));
colorbar;
title('A * cos(phase) - original');
caxis(clims)
pause;