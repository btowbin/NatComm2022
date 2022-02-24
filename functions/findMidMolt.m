function [midmolt, sizemidmolt, hatchtime] = findMidMolt(vol,wormclass, sizerange)
%[midmolt, sizemidmolt] = findMidMolt(vol,wormclass, sizerange)
warning('off','all')
logsizerange = log(sizerange);


%find hatchtime
firstWorm = min(find(wormclass=='w'));
if isempty(firstWorm), firstWorm = NaN; end
firstEgg =  min(find(wormclass=='e'));
if isempty(firstEgg), firstEgg = NaN; end

if isfinite (firstWorm)
    lastEgg = max(find(wormclass(1:firstWorm)=='e'));
else
    lastEgg = NaN;
end

if (isfinite(lastEgg))
    hatchtime = lastEgg+1;
else
    hatchtime = NaN;
    lastEgg = 0;
end

   
%************* find beginning and end of molt using strvolume_corr


% define regions with valid volume for molt detection
simvol = vol;

simvol(find(wormclass~='w'))=NaN;


if hatchtime>0
    simvol(1:hatchtime-1) = NaN;
end

% exclude anything after a gap of >5
for t = max(hatchtime,1):numel(simvol)
    checkperiod = t:min(t+10, numel(simvol));
    if isfinite(checkperiod)
        if sum(isfinite(simvol(checkperiod)))<5
            simvol(t:end) = NaN;
        end
    end
end
% simvol

endmolt = nan(1,4);
medfiltvol = nan(size(vol));
medfiltvol = medfilt1(simvol,3,'omitnan', 'truncate');
medfiltlogvol = log(medfiltvol);
logdiff=diff(log(medfiltlogvol),1,2);
logdiff(logdiff == 0) = NaN;

smoothlogdiff= abs(movmean(movmean(logdiff,25,'omitnan'),10));
sizemidmolt= nan(1,4);

grwidth = 5;

    [~, locs]=findpeaks(-smoothlogdiff,'MinPeakProminence',(1e-5));
    locs(find(locs<=grwidth))=[];

    LogVolAtPeak = log(medfiltvol( locs));
    selectedpkids = nan(1,4);

    for l = 1:4
        difftoset = abs(LogVolAtPeak-logsizerange(l));

        possiblePeaks = find (abs(difftoset) < log(1.5));
        gr_temp = nan(size(locs,2),1);

        for n = possiblePeaks
            x = (locs(n)-grwidth:locs(n)+grwidth);%.*validTPs(s,(locs(n)-grwidth:locs(n)+grwidth));
            x=x(find(isfinite(x)));
            x(find(x>length(simvol)|x<1))=[];
            p = polyfit(x(isfinite(simvol(x))), log(simvol(x(isfinite(simvol(x))))),1);
            gr_temp(n) = p(1);
        end

        [a b] = min(gr_temp);
%         [a b] = min(possiblePeaks);

        if isfinite(a)
            selectedpkids(l) = b;
        else
            selectedpkids(l) = NaN;
        end

    end

    selectedlocs = nan(1,4);
    validpkids = find(~isnan(selectedpkids));
    selectedlocs(validpkids) = locs(selectedpkids(validpkids));

    for l = 4:-1:2
        if(isfinite(selectedlocs(l)) & isfinite(selectedlocs(l-1)))
            if selectedlocs(l) - selectedlocs(l-1) < 6
                selectedlocs(l) = NaN;
            end
        end
    end

midmolt = nan(1,4);
midmolt(validpkids) = selectedlocs(validpkids);
if sum(isfinite([hatchtime midmolt])) <2
    midmolt = nan(1,4);
    hatchtime = NaN;
end

sizemidmolt(find(isfinite(midmolt))) =  exp(medfiltlogvol(midmolt(find(isfinite(midmolt)))));

end
