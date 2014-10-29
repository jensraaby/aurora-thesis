function [ hessians ] = buildHessiansMultiScale( image, scalesvector, normalise )
%BUILDHESSIANSMULTISCALE Build a hessian matrix for each of the scales in
%SCALESVECTOR. These are stacked in a 3D matrix.
%   Detailed explanation goes here

if nargin < 3
    normalise = 0;
end

hessians = zeros(numel(image),3,length(scalesvector));

 for s=1:length(scalesvector)
     
     % get the n x 4 matrix for this scale and normalise
     if normalise == 1
        hessians(:,:,s) = scalesvector(s)^2 * im2hessian( image, scalesvector(s));
     else
        hessians(:,:,s) = im2hessian( image, scalesvector(s));
     end
     
 end
 
 
end

