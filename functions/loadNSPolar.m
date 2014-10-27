function [ imgs, imgs_norm, names ] = loadNSPolar( path )
%loadNSPolar Returns 512x512xN matrix of N NS_Polar images in PATH or
%current folder
% n.b. the names are returned in a cell array

if nargin < 1
    path = '';
end
files = dir(fullfile(path,'*NS_Polar.mat'));

polar_images = cell(length(files),1);

imgs = zeros(512,512,length(polar_images));
names = {};

for file = 1:length(files)
    disp([files(file).name]);
    names{file} = files(file).name;
    
    polar_images{file} = files(file).name;
   
    img = load(fullfile(path,polar_images{file}));
    image = flipud(img.polar_image);
    
    imgs(:,:,file) = image(1:512,1:512);

end


if size(imgs,3) ~= 0
    
    % the counts should be scaled from 0 to 1 - subtract the current min to ensure
    % the min is 0
    imgs = imgs - repmat((min(imgs(:))),size(imgs));
%     max(imgs(:))

    % the max should be 1 

    % assume that the range is 8 bits (0-255)

    imgs_norm = (imgs)/255;
    % max(imgnorm(:))
else
    error('No images at path');
end

end

