clear
baseoutdir = '/Users/jens/Desktop/Aurora-Working/EventsClustering/';
featuresdir = '/Users/jens/Desktop/Aurora-Working/EventsProcessing';
% featuresdir = '/Users/jens/Desktop/Aurora-Working/EventsProcessingOval/'
savefile = 1;
fileversion = 5;
regenerate = 1;
prefix = '140330-';



%% Single Peak blob at 2. 90 scale fits
matsubdir = 'blur15-laplacianblobs2-105-50-eig'


nblobs = 1;
UsePosition = 1;
UseScale = 1;
UseEigenvalues = 0;
UseEigenvectors = 0;
UseMeanIntensity = 0;
UseFeatureStrength = 0;
OnsetInsteadofPeak = 0;

filterfun = 'biggest';
clear peakblobsbasic;
peakblobsbasic = BlobFeatures(featuresdir, nblobs, ...
                UsePosition, UseScale,UseEigenvalues,UseEigenvectors,...
                UseMeanIntensity,UseFeatureStrength,filterfun, OnsetInsteadofPeak,matsubdir);
            
ndims = peakblobsbasic.FeatureDimensions;
            
% not zero centred, but variance normalised
features = peakblobsbasic.getNormalisedFeatures(0);


%%
outdir = fullfile(baseoutdir,'f-blob-singlelargest');
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

%% Single peak blob by feature strength with intensity
matsubdir = 'blur15-laplacianblobs2-105-50-eig'


nblobs = 1;
UsePosition = 1;
UseScale = 1;
UseEigenvalues = 0;
UseEigenvectors = 0;
UseMeanIntensity = 1;
UseFeatureStrength = 0;
OnsetInsteadofPeak = 0;

filterfun = 'strongest';
clear peakblobsbasicstrength peakblobsbasicbiggest peakblobsellipse;
peakblobsbasicstrengthintensity = BlobFeatures(featuresdir, nblobs, ...
                UsePosition, UseScale,UseEigenvalues,UseEigenvectors,...
                UseMeanIntensity,UseFeatureStrength,filterfun, OnsetInsteadofPeak,matsubdir);
            
ndims = peakblobsbasicstrengthintensity.FeatureDimensions;
            
% not zero centred, but variance normalised
features = peakblobsbasicstrengthintensity.getNormalisedFeatures(0);


%
outdir = fullfile(baseoutdir,'f-blob-singlestrongest-intensity');
mkdir(outdir);
if regenerate
    doClustering(outdir, peakblobsbasicstrengthintensity, 1:15, 10, '1 peak blobs strongest with intensity',1);
end
% regenerate = 0;
%
plotClustering(outdir, fileversion, savefile, prefix)

%% Single peak blob by feature strength with all features
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
clear peakblobsbasicstrengthFULL peakblobsbasicbiggest peakblobsellipse;
peakblobsbasicstrengthFULL = BlobFeatures(featuresdir, nblobs, ...
                UsePosition, UseScale,UseEigenvalues,UseEigenvectors,...
                UseMeanIntensity,UseFeatureStrength,filterfun, OnsetInsteadofPeak,matsubdir);
            
ndims = peakblobsbasicstrengthFULL.FeatureDimensions;
            
% not zero centred, but variance normalised
features = peakblobsbasicstrengthFULL.getNormalisedFeatures(0);
%%

%
outdir = fullfile(baseoutdir,'f-blob-singlestrongest-full');
mkdir(outdir);
if regenerate
    doClustering(outdir, peakblobsbasicstrengthFULL, 1:15, 10, '1 peak blobs strongest with all features',1);
end
% regenerate = 0;
%
plotClustering(outdir, fileversion, savefile, prefix)

%% Single peak blob by intensity
matsubdir = 'blur15-laplacianblobs2-105-50-eig'


nblobs = 1;
UsePosition = 1;
UseScale = 1;
UseEigenvalues = 0;
UseEigenvectors = 0;
UseMeanIntensity = 0;
UseFeatureStrength = 0;
OnsetInsteadofPeak = 0;

filterfun = 'brightest';
clear peakblobsbasicintensity peakblobsbasicstrength peakblobsbasicbiggest peakblobsellipse;
peakblobsbasicintensity = BlobFeatures(featuresdir, nblobs, ...
                UsePosition, UseScale,UseEigenvalues,UseEigenvectors,...
                UseMeanIntensity,UseFeatureStrength,filterfun, OnsetInsteadofPeak,matsubdir);
            
ndims = peakblobsbasicintensity.FeatureDimensions;
            
% not zero centred, but variance normalised
features = peakblobsbasicintensity.getNormalisedFeatures(0);


%
outdir = fullfile(baseoutdir,'f-singlebrightest');
mkdir(outdir);
if regenerate
    doClustering(outdir, peakblobsbasicintensity, 1:15, 10, '1 peak blobs strongest with intensity',1);
end
% regenerate = 0;
%
plotClustering(outdir, fileversion, savefile, prefix)

%% 2 peak blobs by strength
matsubdir = 'blur15-laplacianblobs2-105-50-eig'


nblobs = 2;
UsePosition = 1;
UseScale = 1;
UseEigenvalues = 0;
UseEigenvectors = 0;
UseMeanIntensity = 0;
UseFeatureStrength = 0;
OnsetInsteadofPeak = 0;

filterfun = 'strongest';
clear peakblobsbasicintensity peakblobsbasicstrength peakblobsbasicbiggest peakblobsellipse;
peakblobs2bystrength = BlobFeatures(featuresdir, nblobs, ...
                UsePosition, UseScale,UseEigenvalues,UseEigenvectors,...
                UseMeanIntensity,UseFeatureStrength,filterfun, OnsetInsteadofPeak,matsubdir);
            
ndims = peakblobs2bystrength.FeatureDimensions;
            
% not zero centred, but variance normalised
features = peakblobs2bystrength.getNormalisedFeatures(0);


%
outdir = fullfile(baseoutdir,'f-2strongest');
mkdir(outdir);
if regenerate
    doClustering(outdir, peakblobs2bystrength, 1:15, 10, '2 peak blobs strongest xys',1);
end
% regenerate = 0;
%
plotClustering(outdir, fileversion, savefile, prefix)

%% 2 peak blobs by strength
matsubdir = 'blur15-laplacianblobs2-105-50-eig'


nblobs = 2;
UsePosition = 1;
UseScale = 1;
UseEigenvalues = 2;
UseEigenvectors = 1;
UseMeanIntensity = 1;
UseFeatureStrength = 1;
OnsetInsteadofPeak = 0;

filterfun = 'strongest';
clear peakblobsbasicintensity peakblobsbasicstrength peakblobsbasicbiggest peakblobsellipse;
peakblobs2bystrengthE = BlobFeatures(featuresdir, nblobs, ...
                UsePosition, UseScale,UseEigenvalues,UseEigenvectors,...
                UseMeanIntensity,UseFeatureStrength,filterfun, OnsetInsteadofPeak,matsubdir);
            
ndims = peakblobs2bystrengthE.FeatureDimensions;
            
% not zero centred, but variance normalised
features = peakblobs2bystrengthE.getNormalisedFeatures(0);


%
outdir = fullfile(baseoutdir,'f-blob-2strongest-full2');
mkdir(outdir);
if regenerate
    doClustering(outdir, peakblobs2bystrengthE, 1:15, 10, '2 peak blobs strongest xys eigenvalue',1);
end
% regenerate = 0;
%
plotClustering(outdir, fileversion, savefile, prefix)

%% 2 peak blobs by strength with full eigs data
matsubdir = 'blur15-laplacianblobs2-105-50-eig'


nblobs = 2;
UsePosition = 1;
UseScale = 1;
UseEigenvalues = 2;
UseEigenvectors = 1;
UseMeanIntensity = 1;
UseFeatureStrength = 0;
OnsetInsteadofPeak = 0;

filterfun = 'strongest';
clear peakblobsbasicintensity peakblobsbasicstrength peakblobsbasicbiggest peakblobsellipse;
peakblobs2bystrengthEF = BlobFeatures(featuresdir, nblobs, ...
                UsePosition, UseScale,UseEigenvalues,UseEigenvectors,...
                UseMeanIntensity,UseFeatureStrength,filterfun, OnsetInsteadofPeak,matsubdir);
            
ndims = peakblobs2bystrengthEF.FeatureDimensions;
            
% not zero centred, but variance normalised
features = peakblobs2bystrengthEF.getNormalisedFeatures(0);


%
outdir = fullfile(baseoutdir,'2strongest-3fulleig');
mkdir(outdir);
if regenerate
    doClustering(outdir, peakblobs2bystrengthEF, 1:15, 10, '2 peak blobs strongest xys full eig',1);
end
% regenerate = 0;
%
plotClustering(outdir, fileversion, savefile, prefix)


%% 2 Peak blobs at 2. 90 scale fits
matsubdir = 'blur15-laplacianblobs2-105-50-eig'


nblobs = 2;
UsePosition = 1;
UseScale = 1;
UseEigenvalues = 0;
UseEigenvectors = 0;
UseMeanIntensity = 0;
UseFeatureStrength = 0;
OnsetInsteadofPeak = 0;

filterfun = 'biggest';
clear peakblobsbasic2;
peakblobsbasic2 = BlobFeatures(featuresdir, nblobs, ...
                UsePosition, UseScale,UseEigenvalues,UseEigenvectors,...
                UseMeanIntensity,UseFeatureStrength,filterfun, OnsetInsteadofPeak,matsubdir);
            
ndims = peakblobsbasic2.FeatureDimensions;
            
% not zero centred, but variance normalised
features = peakblobsbasic2.getNormalisedFeatures(0);


%
outdir = fullfile(baseoutdir,'2largest-1');
mkdir(outdir);
if regenerate
    doClustering(outdir, peakblobsbasic2, 1:15, 10, '2 peak blobs largest',1);
end
% regenerate = 0;
%
plotClustering(outdir, fileversion, savefile, prefix)
 
%% 3 peak blobs by strength
matsubdir = 'blur15-laplacianblobs2-105-50-eig'


nblobs = 3;
UsePosition = 1;
UseScale = 1;
UseEigenvalues = 0;
UseEigenvectors = 0;
UseMeanIntensity = 0;
UseFeatureStrength = 0;
OnsetInsteadofPeak = 0;

filterfun = 'strongest';
clear peakblobsbasicintensity peakblobsbasicstrength peakblobsbasicbiggest peakblobsellipse;
peakblobs3bystrength = BlobFeatures(featuresdir, nblobs, ...
                UsePosition, UseScale,UseEigenvalues,UseEigenvectors,...
                UseMeanIntensity,UseFeatureStrength,filterfun, OnsetInsteadofPeak,matsubdir);
            
ndims = peakblobs3bystrength.FeatureDimensions;
            
% not zero centred, but variance normalised
features = peakblobs3bystrength.getNormalisedFeatures(0);


%
outdir = fullfile(baseoutdir,'f-3strongest-basic');
mkdir(outdir);
if regenerate
    doClustering(outdir, peakblobs3bystrength, 1:15, 10, '3 peak blobs strongest xys ',1);
end
% regenerate = 0;
%
plotClustering(outdir, fileversion, savefile, prefix)

%% 3 peak blobs by strength
matsubdir = 'blur15-laplacianblobs2-105-50-eig'


nblobs = 3;
UsePosition = 1;
UseScale = 1;
UseEigenvalues = 0;
UseEigenvectors = 0;
UseMeanIntensity = 0;
UseFeatureStrength = 0;
OnsetInsteadofPeak = 0;

filterfun = 'biggest';
clear peakblobsbasicintensity peakblobsbasicstrength peakblobsbasicbiggest peakblobsellipse;
peakblobs3bysize = BlobFeatures(featuresdir, nblobs, ...
                UsePosition, UseScale,UseEigenvalues,UseEigenvectors,...
                UseMeanIntensity,UseFeatureStrength,filterfun, OnsetInsteadofPeak,matsubdir);
            
ndims = peakblobs3bysize.FeatureDimensions;
            
% not zero centred, but variance normalised
features = peakblobs3bysize.getNormalisedFeatures(0);


%
outdir = fullfile(baseoutdir,'f-3biggest-basic');
mkdir(outdir);
if regenerate
    doClustering(outdir, peakblobs3bysize, 1:15, 10, '3 peak blobs largest xys ',1);
end
% regenerate = 0;
%
plotClustering(outdir, fileversion, savefile, prefix)

% 3 peak blobs by strength
matsubdir = 'blur15-laplacianblobs2-105-50-eig'


nblobs = 3;
UsePosition = 1;
UseScale = 1;
UseEigenvalues = 2;
UseEigenvectors = 1;
UseMeanIntensity = 1;
UseFeatureStrength = 1;
OnsetInsteadofPeak = 0;

filterfun = '';
clear peakblobs3bystrFull
peakblobs3bystrFull = BlobFeatures(featuresdir, nblobs, ...
                UsePosition, UseScale,UseEigenvalues,UseEigenvectors,...
                UseMeanIntensity,UseFeatureStrength,filterfun, OnsetInsteadofPeak,matsubdir);
            
ndims = peakblobs3bystrFull.FeatureDimensions;
            
% not zero centred, but variance normalised
features = peakblobs3bystrFull.getNormalisedFeatures(0);


%
outdir = fullfile(baseoutdir,'f-blob-3str-full');
mkdir(outdir);
if regenerate
    doClustering(outdir, peakblobs3bystrFull, 1:15, 10, '3 peak blobs strongest full ',1);
end
% regenerate = 0;
%
plotClustering(outdir, fileversion, savefile, prefix)


%% 5 peak blobs by strength
matsubdir = 'blur15-laplacianblobs2-105-50-eig'


nblobs = 5;
UsePosition = 1;
UseScale = 1;
UseEigenvalues = 2;
UseEigenvectors = 1;
UseMeanIntensity = 0;
UseFeatureStrength = 1;
OnsetInsteadofPeak = 0;

filterfun = '';
clear peakblobs5bystrengthE
peakblobs5bystrengthE = BlobFeatures(featuresdir, nblobs, ...
                UsePosition, UseScale,UseEigenvalues,UseEigenvectors,...
                UseMeanIntensity,UseFeatureStrength,filterfun, OnsetInsteadofPeak,matsubdir);
            
ndims = peakblobs5bystrengthE.FeatureDimensions;
            
% not zero centred, but variance normalised
features = peakblobs5bystrengthE.getNormalisedFeatures(0);


%%
outdir = fullfile(baseoutdir,'f-blob-5strongest-fulleigs');
mkdir(outdir);
if regenerate
    doClustering(outdir, peakblobs5bystrengthE, 1:15, 10, '5 peak blobs strongest xys eigenvectors',1);
end
% regenerate = 0;
%
plotClustering(outdir, fileversion, savefile, prefix)

%% 5 peak blobs by strength
matsubdir = 'blur15-laplacianblobs2-105-50-eig'


nblobs = 5;
UsePosition = 1;
UseScale = 1;
UseEigenvalues = 2;
UseEigenvectors = 1;
UseMeanIntensity = 0;
UseFeatureStrength = 1;
OnsetInsteadofPeak = 0;

filterfun = 'biggest';
clear peakblobs5bysizeE
peakblobs5bysizeE = BlobFeatures(featuresdir, nblobs, ...
                UsePosition, UseScale,UseEigenvalues,UseEigenvectors,...
                UseMeanIntensity,UseFeatureStrength,filterfun, OnsetInsteadofPeak,matsubdir);
            
ndims = peakblobs5bysizeE.FeatureDimensions;
            
% not zero centred, but variance normalised
features = peakblobs5bysizeE.getNormalisedFeatures(0);


%
outdir = fullfile(baseoutdir,'f-blob-5largest-fulleigs');
mkdir(outdir);
if regenerate
    doClustering(outdir, peakblobs5bysizeE, 1:15, 10, '5 peak blobs strongest xys eigenvectors',1);
end
% regenerate = 0;
%
plotClustering(outdir, fileversion, savefile, prefix)

%% Peak blobs at 1.1. 90 scale fits

nblobs = 5;
UsePosition = 1;
UseScale = 1;
UseEigenvalues = 0;
UseEigenvectors = 0;
UseMeanIntensity = 0;
UseFeatureStrength = 0;
OnsetInsteadofPeak = 0
clear peakblobsbasic
peakblobsbasic = BlobFeatures(featuresdir, nblobs, ...
                UsePosition, UseScale,UseEigenvalues,UseEigenvectors,...
                UseMeanIntensity,UseFeatureStrength,'',OnsetInsteadofPeak);
            
ndims = peakblobsbasic.FeatureDimensions;
            
% not zero centred, but variance normalised
features = peakblobsbasic.getNormalisedFeatures(0);

outdir = fullfile(baseoutdir,'f-5basicblobs');
mkdir(outdir);
%%
if regenerate
    doClustering(outdir, peakblobsbasic, 1:15, 10, '5 peak blobs basic',1);
end
regenerate = 0;
%%
plotClustering(outdir, fileversion, savefile, prefix)
 
%% 5 biggest polar coords
filterfun = 'biggest';
nblobs = 5;
UsePosition = 2; % mlat
UseScale = 1;
UseEigenvalues = 0;
UseEigenvectors = 0;
UseMeanIntensity = 0;
UseFeatureStrength = 0;
OnsetInsteadofPeak = 0
clear peakblobsbasic5mlat
peakblobsbasic5mlat = BlobFeatures(featuresdir, nblobs, ...
                UsePosition, UseScale,UseEigenvalues,UseEigenvectors,...
                UseMeanIntensity,UseFeatureStrength,filterfun,OnsetInsteadofPeak);
            
ndims = peakblobsbasic5mlat.FeatureDimensions;
            
% not zero centred, but variance normalised
features = peakblobsbasic5mlat.getNormalisedFeatures(0);
%%
outdir = fullfile(baseoutdir,'f-5basicblobs-largest-polar');
mkdir(outdir);
%
if regenerate
    doClustering(outdir, peakblobsbasic5mlat, 1:15, 10, '5 peak blobs basic polar coords',1);
end
% regenerate = 0;
%
plotClustering(outdir, fileversion, savefile, prefix)

%% 5 strongest, polar coords
filterfun = 'strongest';
nblobs = 5;
UsePosition = 2; % mlat
UseScale = 1;
UseEigenvalues = 0;
UseEigenvectors = 0;
UseMeanIntensity = 0;
UseFeatureStrength = 0;
OnsetInsteadofPeak = 0
clear peakblobsbasic5strpol
peakblobsbasic5strpol = BlobFeatures(featuresdir, nblobs, ...
                UsePosition, UseScale,UseEigenvalues,UseEigenvectors,...
                UseMeanIntensity,UseFeatureStrength,filterfun,OnsetInsteadofPeak);
            
ndims = peakblobsbasic5strpol.FeatureDimensions;
            
% not zero centred, but variance normalised
features = peakblobsbasic5strpol.getNormalisedFeatures(0);
%%
outdir = fullfile(baseoutdir,'f-5basicblobs-strongest-polar');
mkdir(outdir);
%
if regenerate
    doClustering(outdir, peakblobsbasic5strpol, 1:15, 10, '5 peak blobs basic polar coords',1);
end
% regenerate = 0;
%
plotClustering(outdir, fileversion, savefile, prefix)
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