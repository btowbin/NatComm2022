function [vol, len, strClass] = compute_worm_volume_flex(sourcepath,outputfile,BStrFilename, pixelsize)
%compute_worm_volume(mainpath) iterates over all images in mainpath and
%computes volume to save in variable vol
%   Detailed explanation goes here




% load image filenames
files = dir(sourcepath);

%load classifier (stored as a variable called BStr)
load(BStrFilename, 'BStr');

% check which files correspond to which time point and stage position
for k = 1:length(files)
    flnm = files(k).name;
    matchStr = regexp(flnm,'Time[0-9]+','match');
    if ~isempty(matchStr)
        t = str2num(matchStr{1}(5:end))+1;
        matchStr = regexp(flnm,'Point[0-9]+','match');
        if ~isempty(matchStr)
            s = str2num(matchStr{1}(6:end))+1;
                flnm_mapping(s,t) = k;  

        end
    end
end
flnm_mapping(flnm_mapping == 0) = NaN;


for s = 1:size(flnm_mapping,1)
    s
    for t = 1:size(flnm_mapping,2)
        if isfinite(flnm_mapping(s,t))
            flnm = files(flnm_mapping(s,t)).name;
            im = imread(fullfile(sourcepath, flnm));
            im = bwareafilt(imfill(im>0,'holes'),1);          
            vol(s,t) = sum(pi*(sum(im)/2).^2)*pixelsize^3;
            len(s,t) = sum(sum(im)>0)*pixelsize;
            temp = classifyWormType(im, BStr, pixelsize); %classifies as egg, worm, or mistake
            strClass(s,t) = temp;

        else
            vol(s,t) = NaN;
            len(s,t) = NaN;
            strClass(s,t) = NaN;
        end

    end
end

mkdir(fileparts(outputfile));
save(outputfile, 'vol','len','strClass');


end

