function wormFeat = computeStrWormFeat(str_seg_flnm,pixelsize)
%computeStrWormChar(str_seg_flnm,pixelsize) computes characteristic of
%segmented worm used for classificationin egg, worms, or straightening
%error
%   str_seg_flnm=filename (full path) of the binary of the straightened
%   worm
%   pixelsize = pixel dimensions in the image in micrometers (for 10x objective on Ti2 =
%   0.65)
%   wormFeat = array of 9 features used for calssification and training
if ischar(str_seg_flnm)
    seg = bwareafilt(imread(str_seg_flnm)>0,1);
%     'flnm'
else
    seg = str_seg_flnm;
%     'test'
end

noworm  = find(sum(seg)==0);

seg(:,noworm) = [];
if isempty(seg), seg = 1;,end

wormlength = size(seg,2)*pixelsize;
std_bw = std(sum(seg)*pixelsize);
cv_bw = std(sum(seg)*pixelsize)./mean(sum(seg)*pixelsize);
max_bw = max(sum(seg)*pixelsize);
median_bw = median(sum(seg)*pixelsize);
maxpermedian = max(sum(seg)*pixelsize)/median(sum(seg)*pixelsize);

wormvolume = sum(pi/4*(sum(seg)*pixelsize).^2)*pixelsize;
volumeperlength= wormvolume./wormlength;
wormentropy = entropy(uint8(sum(seg)*pixelsize));

wormFeat = [wormlength std_bw cv_bw max_bw median_bw  maxpermedian wormvolume wormentropy volumeperlength];


end

