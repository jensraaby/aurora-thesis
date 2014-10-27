function [ E ] = robustmse( img1, img2, threshold, norm )
%RMSERROR Computes robust mean squared error between 2 images

% difference of the two images
dimg = img1 - img2;

% square the difference, find the mean:
MSE = mean(dimg(:).^2);

E = MSE;

% cut off any errors with threshold
E(MSE>threshold) = threshold;

% hist(dimg(:).^2,100);

% normalise by dividing by sum of original image intensity
if nargin>3 && norm == 1
    normconst = sum(img1(:));
    
    E = E/normconst;
end


end

