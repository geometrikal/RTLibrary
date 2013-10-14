function resizeFigure( h, scale, xadj, yadj, xwadj, ywadj, picas )
%IMAGESCLOGY Plot image with a log scale Y axis label
%
%   I       image to display
%   minY    minimum y axis value
%   maxY    maximum y axis value
%   scale   factor to scale the image (default = 1)
%
% MAX WIDTH:  16 picas  = 16 * 12 points = 192

max_width = picas*12;

if nargin < 2, scale = 1; end
if nargin < 3, xadj = 0; yadj = 0; end

%Get the figure boundaries in points
set(h,'Units','points');
p = get(h,'Position');

%Width and height
sx = p(3);
sy = p(4);

%Width must be 192
scale_factor = max_width / sx;
sx = max_width;
sy = sy * scale_factor * scale(1) / scale(2);

set(h,'Units','points','Position',[p(1) p(2) sx sy]);
set(h,'PaperPositionMode','auto');
set(h,'Color','White');
set(gca,'Units','points','Position',[36+xadj, 32+yadj, sx-48-xwadj-xadj, sy-48-ywadj-yadj]);
colormap gray(256);
end


