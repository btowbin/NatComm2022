function [volAtEcdys] = computevolAtEcdys(vol, ecdys, strclass, fitwidth)
%[volAtEcdys] = computevolAtEcdys(vol, ecdys, strClass)
%   Detailed explanation goes here

if nargin == 3, fitwidth = 10; end

blank5 = nan(size(ecdys));
blank4 = blank5(:,1:4);

% compute volume at ecdysis
volAtEcdys = blank5;
w = fitwidth;

for l = 1:4
    if isfinite(ecdys(l+1))
        x = max(1,ecdys(l+1)-w+1):max(1,ecdys(l+1));
        xfilt = x;
        xfilt(strclass(xfilt) ~= 'w') = [];

        if (~isempty(xfilt))
            y = log(vol(xfilt));
            p = polyfit(xfilt, y, 1);
            volAtEcdys(l+1) = exp(polyval(p,ecdys(l+1)));    
        end
    end
end


% compute volume at hatch
if(isfinite(ecdys(1)))
    x = max(1,ecdys(1)):min(ecdys(1)+w, length(vol));
    xfilt = x;
    xfilt(strclass(xfilt) ~= 'w') = [];

    if (~isempty(xfilt))
        y = log(vol(xfilt));
        p = polyfit(xfilt, y, 1);    
        volAtEcdys(1) = exp(polyval(p,ecdys(1)));    
    end
end  

volAtEcdys(volAtEcdys==0)=NaN;







end

