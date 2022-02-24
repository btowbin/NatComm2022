function [filenamemap] = createFileMapping(directory)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

files = dir2(directory);
if length(files) >10
    for k = 1:length(files)
        
                flnm = files(k).name;
                matchStr = regexp(flnm,'Time[0-9]+','match');
                if ~isempty(matchStr)
                    t = str2double(matchStr{1}(5:end))+1;
                    matchStr = regexp(flnm,'Point[0-9]+','match');
                    if ~isempty(matchStr)
                        s = str2num(matchStr{1}(6:end))+1;
                        filenamemap{s,t} = fullfile(files(k).folder, files(k).name);  
                    end
                end
    end
else
    filenamemap = NaN;
end
end

