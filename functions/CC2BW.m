function image = CC2BW( Imsize, CC)
%UNTITLED image = CC2BW( Imsize, CC)
%  Imsize is a 2-dim array [w l]
% CC is a list of pixel indexes.
tempBW = false(Imsize);
tempBW(CC) = true;
image = tempBW;
end

