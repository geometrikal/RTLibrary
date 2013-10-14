function [ I, rc, cc ] = lineSegmentImage( r, c, ampV, angleV, occluded, smooth, dbg )
%lineImage Creates image with radiating lines
%
%   Inputs:
%
%   r           rows
%   c           columns
%   ampV        vector of line amplitudes
%   angleV      vector of line angles in degrees
%   occluded    1 = image is max value of component lines
%               0 = image is addition of component lines
%   smooth      gaussian filter smooth amount
%   dbg         optional - enable debugging output
%
%   Outputs:
%
%   I           image
%   rc          row of line centre
%   cc          column of line centre

if nargin < 6
    dbg = 0;
end

r = r * 4;
c = c * 4;

I = zeros(r,c);
rc = ceil(r/2);
cc = ceil(c/2);

%angleV = angleV / 180 *pi;

Iorig = I;
Iorig(rc,cc:end) = 1;
if smooth > 0
    h = fspecial('gaussian',smooth*4,smooth*4/8);
    Iorig = imfilter(Iorig,h);
    Iorig = Iorig ./ max(Iorig(:));
end


for k = 1:numel(angleV)
    
    layer(:,:,k) = imrotate(Iorig,-angleV(k),'bilinear','crop') .* ampV(k);
end
if occluded == 1
    I = max(layer,[],3);
else
    I = sum(layer,3);
end

if dbg == 1
    imagesc(I); colormap gray; pause;
end

I = imresize(I,0.25);
rc = rc/4;
cc = cc/4;


