function [] = saveAllBlobs()
workingevents = '/Users/jens/Desktop/Aurora-Working/EventsProcessing/';

blobsdirname = 'laplacianblobs';
initialscale = 1.1;  
intensitytransform = 4.3;
numscales = 35;   
thres = 0.5;


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
    
    processEvent(matfiles{eventid},blobsdirname,initialscale, numscales, thres,intensitytransform);
   
end


end


% this function will detec the blobs for each image in an event
function  processEvent(eventstruct,blobsdirname,initialscale, numscales, thres,intensitytransform)
    numfiles = length(eventstruct.files);
    fileslist = eventstruct.files;
    outdir = fullfile(eventstruct.dirname,blobsdirname);
    test = 0;
    
    for imid = 1:numfiles
       data = matfile(fullfile(eventstruct.dirname,'mat',fileslist(imid).name));
       % we should have image256, reltime and timestamp
       im = data.image256 * intensitytransform;
       [blobs, scales] = detectBlobs(im, initialscale, numscales, thres, 0);
       
       numblobs = size(blobs,1);
       if test==1
           disp(['Initial blobs: ' num2str(numblobs)]);
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
%        minscale = [ minscale; find(blobs(:,3) == scales(3))];
%        blobs(minscale,:) = [];
%        alllats(minscale,:) = [];
%        alltimes(minscale,:) = [];
%        
if test==1
       disp(['Blobs at min scale: ' num2str(length(minscale))]);
       disp(['Remaining blobs: ' num2str(length(blobs))]);
end
      
       
       blobsStats = zeros(length(blobs),8);
       
        for b = 1:length(blobs)
            [ maxint, totalint, meanint ] = sampleBlobIntensity(im,blobs(b,1),blobs(b,2),blobs(b,3));
       
            blobsStats(b,:) = [blobs(b,1:3), maxint, totalint, meanint, alllats(b), alltimes(b)];

        end
        
        % sort the blobs by intensity then size
        
        % really should filter out dayside (09 to 15) where mlat<60
        
        [B, sortidx] = sortrows(blobsStats,[ -3 -6 ]);
       plotBlobsImage(im,B,0,outdir,fileslist(imid).name);
        
       
       saveBlobs(outdir,fileslist(imid).name, B, initialscale, numscales,...
                                 thres,intensitytransform);
    end
end

% function to save the blob data to disk
function [] = saveBlobs(outdir, fname, blobsData,initialscale, numscales, ...
                                    thres,intensitytransform)
    fnamefull = fullfile(outdir,fname);
    save(fnamefull,'blobsData','initialscale','numscales','thres','intensitytransform'); 

end

