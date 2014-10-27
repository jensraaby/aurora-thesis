function [ img2 ] = removedaylight( img )
%REMOVEDAYLIGHT Summary of this function goes here
%   Trying to remove the 50-60 degree region of the day side as it is not
%   relevant
    
% start with a rectangle
[M,N] = size(img);

circle_diameter = M-100;

top_of_circle = M/2 - (circle_diameter/2);

remove_pixels = circle_diameter/4;

% just remove the 25% at the top of the circle

% all across the image!
bg_intensity = img(1,1);

remove_mask = bg_intensity * ones(remove_pixels,N);

img2 = img;
img2(top_of_circle:top_of_circle+remove_pixels-1,:) = remove_mask;



end

