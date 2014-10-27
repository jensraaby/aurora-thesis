function [ E ] = rmserror( img1, img2, norm )
%RMSERROR Computes root mean squared error between 2 images

dimg = img1 - img2;

% normalise the error if argument specified
if nargin>2 && norm==1
    maxin = max(abs(img1(:))); 
    minin = min(abs(img1(:)));
    rangeerr = maxin-minin;
    
else
    rangeerr = 1;
end

% square the difference, find the mean:
E = sqrt(mean(dimg(:).^2))/rangeerr;


end

