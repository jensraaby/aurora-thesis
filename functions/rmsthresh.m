function [ E, errimg ] = rmsthresh( img1, img2, method, thresh )
%RMSTHRESH RMS error with a threshold
% IMG1 - original image
% IMG2 - reconstructed image
% METHOD - If method is not specified, or is 1, then we use 
%  mean + 2*std.deviation as a maximum on the squared error
% THRESH - If method is set to 2, and this parameter is set, we use it as a
% threshold on the squared error.


dimg = img1(:) - img2(:);
sq = dimg.^2;

% find the mean and std dev of squared error
MSE = mean(sq);
sigma = std(sq);


if nargin < 3
    method = 1;
end
% automatic thresholding:
% use
if method == 1   

    % filter out the errors that are above mean + 2 * stddev
    thresh = MSE + 2*sigma;
    bigerrind = find(sq>thresh);
    
    if nargin > 3
        disp('RMSTHRESH: Ignoring manual threshold')
    end
        
        
        
% manual thresholding
elseif method == 2
    if nargin < 4
        % in case we forgot to give a thresh
        disp('RMSTHRESH: Forgot threshold - using default');
        thresh = MSE + 2*sigma;
    end
    bigerrind = find(sq>thresh);
end

% now perform filtering
sq(bigerrind) = thresh;

% if we want to look at the errors themselves:
if nargout > 1
    errimg = reshape(sq,size(img1));
end

% find the mean, square root it:
E = sqrt(mean(sq));

end

