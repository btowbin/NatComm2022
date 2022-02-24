function straighten_worms_flex(MaskPath, SourcePath, DestPath, spacing, overedge, strwidth, paralprc)
% straighten_worms(mainpath) loads all the files in the seg and raw subfolders
% of the main path, straightens the worms and saves the straightened raw
% and mask in straightened_raw and straightened_seg subfolders
%   Detailed explanation goes here

if paralprc
    
c=parcluster;
c.NumWorkers = str2num(getenv('SLURM_CPUS_PER_TASK'));
saveProfile(c);

parpool('local', str2num(getenv('SLURM_CPUS_PER_TASK')))

mkdir(DestPath);

% create folder for error reporting
errpath = fullfile(DestPath, 'error_reports');
mkdir(errpath);

if exist([errpath 'straightening_errors.txt'], 'file') == 0
 f = fopen( fullfile(errpath, 'straightening_errors.txt'), 'w' );  
 fclose(f);
else
    disp('File exists.');
end


maskFiles = dir(MaskPath);
sourceFiles = dir(SourcePath);


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



for k = 1:length(sourceFiles)
    flnm = sourceFiles(k).name;
    matchStr = regexp(flnm,'Time[0-9]+','match');
    if ~isempty(matchStr)
        t = str2double(matchStr{1}(5:end))+1;
        matchStr = regexp(flnm,'Point[0-9]+','match');
        if ~isempty(matchStr)
            s = str2num(matchStr{1}(6:end))+1;
                flnm_mappingSource(s,t) = k;  
        end
    end
end
flnm_mappingSource(flnm_mappingSource == 0) = NaN;

flnm_mappingSource(isnan(flnm_mappingMask)) = NaN;
flnm_mappingMask(isnan(flnm_mappingSource)) = NaN;




for s=1:size(flnm_mappingSource,1)
    parfor t = 1:size(flnm_mappingSource,2)
        try
            if isfinite(flnm_mappingMask(s,t))
                mask = imread(fullfile(MaskPath, maskFiles(flnm_mappingMask(s,t)).name));
                source = imread(fullfile(SourcePath, sourceFiles(flnm_mappingSource(s,t)).name));

                mask = bwareafilt(imfill(mask>0,'holes'),1);
                mask = (imerode(imdilate(mask,ones(3)),ones(3)));
                [xs ys] = getSpline(mask,spacing,overedge); % (mask,spacing,overedge,number of spline points)
                if xs>0
                    straightened = straighten(source, [ys; xs]', strwidth);
                    if (max(straightened(:) >1))
                        straightened = uint16(straightened);
                    else
                        straightened = uint8(bwareafilt(imfill(straightened>0,'holes'),1));
%                         straightened = uint8(straightened);

                    end
                    imwrite(straightened, fullfile(DestPath, sourceFiles(flnm_mappingSource(s,t)).name),'Compression','deflate');

                end
            end
        catch er

            erfl = fopen( fullfile(errpath, 'straightening_errors.txt'), 'a' );  
            formatSpec = 'error with file: %s\n';
            fprintf(erfl, formatSpec, maskFiles(flnm_mappingMask(s,t)).name);

            formatSpec = 'the error messsage was: %s\n';
            fprintf(erfl, formatSpec, er.message);

            formatSpec = 'the error identifier was: %s\n';
            fprintf(erfl, formatSpec, er.identifier);
            fprintf(erfl,'\n',' ');

            fclose(erfl);
        
        end
    end
end
   
delete(gcp);

else % if not with par processing

mkdir(DestPath);


% create folder for error reporting
errpath = fullfile(DestPath, 'error_reports');
mkdir(errpath);

if exist([errpath 'straightening_errors.txt'], 'file') == 0
 f = fopen( fullfile(errpath, 'straightening_errors.txt'), 'w' );  
 fclose(f);
else
    disp('File exists.');
end


maskFiles = dir(MaskPath);
sourceFiles = dir(SourcePath);


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



for k = 1:length(sourceFiles)
    flnm = sourceFiles(k).name;
    matchStr = regexp(flnm,'Time[0-9]+','match');
    if ~isempty(matchStr)
        t = str2double(matchStr{1}(5:end))+1;
        matchStr = regexp(flnm,'Point[0-9]+','match');
        if ~isempty(matchStr)
            s = str2num(matchStr{1}(6:end))+1;
                flnm_mappingSource(s,t) = k;  
        end
    end
end
flnm_mappingSource(flnm_mappingSource == 0) = NaN;

flnm_mappingSource(isnan(flnm_mappingMask)) = NaN;
flnm_mappingMask(isnan(flnm_mappingSource)) = NaN;




for s=1:size(flnm_mappingSource,1)
    for t = 1:size(flnm_mappingSource,2)
        try
            if isfinite(flnm_mappingMask(s,t))
                mask = imread(fullfile(MaskPath, maskFiles(flnm_mappingMask(s,t)).name));
                source = imread(fullfile(SourcePath, sourceFiles(flnm_mappingSource(s,t)).name));

                mask = bwareafilt(imfill(mask>0,'holes'),1);
                mask = (imerode(imdilate(mask,ones(3)),ones(3)));
                [xs ys] = getSpline(mask,spacing,overedge); % (mask,spacing,overedge,number of spline points)
                if xs>0
                    straightened = straighten(source, [ys; xs]', strwidth);
                    if (max(straightened(:) >1))
                        straightened = uint16(straightened);
                    else
                        straightened = uint8(bwareafilt(imfill(straightened>0,'holes'),1));
                    end
                    imwrite(straightened, fullfile(DestPath, sourceFiles(flnm_mappingSource(s,t)).name),'Compression','deflate');

                end
            end
        catch er

            erfl = fopen( fullfile(errpath, 'straightening_errors.txt'), 'a' );  
            formatSpec = 'error with file: %s\n';
            fprintf(erfl, formatSpec, maskFiles(flnm_mappingMask(s,t)).name);

            formatSpec = 'the error messsage was: %s\n';
            fprintf(erfl, formatSpec, er.message);

            formatSpec = 'the error identifier was: %s\n';
            fprintf(erfl, formatSpec, er.identifier);
            fprintf(erfl,'\n',' ');

            fclose(erfl);
        
        end
    end
end

    
end

end

