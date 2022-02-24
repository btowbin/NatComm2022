function [flnmmap] = createAndSaveFlnmMap(directory)
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here


if directory(end) == '\'
    [folder,name,~]=fileparts(fileparts(directory));
else
    [folder,name,~]=fileparts(directory);
end
filename = fullfile(folder, 'filename_maps', [name '_flnmMap.mat']);

flnmmap = createFileMapping(directory);
if ~exist(fullfile(folder,'filename_maps'))
   mkdir(fullfile(folder,'filename_maps')); 
end
save(filename, 'flnmmap');

end

