function [str_class] = classifyWormType(str_seg_flnm, Pred, pixelsize)
%classifyWormType(bw, Pred) returns if straightened image bw is an egg ('e'),
%worm('w'), or straightening mistake ('o') based on classifier 'Pred


% wormlength =sum(sum(bw)>0);
% std_bw = std(sum(bw));
% cv_bw = std(sum(bw))./mean(sum(bw));
% max_bw = max(sum(bw));
% median_bw = median(sum(bw));
% maxpermedian = max(sum(bw))/median(sum(bw));
% wormvolume = sum((3.14/4*sum(bw))/2.^2)/2;
% volumeperlength= wormvolume./wormlength;
% wormentropy = entropy(uint8(sum(bw)/2));
    wormFeat = computeStrWormFeat(str_seg_flnm,pixelsize);
    str_class = Pred.predict(wormFeat);
    str_class = str_class{:};

    if(~isletter(str_class)), str_class = char(str2num(str_class));,end



end

