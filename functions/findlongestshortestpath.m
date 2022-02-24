function [pix wormlength] = findlongestshortestpath(seg, thresh)
 
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

wormskel = bwmorph(seg>0, 'thin',Inf);

%find endpoints
endpts = bwmorph(wormskel, 'endpoints');
endptslist = find(endpts);

n = length(endptslist);

if n<thresh

    %compute distance matrix between endpoints
    conmat = nan(n);
    for k = 1:n
        %compute distance from endpoint k to all other points on the path
        D1 = bwdistgeodesic(wormskel, endptslist(k), 'quasi-euclidean'); 
        for l = k+1:n %save distance between enpoint k and all other enpoints.
            conmat(k,l) = D1(endptslist(l));
        end
    end



    % find endpoints with maximal distance
    [max_num, max_idx] = max(conmat(:));
    [ep1 ep2]=ind2sub(size(conmat),max_idx);

    %find path of minimal distance between the two endpoints
    D1 = bwdistgeodesic(wormskel, endptslist(ep1), 'quasi-euclidean');

    %added this to find path

    count = 0;

    [cx1 cy1] = ind2sub(size(seg), endptslist(ep1));
    [cx cy] = ind2sub(size(seg), endptslist(ep2));
    wormlength = D1(cx,cy);
    pixellist=[];

    while(~((cx == cx1 & cy == cy1)))
        count = count+1;
        pixellist(count,:) = [cx cy];

        tempsur = D1(cx-1:cx+1, cy-1:cy+1);
        [minval minind] = min(tempsur(:));
        [xd yd]=ind2sub([3 3],minind);
        xd=xd-2;,yd=yd-2;
        cx = cx+xd;,cy=cy+yd;

    end
    pixellist(end+1,:) = [cx cy];
    pix = pixellist;

else
    pix = [-1 -1];
    wormlength = -1;
    
end

end

