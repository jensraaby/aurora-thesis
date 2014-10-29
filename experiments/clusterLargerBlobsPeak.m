clear
baseoutdir = '/Users/jens/Desktop/Aurora-Working/EventsClustering/';
featuresdir = '/Users/jens/Desktop/Aurora-Working/EventsProcessing';
% featuresdir = '/Users/jens/Desktop/Aurora-Working/EventsProcessingOval/'
savefile = 1;
fileversion = 5;
regenerate = 1;
prefix = '140402-';

subdir3pix = 'laplacianblobs3-105-35-eig'

%% Single Peak blob at 2. 90 scale fits
matsubdir = subdir3pix


nblobs = 1;
UsePosition = 1;
UseScale = 1;
UseEigenvalues = 0;
UseEigenvectors = 0;
UseMeanIntensity = 0;
UseFeatureStrength = 0;
OnsetInsteadofPeak = 0;

filterfun = 'biggest';
clear peakblob3pixbasic;
peakblob3pixbasic = BlobFeatures(featuresdir, nblobs, ...
                UsePosition, UseScale,UseEigenvalues,UseEigenvectors,...
                UseMeanIntensity,UseFeatureStrength,filterfun, OnsetInsteadofPeak,matsubdir);
            
ndims = peakblob3pixbasic.FeatureDimensions;
            
% not zero centred, but variance normalised
features = peakblob3pixbasic.getNormalisedFeatures(0);


%
outdir = fullfile(baseoutdir,'f-3px-blob-singlelargest');
mkdir(outdir);
if regenerate
    doClustering(outdir, peakblobsbasic, 1:15, 10, '1 peak blobs largest',1);
end
% regenerate = 0;
%
plotClustering(outdir, fileversion, savefile, prefix)


%% Single peak blob with feature strength
matsubdir = 'blur15-laplacianblobs2-105-50-eig'


nblobs = 1;
UsePosition = 1;
UseScale = 1;
UseEigenvalues = 0;
UseEigenvectors = 0;
UseMeanIntensity = 0;
UseFeatureStrength = 0;
OnsetInsteadofPeak = 0;

filterfun = 'strongest';
clear peakblobsbasicstrength peakblobsbasicbiggest peakblobsellipse;
peakblobsbasicstrength = BlobFeatures(featuresdir, nblobs, ...
                UsePosition, UseScale,UseEigenvalues,UseEigenvectors,...
                UseMeanIntensity,UseFeatureStrength,filterfun, OnsetInsteadofPeak,matsubdir);
            
ndims = peakblobsbasicstrength.FeatureDimensions;
            
% not zero centred, but variance normalised
features = peakblobsbasicstrength.getNormalisedFeatures(0);


%%
outdir = fullfile(baseoutdir,'f-blob-singlestrongest');
mkdir(outdir);
if regenerate
    doClustering(outdir, peakblobsbasicstrength, 1:15, 10, '1 peak blobs strongest',1);
end
% regenerate = 0;
%%
plotClustering(outdir, fileversion, savefile, prefix)

