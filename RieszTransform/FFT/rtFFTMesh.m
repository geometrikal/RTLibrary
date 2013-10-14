function [ux,uy,r,th] = rtFFTMesh(sizeM)

rows = sizeM(1);
cols = sizeM(2);


[ux, uy] = meshgrid(([1:cols]-(fix(cols/2)+1))/(cols-mod(cols,2)), ...
    ([1:rows]-(fix(rows/2)+1))/(rows-mod(rows,2)));
ux = ifftshift(ux);   % Quadrant shift to put 0 frequency at the corners
uy = ifftshift(uy);

% Convert to polar coordinates
th = atan2(uy,ux);
r = sqrt(ux.^2 + uy.^2);

end