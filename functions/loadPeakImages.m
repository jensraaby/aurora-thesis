function [imgs, imgs_norm, names,eventdirs] = loadPeakImages( rootpath )
% updated version of loadNSPolar for thesis images
% basically provides the same outputs, but uses the new file structure to
% get the information


    allfiles = getAllMatPaths(rootpath);
    subdir = 'mat';
    
    numevents = length(allfiles);
    if numevents == 0
        error('no events at path')
    end
    
    
    % set up the output variables
    imgs = zeros(256,256,numevents);
    imgs_norm = imgs;
    names = {numevents,1}; % cell because of varying length of names/maybe should use a struct?
    eventdirs = {numevents,1};
    for i = 1:numevents
       eventdir = allfiles{i}.dirname
       nfiles = length(allfiles{i}.files);

       names{i} = allfiles{i}.files(nfiles).name;
       peakpath = fullfile(eventdir,subdir,names{i});

       file = matfile(peakpath);
       imgs(:,:,i) = file.image256;
       eventdirs{i} = eventdir;
    end

    % we use mat2gray but set 255 to be the max intensity
    imgs_norm = mat2gray(imgs,[0 255]);



end