function [ sample ] = getBlobPixels( I, blobc, blobr, blobscale )
%SAMPLEBLOBINTENSITY Summary of this function goes here
%   Detailed explanation goes here
    
    [r,c] = size(I);
    [Y, X] = meshgrid(1:r,1:c);

    % a circle mask with the radius:
    radius = floor(blobscale/2);
    [Y, X] = meshgrid(1:r,1:c);
    
    % this is a logical array
    circlepix = ((Y-blobr).^2 + (X-blobc).^2)<= radius.^2;
    
    sample = I(circlepix);
end

