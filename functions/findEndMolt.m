function endmolt = findEndMolt(vol,midmolt, hatchtime, wormclass, searchWidth, fitWidth)
%findEndMolt(vol,midmolt, hatchtime, wormclass, searchWidth, fitWidth)
%   Detailed explanation goes here

simvol = vol;
simvol(find(wormclass~='w'))=NaN;
if hatchtime>0
    simvol(1:hatchtime-1) = NaN;
end
medfiltvol = medfilt1(simvol,3,'omitnan', 'truncate');
medfiltlogvol = log(medfiltvol);
logdiff=diff(log(medfiltlogvol),1,2);
logdiff(logdiff == 0) = NaN;
smoothlogdiff= abs(movmean(movmean(logdiff,25,'omitnan'),10));



for l = 1:4
        searchwindow = max(1,midmolt(l)-searchWidth):min(length(vol),midmolt(l)+searchWidth);
        slope1 = nan(1,length(medfiltlogvol));, slope2 = slope1;

        if isfinite(searchwindow) &isfinite(midmolt(l))

            for h = searchwindow
                
%               split search window into two regions (reg1 and reg2)
                reg1 = intersect(find(isfinite(medfiltlogvol)),h-fitWidth:h-1);
                reg2 = intersect(find(isfinite(medfiltlogvol)),h+1:h+fitWidth);
                
                %compute slope in reg2
                if isfinite(reg2)
                    y = medfiltlogvol(reg2);
                    x = [ones(size(reg2));(reg2-reg2(1))];
                else
                    y = medfiltlogvol(reg2);
                    x = [ones(size(reg2));reg2-h];
                end

                [b,~,~] = regress(y',x');
                if (h>0), slope2(h)= b(2);end

                %compute slope in reg1
                if isfinite(reg1)
                    y = medfiltlogvol(reg1)';
                    x = [ones(size(reg1));reg1-reg1(1)]';
                else
                    y = medfiltlogvol(reg1)';
                    x = [ones(size(reg1));reg1-h]';
                end
                [b,~,~] = regress(y,x);
               if (h>0),  slope1(h)  = b(2);end
            end
            
            %difference between slope in reg1 and slope in reg2 (second
            %derivative)
            
            secondDerivative = slope2-slope1;
            [a, b] = max(secondDerivative);
                 
            if isfinite(a)
                
                p = polyfit(max(1,b-4):min(b+4,length(vol)), secondDerivative(max(1,b-4):min(b+4,length(vol))),2);
                [~, indmax] = max(polyval(p,max(1,b-4):min(b+4,length(vol))));
                temp = max(1,b-4)-1+indmax;
                
                endmolt(l) = temp;
            else
                endmolt(l) = NaN;
            end
            
        else
            endmolt(l) = NaN;
        end
        
end
    
end




