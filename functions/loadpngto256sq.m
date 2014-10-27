function [ image,circlemask, timestamp] = loadpngto256sq( path, intensityscale )
%LOADPNGTO256SQ Summary of this function goes here
%   Load the ALL STEPS png at PATH and use it to generate a 256px image
%   scaled from 0 to 1 (double) intensity

if nargin <2
    intensityscale = 1;
end

% this is the horizontal position of the daylight removed polar plot
leftoffset = (256+5)*3 - 4;
rightoffset = leftoffset+255;

I_init = imread(path);
I_main = I_init(:,leftoffset:rightoffset);

% convert white pixels to a separate mask
circlemask = ones(size(I_main));
circlemask(I_main==255) = 0;


% now we can just remove the white pixels
I_main(I_main==255) = 0;


image = im2uint8(I_main*intensityscale);


% from the filename we should be able to get the date and time
pattern = '[a-z_]+VISE\d+[a-z_]*';

% get the filename on its own
[~,f] = fileparts(path);

% the conversion to a matlab serial datenum:
% this is a horrible format based on fractions of days
timestamp = vise_fname_to_datenum(f);


end

