function [xs ys] = fitSpline(anchorpoints, nSplinePoints, overedge)
%fitSpline(anchorpoints, nSplinePoints, overedge) fits a spline to anchorpoints
%   anchorpoints 2d array of points to which splie should be fit
%   nSplinePoints: number of spline points to be interpolated
%   overedge: how many pixels the spline should be interpolated beyon the
%   edge of the bordering anchorpoints

nNodes = length(anchorpoints(:,1));
if nNodes >1
    x = anchorpoints(:,1);
    y = anchorpoints(:,2);

    nodePositions = zeros(1,nNodes);
    lastNodePosition = 0;
    for i = 2:nNodes
        dx = x(i) - x(i-1);
        dy = y(i) - y(i-1);
        dLength = sqrt(dx*dx + dy*dy);
        if dLength < 0.001, dLength = 0.001,end;
        lastNodePosition = lastNodePosition + dLength;
        nodePositions(i) = lastNodePosition;
    end


    scale = lastNodePosition/(nSplinePoints-1);

    xs = spline(nodePositions,x,linspace(-overedge,lastNodePosition+overedge,nSplinePoints));
    ys = spline(nodePositions,y,linspace(-overedge,lastNodePosition+overedge,nSplinePoints));
    % 
else
    xs = -1;
    ys = -1;

end

