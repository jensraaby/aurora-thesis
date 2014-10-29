clear
baseoutdir = '/Users/jens/Desktop/Aurora-Working/EventsClustering/';


featuresdir = '/Users/jens/Desktop/Aurora-Working/EventsProcessing';
savefile = 1;
fileversion = 2;
regenerate = 1;
prefix = '140319-';

%% Ellipse and blobs together!
clear peakblobsellipse

nblobs = 5;
UsePosition = 1;
UseScale = 1;
UseEigenvalues = 2;
UseEigenvectors = 1;
UseMeanIntensity = 1;
UseFeatureStrength = 1;
OnsetInsteadofPeak = 0;
peakblobsellipse = EllipseBlobFeatures(featuresdir, nblobs, ...
                UsePosition, UseScale,UseEigenvalues,UseEigenvectors,...
                UseMeanIntensity,UseFeatureStrength,OnsetInsteadofPeak);
            
ndims = peakblobsellipse.FeatureDimensions;
            
% not zero centred, but variance normalised
features = peakblobsellipse.getNormalisedFeatures(0);

% peakblobsellipse.plotEventFeatures(1)
%
outdir = fullfile(baseoutdir,'5blobs+ellipse');
mkdir(outdir)
if regenerate
    doClustering(outdir, peakblobsellipse, 1:15, 10, 'Ellipse and 5 peak blobs with eigenvectors and eigenvalues',1);
end
plotClustering(outdir, fileversion, savefile, prefix)

%% First experiment = 5 basic blobs with intensity 
nblobs = 5;
UsePosition = 1;
UseScale = 1;
UseEigenvalues = 0;
UseEigenvectors = 0;
UseMeanIntensity = 1;
UseFeatureStrength = 0;
peakblobs= BlobFeatures(featuresdir, nblobs, ...
                UsePosition, UseScale,UseEigenvalues,UseEigenvectors,...
                UseMeanIntensity,UseFeatureStrength,OnsetInsteadofPeak);
            
ndims = peakblobs.FeatureDimensions;
            
% not zero centred, but variance normalised
features = peakblobs.getNormalisedFeatures(0);

outdir = fullfile(baseoutdir,'5basicblobs');
if regenerate
    doClustering(outdir, peakblobs, 1:15, 10, '5 peak blobs basic',1);
end
plotClustering(outdir, fileversion, savefile, prefix)
%% First experiment = 5 basic blobs with intensity and feature strength
nblobs = 5;
UsePosition = 1;
UseScale = 1;
UseEigenvalues = 0;
UseEigenvectors = 0;
UseMeanIntensity = 1;
UseFeatureStrength = 1;
peakblobs= BlobFeatures(featuresdir, nblobs, ...
                UsePosition, UseScale,UseEigenvalues,UseEigenvectors,...
                UseMeanIntensity,UseFeatureStrength,OnsetInsteadofPeak);
            
ndims = peakblobs.FeatureDimensions;
            
% not zero centred, but variance normalised
features = peakblobs.getNormalisedFeatures(0);

outdir = fullfile(baseoutdir,'5basicblobs+featurestrength');
if regenerate
    doClustering(outdir, peakblobs, 1:15, 10, '5 peak blobs with feature strength',1);
end
plotClustering(outdir, fileversion, savefile, prefix)

% 5 blobs with eigenvalue ratio
nblobs = 5;
UsePosition = 1;
UseScale = 1;
UseEigenvalues = 1;
UseEigenvectors = 0;
UseMeanIntensity = 1;
UseFeatureStrength = 1;
peakblobs= BlobFeatures(featuresdir, nblobs, ...
                UsePosition, UseScale,UseEigenvalues,UseEigenvectors,...
                UseMeanIntensity,UseFeatureStrength);
            
ndims = peakblobs.FeatureDimensions;
            
% not zero centred, but variance normalised
features = peakblobs.getNormalisedFeatures(0);

outdir = fullfile(baseoutdir,'5blobs+eigenratio+featurestrength');

if regenerate
doClustering(outdir, peakblobs, 1:15, 10, '5 peak blobs with eigenratio and feature strength',1);
end

plotClustering(outdir, fileversion, savefile, prefix)


% 5 blobs with eigenvalues themselves
nblobs = 5;
UsePosition = 1;
UseScale = 1;
UseEigenvalues = 2;
UseEigenvectors = 0;
UseMeanIntensity = 1;
UseFeatureStrength = 1;
peakblobs= BlobFeatures(featuresdir, nblobs, ...
                UsePosition, UseScale,UseEigenvalues,UseEigenvectors,...
                UseMeanIntensity,UseFeatureStrength);
            
ndims = peakblobs.FeatureDimensions;
            
% not zero centred, but variance normalised
features = peakblobs.getNormalisedFeatures(0);

outdir = fullfile(baseoutdir,'5blobs+eigenvalues+featurestrength');

if regenerate
doClustering(outdir, peakblobs, 1:15, 10, '5 peak blobs with pure eigenvalues',1);
end

plotClustering(outdir, fileversion, savefile, prefix)


%% 5 blobs with eigenvalues and eigenvectors
nblobs = 5;
UsePosition = 1;
UseScale = 1;
UseEigenvalues = 2;
UseEigenvectors = 1;
UseMeanIntensity = 1;
UseFeatureStrength = 1;
peakblobs= BlobFeatures(featuresdir, nblobs, ...
                UsePosition, UseScale,UseEigenvalues,UseEigenvectors,...
                UseMeanIntensity,UseFeatureStrength);
            
ndims = peakblobs.FeatureDimensions;
            
% not zero centred, but variance normalised
features = peakblobs.getNormalisedFeatures(0);

outdir = fullfile(baseoutdir,'5blobs+fulleigen+featurestrength');
if regenerate
    doClustering(outdir, peakblobs, 1:15, 10, '5 peak blobs with eigenvectors and eigenvalues',1);
end
plotClustering(outdir, fileversion, savefile, prefix)

%% 10 blobs with eigenvalues and eigenvectors
nblobs = 10;
UsePosition = 1;
UseScale = 1;
UseEigenvalues = 2;
UseEigenvectors = 1;
UseMeanIntensity = 1;
UseFeatureStrength = 1;
peakblobs= BlobFeatures(featuresdir, nblobs, ...
                UsePosition, UseScale,UseEigenvalues,UseEigenvectors,...
                UseMeanIntensity,UseFeatureStrength);
            
ndims = peakblobs.FeatureDimensions;
            
% not zero centred, but variance normalised
features = peakblobs.getNormalisedFeatures(0);

outdir = fullfile(baseoutdir,'10blobs+fulleigen+featurestrength');

if regenerate
    doClustering(outdir, peakblobs, 1:15, 10, '10 peak blobs with eigenvectors and eigenvalues',1);
end
plotClustering(outdir, fileversion, savefile, prefix)


% 10 blobs and eigen ratio and feature strength

nblobs = 10;
UsePosition = 1;
UseScale = 1;
UseEigenvalues = 1;
UseEigenvectors = 0;
UseMeanIntensity = 1;
UseFeatureStrength = 1;
peakblobs= BlobFeatures(featuresdir, nblobs, ...
                UsePosition, UseScale,UseEigenvalues,UseEigenvectors,...
                UseMeanIntensity,UseFeatureStrength);
            
ndims = peakblobs.FeatureDimensions;
            
% not zero centred, but variance normalised
features = peakblobs.getNormalisedFeatures(0);

outdir = fullfile(baseoutdir,'10blobs+eigenratio+featurestrength');

if regenerate
    doClustering(outdir, peakblobs, 1:15, 10, '10 peak blobs with ratio of eigenvalues',1);
end
plotClustering(outdir, fileversion, savefile, prefix);

% Onset single blob

nblobs = 1;
UsePosition = 1;
UseScale = 1;
UseEigenvalues = 1;
UseEigenvectors = 0;
UseMeanIntensity = 1;
UseFeatureStrength = 1;
onsetblobs = BlobFeatures(featuresdir, nblobs, ...
                UsePosition, UseScale,UseEigenvalues,UseEigenvectors,...
                UseMeanIntensity,UseFeatureStrength,1);
            
ndims = onsetblobs.FeatureDimensions;
            
% not zero centred, but variance normalised
features = onsetblobs.getNormalisedFeatures(0);

outdir = fullfile(baseoutdir,'1onsetblob');

if regenerate
    doClustering(outdir, onsetblobs, 1:15, 10, '1 onset blob with ratio of eigenvalues',1);
end
plotClustering(outdir, fileversion, savefile, prefix);

%% Onset single blob with full feature set

nblobs = 1;
UsePosition = 1;
UseScale = 1;
UseEigenvalues = 2;
UseEigenvectors = 1;
UseMeanIntensity = 1;
UseFeatureStrength = 1;
onsetblobs = BlobFeatures(featuresdir, nblobs, ...
                UsePosition, UseScale,UseEigenvalues,UseEigenvectors,...
                UseMeanIntensity,UseFeatureStrength,1);
            
ndims = onsetblobs.FeatureDimensions;
            
% not zero centred, but variance normalised
features = onsetblobs.getNormalisedFeatures(0);

outdir = fullfile(baseoutdir,'1onsetblob+fulleigens');

if regenerate
    doClustering(outdir, onsetblobs, 1:15, 10, '1 onset blob with eigenvalues and eigenvectors',1);
end
plotClustering(outdir, fileversion, savefile, prefix);
%% Peak ellipse fits
% note updated to new version!

 peakellipses = EllipseFeature(featuresdir,1);
 ndims = peakellipses.FeatureDimensions;
 features = peakellipses.getNormalisedFeatures(0);
outdir = fullfile(baseoutdir,'peakellipses');
mkdir(outdir);
if regenerate
    doClustering(outdir, peakellipses, 1:15, 10, 'Ellipse fits to peak auroral oval',1);
end
%%
plotClustering(outdir, fileversion, savefile, prefix);
