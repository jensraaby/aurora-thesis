function [X,Y] = magnetic_to_pixels(mlat,mlt,imsize)
%%% [X,Y] = magnetic_to_pixels(mlat,mlt,imsize)


if nargin < 3
    imsize = 256;
end

% get the matrix for the whole image (basically each pixel's MLAT and MLT)
[mlatmat,mltmat] = generatepixelcoords(40, imsize);
[xs,ys] = meshgrid(1:imsize,1:imsize);


% just convert to actual lats instead of colat
mlatmat2 = abs(bsxfun(@minus,mlatmat,90));
% north pole is then at 90 degrees

% now, the MLAT could be many different places, so we need first to deal
% with the MLT.

mltdists = abs(mltmat-mlt);
[sortmltdists,idx] =  sort(mltdists(:));


% loop over the MLTs in order until we find an MLAT which matches well
for i=1:length(idx)
   
    j = idx(i);
    
    MLATguess = mlatmat2(j);
    
    
    if abs(MLATguess-mlat) < 0.9
%        disp('found candidate!')
%        MLATguess
%        mltmat(j)


       X = xs(j);
       Y = ys(j);
        break
    end
    
    
end