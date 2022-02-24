function BWfinal = segmentwormFromRAW(raw, pixelsize)
NF= raw;
FI = imgaussfilt(NF,1);

%find edges
[edges, threshold] = edge(FI, 'sobel');

%size filter edges (min 3)
edgesizfilt = bwareafilt(edges, [3 Inf]); %removes edges smaller than 3 pixels
out = edgesizfilt;

% find edge endpoints
endpoints = bwmorph(edgesizfilt, 'endpoints');
[edgeends_x edgeends_y] = find(endpoints);

% connect endpoints with nearest other endpoint
distancematrix = squareform(pdist([edgeends_x edgeends_y],'euclidean')); %compute all distances between all ends
distancematrix(find(distancematrix==0))=NaN; 

    [a b]=    min(distancematrix );
    for i = 1:size(a,2) % connect each edgend with nearest edgeend
        x1 = edgeends_x(i);
        y1 = edgeends_y(i);
        
        x2 = edgeends_x(b(i));
        y2 = edgeends_y(b(i));
        
        out=func_Drawline(out,x1, y1,x2,y2,1);
    end

    
     out = out(1:size(NF,1),1:size(NF,2)); % if edge at border of image func_Drawline makes image 1 pixel bigger. correct for that.
     
%      dilate erode to close remaining openings
     BWdil = imdilate(out, strel('disk',3));
     BWerod = imerode(BWdil , strel('disk',3));
     
    BWerodFill = imfillthresh5(BWerod, raw, 10 );
    BWerodFillSizeFilt = bwareafilt(BWerodFill,  [422.5/pixelsize.^2 Inf]);%keep only components ~1/3 as big as an egg
    
%     BWerodFillSizeFiltLabel = bwlabel(BWerodFillSizeFilt);
    %select brightest CC 
    CC = bwconncomp(BWerodFillSizeFilt,8);
        if CC.NumObjects >1 %if several objects select brightest
            temp = zeros(1,CC.NumObjects);
            for i = 1:CC.NumObjects
                temp(i) = sum(FI(CC.PixelIdxList{i}));
            end
            [a, b] = max(temp);
            CC.PixelIdxList = {CC.PixelIdxList{b}};
            CC.NumObjects=1;
        end
        


        if CC.NumObjects >0

            FCC = imfillthresh4( CC, NF , 5); % fill holes that are more than 5 standard deviations above background
            BWforThresh = CC2BW(size(NF),FCC); %convert pixellist to binary
            perim = bwperim(BWforThresh);

            BWaboveThr = NF>prctile((NF(find(perim))),30); 
            BWsizefilt  = bwareafilt(BWaboveThr,  [422.5/pixelsize.^2 Inf]);%keep only components ~1/3 as big as an egg

            BWfilled = imfill(BWsizefilt , 'holes');
            BWfinal = BWfilled;
            
        else
            BWfinal = zeros(size(raw));
        end
end