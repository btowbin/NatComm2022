function createAllFileNameMaps(motherfolder)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
listing = dir(motherfolder)
for n=1:numel(listing)
    if isdir(fullfile(motherfolder, listing(n).name))
        if numel(listing(n).name)>1
        if listing(n).name(1:2) == 'ch'
            n
            createAndSaveFlnmMap(fullfile(motherfolder, listing(n).name));
        end
        end
    end
end
end

