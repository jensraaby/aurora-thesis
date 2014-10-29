clear
baseoutdir = '/Users/jens/Desktop/Aurora-Working/EventsClustering/';
featuresdir = '/Users/jens/Desktop/Aurora-Working/EventsProcessing';

savefile = 1;
fileversion = 5;
regenerate = 1;
prefix = '140330-';

%% Peak ellipse fits
% note updated to new version!
clear peakellipses
peakellipses = EllipseFeature(featuresdir,1);
ndims = peakellipses.FeatureDimensions;
features = peakellipses.getNormalisedFeatures(0);
outdir = fullfile(baseoutdir,'f-peakellipses');
mkdir(outdir);

%% standard plots

if regenerate
    doClustering(outdir, peakellipses, 1:15, 10, 'Ellipse fits to peak auroral oval',1);
end
% regenerate = 1;
%%
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