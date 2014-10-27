% function [polar] = cartesian2polar(cartim, polarsize, startdeg, finishdeg)

% default angles
% if (nargin < 3)
    startdeg = 360;
    finishdeg = 0;
% end
cartim = canvas;
polarsize = 512;


[radius,angular_resolution] = size(cartim);
% size of output is square
M = polarsize
N = M

% determine origin - this is where the center of the polar plot is
midY = (M+1)/2;
midX = (N+1)/2;

% get all the radii lengths (assuming we want the whole image):
radii = linspace(0,midX,midX);

% get all the angles needed for this resolution:
theta = linspace(deg2rad(startdeg),deg2rad(finishdeg),resolution);

% get all the polar coordinates needed:
% NB you can swap order here to get a 'vertical' orientation!
% [th,r] = meshgrid(theta,radii); *)

% generate coordinates grid
[Y,X] = meshgrid(1:radius,1:angular_resolution);

% now interpolate the input image with these coordinates

% get the polar coordinates:
[th,r] = cart2pol(X,Y);
% convert to xy coordinates in the polar image


% shift so the coordinates are not centred on the image
%X_ = bsxfun(@plus, X, midY);
%Y_ = bsxfun(@plus, Y, midX);

% interpolate image with the new coordinates:

polar = interp2(polarim,X_,Y_,'linear',0);
