function checkfortwoworms(InRerportFile, MaskPath, destfile, paralprc)


if paralprc
%     
% c=parcluster;
% c.NumWorkers = str2num(getenv('SLURM_CPUS_PER_TASK'));
% saveProfile(c);
% 
% parpool('local', str2num(getenv('SLURM_CPUS_PER_TASK')))


maskFiles = dir(MaskPath);


for k = 1:length(maskFiles)
    flnm = maskFiles(k).name;
    matchStr = regexp(flnm,'Time[0-9]+','match');
    if ~isempty(matchStr)
        t = str2double(matchStr{1}(5:end))+1;
        matchStr = regexp(flnm,'Point[0-9]+','match');
        if ~isempty(matchStr)
            s = str2num(matchStr{1}(6:end))+1;
                flnm_mappingMask(s,t) = k;  
        end
    end
end
flnm_mappingMask(flnm_mappingMask == 0) = NaN;

twoworms = zeros(size(flnm_mappingMask));



for s=1:size(flnm_mappingMask,1)
    s
    for t = 1:size(flnm_mappingMask,2)
            if isfinite(flnm_mappingMask(s,t))
                mask = imread(fullfile(MaskPath, maskFiles(flnm_mappingMask(s,t)).name)); %load image
                mask = bwareafilt(imfill(mask>0,'holes'),2,4); % keep two largest objects
                cc = bwconncomp(mask ,4); %size of objects

                if(cc.NumObjects>1) %if two objects
                    logsizeratio = abs(log(numel(cc.PixelIdxList{1})/numel(cc.PixelIdxList{2})));
                    twoworms(s,t) = exp(logsizeratio);
                    
                else
                    cc.NumObjects;
                end

            end

    end
end
tempdata = load(InRerportFile);
tempdata.tworms = twoworms(1:size(tempdata.vol,1),1:size(tempdata.vol,2)) ;
save(destfile, '-struct', 'tempdata');   
% delete(gcp);

else % if not with par processing
end

end

