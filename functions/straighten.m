function worm = straighten(iminp, pixellist, strwidth)
%straighten2(iminp, pixellist,linedistIn, strwidth)

%   Detailed explanation goes here

strwidth=strwidth-1;

xsize = size(iminp,2);
ysize = size(iminp,1);


pixl1 = pixellist(:,1);
pixl2 = pixellist(:,2);


iminp2 = zeros(size(iminp, 1) + 2*strwidth);
iminp2(1:ysize, 1:xsize) = iminp;
imtr = imtranslate(iminp2, [strwidth strwidth]);

xsize = size(imtr,2);
ysize = size(imtr,1);
[X, Y] = meshgrid(1:xsize, 1:ysize);

pixl1 = pixl1+strwidth;
pixl2 = pixl2+strwidth;


xpoints = pixl1;
ypoints = pixl2;

x2 = xpoints(1);
y2 = ypoints(1);
pos = zeros(1,length(xpoints));
pos(1) = 0;
tempinterpim = zeros(strwidth+1, length(xpoints));
for i = 2:length(xpoints)
%     tic
    
    x1 = x2;
    y1 = y2;
    x2 = xpoints(i);
    y2 = ypoints(i);
%     toc
    dlx = x2-x1;
    dly = y1-y2;
    le = sqrt(dlx*dlx + dly*dly);
    dx = dly/le;
    dy=dlx/le;
    
    if dx == 0
        xeval = x1*ones(1, strwidth+1);
    else
    xeval = x1-(dx*strwidth/2):dx:x1+(dx*strwidth/2);
    end
    
    if dy == 0
        yeval = y1 *ones(1,strwidth+1);
    else
        yeval = y1-(dy*strwidth/2):dy:y1+(dy*strwidth/2);
    end
    

    zeval = qinterp2(X, Y, imtr, yeval,xeval, 2);

    
    tempinterpim(:,i) = zeval;
    pos(i) = pos(i-1)+le;
    
%     toc
end

worm = zeros(size(tempinterpim,1), ceil(pos(end)));

for i = 1:size(tempinterpim,1)
    temp = interp1(pos, tempinterpim(i,:), 1:size(worm,2));
    worm(i,:) = temp;
end

end

