function [ecdys, midmolt, sizeAtMidMolt, volAtEcdysis] = findEcdysis(vol,strclass, sizerange, searchWidth, fitwidthEndmolt, fitWidthVolAtEcdys, L1flag)
%[ecdys, midmolt, sizeAtMidMolt, volAtEcdysis] = findEcdysis(vol,wormclass, sizerange, searchWidth, fitwidthEndmolt, fitWidthVolAtEcdys)


if ~exist('searchWidth','var') | isempty(searchWidth)       
    searchWidth = 20;
end
    
if ~exist('fitwidthEndmolt','var') | isempty(fitwidthEndmolt)        
    fitwidthEndmolt = 5;
end
    
if ~exist('fitWidthVolAtEcdys','var') | isempty(fitWidthVolAtEcdys)
    fitWidthVolAtEcdys = 10;
end
    
if ~exist('L1flag','var') | isempty(L1flag)
    L1flag = false
end



[midmolt, sizeAtMidMolt, hatchtime] = findMidMolt(vol,strclass, sizerange);
if L1flag
    hatchtime = 1;
end

endmolt = findEndMolt(vol,midmolt, hatchtime, strclass, searchWidth, fitwidthEndmolt);
ecdys = [hatchtime endmolt];
if isnan(ecdys(2))
    ecdys(1) = NaN;
end

[volAtEcdysis] = computevolAtEcdys(vol, ecdys, strclass, fitWidthVolAtEcdys);

end

