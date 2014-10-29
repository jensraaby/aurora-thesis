% for k = n
% % % run the clustering 10 times
% % % save the cluster centroids and distances each time
% % % save the lot to disk
% % % now compute the distortion measure (RSS)
%       pick the clustering with the smallest RSS : Rss_min
%       save this data too

% after doing this for all the different k, we can analyse using BIC/AIC
% plot the BIC value for each k


% inputs: how many clusters, which folder, how many runs per cluster,
% features themselves, where to save experimentresults
% 
% outputs: (side effect: saves data to disk). the AIC/BIC results per
% cluster, other statistical measures?
clear all;
%%

clusterruns = 10;
ks = 2:20; % start small!
rootoutputdir = '/Users/jens/Desktop/Aurora-Working/EventsClustering';
outputdir = fullfile(rootoutputdir,'5blobmultirun');
featuresdir = '/Users/jens/Desktop/Aurora-Working/EventsProcessing';
nblobs = 5;
UsePosition = 1;
UseScale = 1;
UseEigenvalues = 0;
UseEigenvectors = 0;
UseMeanIntensity = 1;
UseFeatureStrength = 1;
peakblobs= BlobFeatures(featuresdir, nblobs, ...
                UsePosition, UseScale,UseEigenvalues,UseEigenvectors,...
                UseMeanIntensity,UseFeatureStrength);
ndims = peakblobs.FeatureDimensions;
            
% not zero centred, but variance normalised
features = peakblobs.getNormalisedFeatures(0);

%%
% data structure to hold: k, results from each run with k
clear clusterings
ks=2:30
clusterings1 = cell(length(ks),clusterruns);
clusterings2 = cell(length(ks),clusterruns);
tic
for ki = 1:length(ks)
    k = ks(ki);
    
    for run = 1:clusterruns
       % run the clustering with a random initialisation 
       
       [ cidx, ctrs, sumd, d ] = jrKMeans( features, k);
       
       clustruct.ctrs = ctrs;
       clustruct.cidx = cidx;
       clustruct.sumd = sumd;
       clustruct.d = d; 
       clusterings1{ki,run} = clustruct;
       
       [ cidx2, ctrs2, AIC, BIC, P ] = jrEMcluster( features, k);
       clustruct2.cidx = cidx2;
       clustruct2.ctrs = ctrs2;
       clustruct2.AIC = AIC;
       clustruct2.BIC = BIC;
       clustruct2.P = P;
       clusterings2{ki,run} = clustruct2;
       
    end 
end

tclusters = toc

%%
AIC = zeros(length(ks),clusterruns);
BIC = zeros(length(ks),clusterruns);
RSSmin = zeros(length(ks),2);
for ki = 1:length(ks)
    k = ks(ki);
    
    % now we analyse each run of clustering to pick the best one
    
    for n = 1:clusterruns
       clustruct = clusterings{ki,n};
       % compute the RSS (residual sum of squared) for each cluster of each
       % clusterrun
       % get d - a matrix of distance to each centroid for each point
       % (n by k)
%        RSSk = zeros(k,1);
%        for kk = 1:k
%         RSSk(kk) = sum(clustruct.d(:,kk).^2);
%        end
%        RSS(ki,n) = sum(RSSk(:));

        [BIC(ki,n),AIC(ki,n)] = clusterdensityGaussian(X,k,clustruct.ctrs, clustruct.cidx);
       
    end
%     [RSSmin(ki,1), RSSmin(ki,2)] = min(RSS(ki,:));
   
    
end

%%
