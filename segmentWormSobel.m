function segmentWormSobel(sourcedir, destdir, pixelsize, paralprc);
%UNTITLED4 [worm] = segmentWormWithEdge(basefilename,datapath, focalplane)
%   Detailed explanation goes here

if paralprc
    
c=parcluster;
c.NumWorkers = str2num(getenv('SLURM_CPUS_PER_TASK'));
saveProfile(c);

parpool('local', str2num(getenv('SLURM_CPUS_PER_TASK')))

% create folders for segmentation
rawpath = sourcedir;
segpath = destdir;
mkdir(segpath);

% create folder for error reporting
errpath = fullfile(destdir, 'error_reports/');
mkdir(errpath);

if exist(fullfile(errpath, 'segmentation_errors.txt'), 'file') == 0
 f = fopen( fullfile(errpath, 'segmentation_errors.txt'), 'w' );  
 fclose(f);
else
    disp('File exists.');
end


raw_filenames = dir(rawpath);


parfor i = 1:length(raw_filenames)
    try
    [~,raw_name,ext] = fileparts(raw_filenames(i).name);
    if isequal(ext,'.tif') | isequal(ext,'.tiff')
        full_raw_filename = fullfile(rawpath, [raw_name ext]);
        raw = imread(full_raw_filename);
        seg = segmentwormFromRAW(raw, pixelsize)
        
            imwrite(uint8(seg), fullfile(segpath, ['seg_' raw_name ext]),'Compression','deflate');
            
    end
    catch er
  
        erfl = fopen( [errpath 'straightening_errors.txt'], 'a' );
        formatSpec = 'error with file: %s\n';
        fprintf(erfl, formatSpec, raw_filenames(i).name);
        
        formatSpec = 'the error messsage was: %s\n';
        fprintf(erfl, formatSpec, er.message);
                
        formatSpec = 'the error identifier was: %s\n';
        fprintf(erfl, formatSpec, er.identifier);
        fprintf(erfl,'\n',' ');
        
        fclose(erfl);
        
    end
end
delete(gcp);

else
  
end


