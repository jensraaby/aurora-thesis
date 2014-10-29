% this version adds a larger scale
function [] = saveAllBlobs()
workingevents = '/Users/jens/Desktop/Aurora-Working/EventsProcessing/';

blobsdirname = 'laplacianblobsV2';
initialscale = 1.2;  
intensitytransform = 4.3;
numscales = 35;   
thres = 0.5;

bigscales = [ 20, 25, 30, 35];


matfiles = getAllMatPaths(workingevents);
numevents=length(matfiles);
disp(['Events to process:' num2str(numevents)]);


% process each event
for eventid = 1:numevents
    
disp(['Doing event' num2str(eventid) ' of ' num2str(numevents)]);
    eventdir = matfiles{eventid}.dirname
    
    if ~isdir(fullfile(eventdir,blobsdirname))
        disp('Creating blobs dir');
        mkdir(eventdir,blobsdirname);
    end
    
    processEvent(matfiles{eventid},blobsdirname,initialscale, numscales, thres,intensitytransform, bigscales);
   
end


end


% this function will detec the blobs for each image in an event
function  processEvent(eventstruct,blobsdirname,initialscale, numscales, thres,intensitytransform, largescales)
    numfiles = length(eventstruct.files);
    fileslist = eventstruct.files;
    outdir = fullfile(eventstruct.dirname,blobsdirname);
    test = 0;
    
    for imid = 1:numfiles
       data = matfile(fullfile(eventstruct.dirname,'mat',fileslist(imid).name));
       % we should have image256, reltime and timestamp
       im = data.image256 * intensitytransform;
       [blobs, scales, strengths] = detectBlobs(im, initialscale, numscales, thres, 0);
       
       % sort the blobs by strength
       strengthsort = [blobs, strengths];
       strengthsort = sortrows(strengthsort,[-4]);
       
       % also save the largest scale blobs
       [blobsBig, scalesBig, strengthsBig] = detectBlobs(im, [1,largescales], 0, thres, 0);
        numbig = length(strengthsBig);
        
       
        numblobs = size(blobs,1);
        numbig = length(strengthsBig);
        if test==1
            disp(['Initial blobs: ' num2str(numblobs)]);
            disp(['Initial big blobs: ' num2str(numbig)]);
            
            disp('strengths')
            strengthsort(1:3,4)
            
            if numbig>0
                % sort the blobs by strength
                bigstrengthsort = [blobsBig, strengthsBig];
                bigstrengthsort = sortrows(bigstrengthsort,[-4]);
                
                disp('big strengths')
                bigstrengthsort(:,4)
            end
            
            %            disp('\n scales')
            %            unique(blobs(:,3))
        end
       
       
       % now remove the dayside blobs
       [dayside, alllats, alltimes] = filterDayside(blobs,size(im,1));
              alllats(dayside,:) = [];
              alltimes(dayside,:) = [];
              blobs(dayside,:) = [];
       if test==1
           disp(['Blobs on night side: ' num2str(length(blobs))]);
       end
       %        % filter all the blobs that were detected at min scale
       minscale = find(blobs(:,3) == scales(2));
%               minscale = [ minscale; find(blobs(:,3) == scales(3))];
%        blobs(minscale,:) = [];
       %        alllats(minscale,:) = [];
       %        alltimes(minscale,:) = [];
       %
       if test==1
           disp('')
           disp(['Blobs at min scale: ' num2str(length(minscale))]);
           disp(['Remaining blobs: ' num2str(length(blobs))]);
       end
       
       % this is our main struct
       blobsStats = zeros(length(blobs),9);
       
       for b = 1:length(blobs)
           [ maxint, totalint, meanint ] = sampleBlobIntensity(im,blobs(b,1),blobs(b,2),blobs(b,3));
           
           blobsStats(b,:) = [blobs(b,1:3), strengths(b), maxint, totalint, meanint, alllats(b), alltimes(b)];
           
       end
       
       
       if numbig > 0
           % deal with the larger blobs
           [biglats,bigtimes] = getMagneticCoords(blobsBig,size(im,1));
       
           blobsStatsBig = zeros(numbig,9);
           
           for b= 1:numbig
               [ maxint, totalint, meanint ] = sampleBlobIntensity(im,blobsBig(b,1),blobsBig(b,2),blobsBig(b,3));
               blobsStatsBig(b,:) = [blobsBig(b,1:3), strengthsBig(b), maxint, totalint, meanint, biglats(b), bigtimes(b)];
           end
           
           
           blobsStats = [ blobsStats; blobsStatsBig];
       end
       
   

         % sort the blobs by strength (intensity in the normalised laplacian)
        % then by scale
        
        % really should filter out dayside (09 to 15) where mlat<60
       [B, sortidx] = sortrows(blobsStats,[ -4 -3 ]);
       plotBlobsImage(im,B,0,outdir,['2blob' fileslist(imid).name]);
        
       
       saveBlobs(outdir,fileslist(imid).name, B, initialscale, numscales,...
                                 thres,intensitytransform, largescales);
    end
end

% function to save the blob data to disk
function [] = saveBlobs(outdir, fname, blobsData,initialscale, numscales, ...
                                    thres,intensitytransform, largescales)
    fnamefull = fullfile(outdir,fname);
    save(fnamefull,'blobsData','initialscale','numscales','thres','intensitytransform','largescales'); 

end


function [lats,times] = getMagneticCoords(blobs,diameter)
  % we convert all coords to MLAT and MLT
    [mlat,mlt] = generatepixelcoords(50, diameter);
  
    ind = sub2ind([diameter, diameter], blobs(:,1), blobs(:,2));
    % get all the lats
    lats = 90 - mlat(ind); % note colat to lat
    times = mlt(ind);
end

function [idx, lats,times] = filterDayside(blobs,diameter)
    [lats,times] = getMagneticCoords(blobs,diameter);
    
    % day is between 06:00 and 18:00
    idxDay = find(times >= 6 & times <= 18);

    % we might get something on dayside close to the middle
    % so we'll find them too: anything with colat < 60 is good
    idxDayLowLat = find(lats<70);
    
    % nightside toofar out
    idxNight = setxor(idxDay,1:length(blobs));
    idxNightTooLow = intersect(find(lats<50),idxNight);
    
    % just select the ones which are in both sets
    idxDay = intersect(idxDay, idxDayLowLat);
    idx = union(idxDay, idxNightTooLow);
end