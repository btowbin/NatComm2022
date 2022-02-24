function [ out ] = imfillthresh5( bw, raw, prc )
%imfillthresh( cc,rth )
%   bw: binary of segmentation
%   raw: raw image to be segmented
%   prc: number of standard deviations away from background a hole has to
%   be to be filled


% bw = CC2BW(size(raw),cc.PixelIdxList{1});


filled = imfill(bw, 'holes');
outbw = bw;

holes = filled & ~bw;
CCholes = bwconncomp(holes,4);

gr = double(raw(find(~filled )));



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




out = outbw;









end

