clear
baseoutdir = '/Users/jens/Desktop/Aurora-Working/EventsClustering/';
featuresdir = '/Users/jens/Desktop/Aurora-Working/EventsProcessing';

savefile = 1;
fileversion = 5;
regenerate = 1;
prefix = '140404-';

%% 2 blobs by strength plus oval
matsubdir = 'blur15-laplacianblobs2-105-50-eig'


nblobs = 2;
UsePosition = 1;
UseScale = 1;
UseEigenvalues = 0;
UseEigenvectors = 0;
UseMeanIntensity = 0;
UseFeatureStrength = 0;
OnsetInsteadofPeak = 0;

filterfun = '';
ellipseoval2blobbasic = EllipseBlobFeatures(featuresdir, nblobs, ...
                UsePosition, UseScale,UseEigenvalues,UseEigenvectors,...
                UseMeanIntensity,UseFeatureStrength,filterfun, OnsetInsteadofPeak,matsubdir);
            

%  peakellipses = EllipseBlobFeatures(featuresdir,1);
 ndims = ellipseoval2blobbasic.FeatureDimensions;
 features = ellipseoval2blobbasic.getNormalisedFeatures(0);
outdir = fullfile(baseoutdir,'f-2blobs+peakellipses');
mkdir(outdir);

% standard plots
%%
if regenerate
    doClustering(outdir, ellipseoval2blobbasic, 1:15, 10, '2blobs + Ellipse fits to peak auroral oval',1);
end
% regenerate = 0;
%
plotClustering(outdir, fileversion, savefile, prefix);

%% 2 blobs by strength plus oval
matsubdir = 'blur15-laplacianblobs2-105-50-eig'


nblobs = 2;
UsePosition = 1;
UseScale = 1;
UseEigenvalues = 2;
UseEigenvectors = 1;
UseMeanIntensity = 0;
UseFeatureStrength = 0;
OnsetInsteadofPeak = 0;

filterfun = '';
ellipseoval2blobfull = EllipseBlobFeatures(featuresdir, nblobs, ...
                UsePosition, UseScale,UseEigenvalues,UseEigenvectors,...
                UseMeanIntensity,UseFeatureStrength,filterfun, OnsetInsteadofPeak,matsubdir);
            

%  peakellipses = EllipseBlobFeatures(featuresdir,1);
 ndims = ellipseoval2blobfull.FeatureDimensions;
 features = ellipseoval2blobfull.getNormalisedFeatures(0);
outdir = fullfile(baseoutdir,'f-2blobsFull+peakellipses');
mkdir(outdir);

% standard plots
%
if regenerate
    doClustering(outdir, ellipseoval2blobfull, 1:15, 10, '2blobsFull + Ellipse fits to peak auroral oval',1);
end
% regenerate = 0;
%
plotClustering(outdir, fileversion, savefile, prefix);


%% 1 blobs by strength with all features plus oval
matsubdir = 'blur15-laplacianblobs2-105-50-eig'


nblobs = 1;
UsePosition = 1;
UseScale = 1;
UseEigenvalues = 2;
UseEigenvectors = 1;
UseMeanIntensity = 1;
UseFeatureStrength = 1;
OnsetInsteadofPeak = 0;

filterfun = 'strongest';
ellipseoval1blobeigs = EllipseBlobFeatures(featuresdir, nblobs, ...
                UsePosition, UseScale,UseEigenvalues,UseEigenvectors,...
                UseMeanIntensity,UseFeatureStrength,filterfun, OnsetInsteadofPeak,matsubdir);
            

%  peakellipses = EllipseBlobFeatures(featuresdir,1);
 ndims = ellipseoval1blobeigs.FeatureDimensions;
 features = ellipseoval1blobeigs.getNormalisedFeatures(0);
outdir = fullfile(baseoutdir,'f-1blob+peakellipses-fulleig');
mkdir(outdir);

% standard plots
%
if regenerate
    doClustering(outdir, ellipseoval1blobeigs, 1:15, 10, '1blobs + Ellipse fits to peak auroral oval',1);
end
%regenerate = 0;
%
plotClustering(outdir, fileversion, savefile, prefix);

%% 5 blobs by strength plus oval
matsubdir = 'blur15-laplacianblobs2-105-50-eig'


nblobs = 3;
UsePosition = 1;
UseScale = 1;
UseEigenvalues = 2;
UseEigenvectors = 1;
UseMeanIntensity = 1;
UseFeatureStrength = 0;
OnsetInsteadofPeak = 0;

filterfun = 'strongest';
ellipseoval3blobeigs = EllipseBlobFeatures(featuresdir, nblobs, ...
                UsePosition, UseScale,UseEigenvalues,UseEigenvectors,...
                UseMeanIntensity,UseFeatureStrength,filterfun, OnsetInsteadofPeak,matsubdir);

            
%  peakellipses = EllipseBlobFeatures(featuresdir,1);
 ndims = ellipseoval3blobeigs.FeatureDimensions;
 features = ellipseoval3blobeigs.getNormalisedFeatures(0);
outdir = fullfile(baseoutdir,'3blobs+peakellipses-fulleig');
mkdir(outdir);
 %standard plots
%
if regenerate
    doClustering(outdir, ellipseoval3blobeigs, 1:15, 10, '3blobs + Ellipse fits to peak auroral oval',1);
end
%regenerate = 0;
%
plotClustering(outdir, fileversion, savefile, prefix);

%% 5 blobs by strength plus oval
% matsubdir = 'blur15-laplacianblobs2-105-50-eig'
matsubdir = 'laplacianblobs11-105-90-eig'

nblobs = 5;
UsePosition = 1;
UseScale = 1;
UseEigenvalues = 2;
UseEigenvectors = 1;
UseMeanIntensity = 1;
UseFeatureStrength = 1;
OnsetInsteadofPeak = 0;

filterfun = '';
ellipseoval5blobbasic2 = EllipseBlobFeatures(featuresdir, nblobs, ...
                UsePosition, UseScale,UseEigenvalues,UseEigenvectors,...
                UseMeanIntensity,UseFeatureStrength,filterfun, OnsetInsteadofPeak,matsubdir);
            

%  peakellipses = EllipseBlobFeatures(featuresdir,1);
 ndims = ellipseoval5blobbasic2.FeatureDimensions;
 features = ellipseoval5blobbasic2.getNormalisedFeatures(0);
outdir = fullfile(baseoutdir,'f-5fullblobs+peakellipses-defblobs');
mkdir(outdir);

% standard plots
%%
if regenerate
    doClustering(outdir, ellipseoval5blobbasic2, 1:15, 10, '5blobs + Ellipse fits to peak auroral oval',1);
end
% regenerate = 0;
%
plotClustering(outdir, fileversion, savefile, prefix);


%% specific plots 
% load data
fname = fullfile(outdir,sprintf('clusteringdata-%d.mat',fileversion));
e = load(fname);
experiments = e.experiments;

% plot component contribution for 8 GMM clusters
hemcontrib = figure(21);
k = 8;
experiment = experiments{k,2};
resultsAll = experiment.getResults();
resultsBest = resultsAll(experiment.bestRun());
plotEMComponentContributions(k,resultsBest.cidx,resultsBest.P)

% 4 GMM-KM 
hemcontribkm = figure(22);
k = 4;
experiment = experiments{k,4};
resultsAll = experiment.getResults();
resultsBest = resultsAll(experiment.bestRun());
plotEMComponentContributions(k,resultsBest.cidx,resultsBest.P)

if savefile==1
   figname = 'em-8';
    fname = sprintf('%s%s.eps',prefix,figname);
    print(hemcontrib,fullfile(outdir,fname),'-depsc2'); 
    figname = 'emkm-4';
    fname = sprintf('%s%s.eps',prefix,figname);
    print(hemcontribkm,fullfile(outdir,fname),'-depsc2'); 
end