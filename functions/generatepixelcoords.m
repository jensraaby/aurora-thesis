function [mlat,mlt] = generatepixelcoords(maxlat, diameter)
% this function gives a matrix of MLT and MLAT for a polar projection
% centred at the north pole. note this is co-latitude since the pole rather
% than the equator is at MLAT=0. MLT is in hours and begins at the bottom
% of the polar projection, proceeding anticlockwise


% since pixels are not degrees, we make the grid in degrees
line = linspace(0,maxlat*2,diameter);

% get a grid of coords
[ys,xs] = meshgrid(line,line);
% shift all so the centre is maxlat
xs2 = bsxfun(@minus,xs,maxlat);
ys2 = bsxfun(@minus,ys,maxlat);

[mlon,mlat] = cart2pol(xs2,ys2);

% just need to convert the mlon to mlt
% direction, units and start position is wrong
mlt = rot90(mlon,2);
mlt = rad2deg(mlt);
mlt = (mlt/15);
% shift so start at 0, end at 24
mlt = bsxfun(@plus,mlt,12);



% note that to get proper mlat we need to subtract them all from 90
%so 0 becomes 90, 50 becomes 40 etc
end