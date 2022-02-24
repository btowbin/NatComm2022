function [xs,ys] = getSpline(im,spacing,overedge)
%getSpline(im,spacing,overedge) returns spline from binary image
%   im = binary image (of worm)
%   spacing = spacing in pixels between anchorpoints along the skeleton
%   overedge = number of pixels the spline should be extrapolated beyond
%   the edge of the data

% lsp = findlongestshortestpath(im,200);
% pixellist = orderedPixellist(lsp);
[pixellist wormlength]= findlongestshortestpath(im,50);

if wormlength>0
    pixellistinv(:,2) = pixellist(:,1);
    pixellistinv(:,1) = pixellist(:,2);
    pixellist = pixellistinv;
    clear pixellistinv;
    %define anchorpoints spaced by 50 pixels
    % anchorpoints = pixellist(union(1:100:size(pixellist ,1),length(pixellist )),:);
    anchorpoints = pixellist(1:spacing:size(pixellist ,1),:);

    nSplinePoints = wormlength*2; %two-fold oversampling

    [xs ys] = fitSpline(anchorpoints, nSplinePoints, overedge);
else
    xs = -1;
    ys = -1;
end



end

