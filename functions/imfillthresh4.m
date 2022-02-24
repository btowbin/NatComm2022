function [ out ] = imfillthresh4( cc, raw, prc )
%imfillthresh( cc,rth )
%   cc: connected component (struct)
%   rth: hole size as a fraction of cc size to be filled (0.1 means that
%   holes of that are upto 10% of the worm will be filled)
%   out = PixelIdxList with filled holes
bw = CC2BW(size(raw),cc.PixelIdxList{1});


filled = imfill(bw, 'holes');
outbw = bw;

holes = filled & ~bw;
CCholes = bwconncomp(holes,4);




gr = double(raw(find(~filled )));
% 
% background = mode(gr);
% distunit = prctile(gr,70)-background;
% 
% backstd = distunit;


bacgroundgr=prctile(gr, [10 90]);
bacgroundgr = gr(find(gr>bacgroundgr(1).*gr<bacgroundgr(2)));
background = mean(bacgroundgr);
backstd = std(bacgroundgr);

for ind = 1:CCholes.NumObjects
    
    sumofgrey = median(raw(CCholes.PixelIdxList{ind}));
    
    if (sumofgrey > background+prc*backstd)
        outbw(CCholes.PixelIdxList{ind}) = 1;
    end
       
    
end




out = find(outbw);









end

