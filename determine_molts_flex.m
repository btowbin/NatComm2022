function determine_molts_flex(sourcepath, destpath, sizerangestartIn, L1flag)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here



if ~exist('sizerangestart','var') | isempty(sizerangestart)       
    sizerangestart =[6.6e4 15e4 36e4 102e4];
end
    
if ~exist('L1flag','var') | isempty(L1flag)        
    L1flag = false;
end

str = load(sourcepath);
vol_all = str.vol;
wormclass_all = str.strClass;

    for s = 1:size(vol_all,1)
        wormclass = wormclass_all(s,:);
        vol = vol_all(s,:);
        [ecdys_T, midmolt_T, sizeAtMidMolt_T, volAtEcdysis_T] = findEcdysis(vol,wormclass, sizerangestart, [],[],[], L1flag);%, searchWidth, fitwidthEndmolt, fitWidthVolAtEcdys)
        ecdys(s,:) = ecdys_T;
        volAtEcdysis(s,:) = volAtEcdysis_T;
    end
    str.ecdys = ecdys;
    str.volAtEcdysis = volAtEcdysis;
    save(destpath, '-struct','str');
end

