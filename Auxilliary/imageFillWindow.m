function [ ] = imageFillWindow(imageSize, scale)
daspect([1 1 1])
set(gcf,'Units','pixels','Position',[0 0 imageSize(2)*scale imageSize(1)*scale]);
set(gca,'Units','normalized','Position',[0 0 1 1]);
axis(gca,'off');