function [] = detectBlobs50scalesAllblurfirst()
% fitellipses

workingevents = '/Users/jens/Desktop/Aurora-Working/EventsProcessing/';
initialscale = 2;  
intensitytransform = 4.3;
numscales = 50;   
thres = 0.1;
growthrate = 1.05;

blobsdirname = 'blur15-laplacianblobs2-105-50-eig';

% define functions for detecting blobs and processing each event
blobhandle = @(eventstruct,outdir,fname) blobs(eventstruct, fname, outdir, ...
    initialscale, numscales, thres,intensitytransform,growthrate,blobsdirname);
eventhandle = @(x) processEvent2mat(blobhandle, x,'mat',blobsdirname,1);

% actually execute here:
batchProcessEvents(eventhandle,workingevents,1);

end

function [tosave] = blobs(data, fname, outdir, initialscale, numscales, ...
                           thres,intensitytransform,growthrate,blobsdirname)
% this is the actual function for processing a single image
im = data.image256 * intensitytransform;

% improve image with a small blur
imblur = real(ifft2(scale(fft2(im),1.5,0,0)));

% this is the big computation - may take a 0.5 secs to run per image!
[ blobs, scales, strengths, ~, meanintensities, eigenvals,eigenvecs ] = ...
          detectBlobs( imblur, initialscale, numscales, thres, 0, growthrate );

numblobs = length(strengths);

% now remove the dayside blobs
[dayside, alllats, alltimes] = filterDayside(blobs,size(im,1));
alllats(dayside,:) = [];
alltimes(dayside,:) = [];
blobs(dayside,:) = [];
strengths2 = strengths;
strengths2(dayside) = [];
eigenvals(dayside,:) = [];
eigenvecs(dayside,:) = [];
meanintensities(dayside) = [];

numblobs = length(strengths2);

% this is the output per row:
% r,c,s,mlat,mlt,strength,intensity,eigenvals(2), eigenvecs(4)
blobsStats = zeros(numblobs,13);

% surely this can be vectorised?
% for b = 1:numblobs
% %     [ maxint, totalint, meanint ] = sampleBlobIntensity(im,blobs(b,1),blobs(b,2),blobs(b,3));
%     
%     % we don't want max intensity. the hessian would be far more
%     % interesting. Mean intensity can be approximated by the intensity in
%     % the Gaussian scaled image
% %     if b==81
% %     size(blobs)
% %     size(all
% %     end
%     c = [blobs(b,1:3), alllats(b), alltimes(b), strengths2(b), meanintensities(b), eigenvals(b,:), eigenvecs(b,:)];
%     blobsStats(b,:) = c;
% end
 b = 1:numblobs;
 blobsStats(b,:) = [blobs(b,1:3), alllats(b), alltimes(b), strengths2(b), meanintensities(b), eigenvals(b,:), eigenvecs(b,:)];


% sort the blobs by feature strength, then scale, then mean intensity

[B, sortidx] = sortrows(blobsStats,[ -6 -3 -7]);

h = plotBlobsImage(im,B,0,fullfile(outdir,blobsdirname),fname);

tosave = struct('blobsData',B,'initialscale',initialscale,...
    'numscales',numscales,'thres',thres,...
    'intensitytransform',intensitytransform);
close(h);
end


