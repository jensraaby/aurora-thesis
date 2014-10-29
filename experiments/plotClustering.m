function [] = plotClustering(experimentdir, version, saveplot, prefix)
%%% inputs :
% experimentdir - where the data is
% version - version of the experiments - used for loading the correct file
% save - whether to save the plots - other wise they are just opened on the
% screen
% prefix - for the name of the output plots

fname = fullfile(experimentdir,sprintf('clusteringdata-%d.mat',version));
e = load(fname);
experiments = e.experiments;
featuresobj = e.featuresobj;

clusterings = size(experiments,1);

% first f ratio
hft = figure(1001)
plotFtest(experiments,1);
hft2 = figure(1002)
plotFtest(experiments,2);
hft3 = figure(1003)
plotFtest(experiments,3);
hft4 = figure(1004)
plotFtest(experiments,4);
if saveplot
    figname = 'fratioKM';
    fname = sprintf('%s%s.eps',prefix,figname);
    print(hft,fullfile(experimentdir,fname),'-depsc2');
    figname = 'fratioGMM';
    fname = sprintf('%s%s.eps',prefix,figname);
    print(hft2,fullfile(experimentdir,fname),'-depsc2');
    figname = 'fratioKM++';
    fname = sprintf('%s%s.eps',prefix,figname);
    print(hft3,fullfile(experimentdir,fname),'-depsc2');
    figname = 'fratioGMM-km';
    fname = sprintf('%s%s.eps',prefix,figname);
    print(hft4,fullfile(experimentdir,fname),'-depsc2');
    
    plotGMMContrib(experiments,2,experimentdir);
    plotGMMContrib(experiments,4,experimentdir);

end

hBICgmm = figure(101);
plotBIC(experiments,2);
hBICgmmkm = figure(102);
plotBIC(experiments,4);

if saveplot
    figname = 'BIC-GMM';
    fname = sprintf('%s%s.eps',prefix,figname)
    print(hBICgmm,fullfile(experimentdir,fname),'-depsc2');
    figname = 'BIC-GMMKM';
    fname = sprintf('%s%s.eps',prefix,figname)
    print(hBICgmmkm,fullfile(experimentdir,fname),'-depsc2');
end

hhartkm = figure(103);
plotHartigan(experiments,1);
hhartgmm = figure(104);
plotHartigan(experiments,2);
hhartkmpp = figure(105);
plotHartigan(experiments,3);
hhartgmmkm = figure(106);
plotHartigan(experiments,4);

if saveplot
    figname = 'hart-KM';
    fname = sprintf('%s%s.eps',prefix,figname)
    print(hhartkm,fullfile(experimentdir,fname),'-depsc2');
    figname = 'hart-KMpp';
    fname = sprintf('%s%s.eps',prefix,figname)
    print(hhartkmpp,fullfile(experimentdir,fname),'-depsc2');
    figname = 'hart-GMM';
    fname = sprintf('%s%s.eps',prefix,figname)
    print(hhartgmm,fullfile(experimentdir,fname),'-depsc2');
    figname = 'hart-GMMKM';
    fname = sprintf('%s%s.eps',prefix,figname)
    print(hhartgmmkm,fullfile(experimentdir,fname),'-depsc2');
end

hsilkm = figure(7)
plotSilhouetteSummary(experiments,1);
hsilem = figure(8)
plotSilhouetteSummary(experiments,2);
hsilkmpp = figure(9)
plotSilhouetteSummary(experiments,3);
hsilemkm = figure(10)
plotSilhouetteSummary(experiments,4);


if saveplot
    
    figname = 'silhouetteKM';
    fname = sprintf('%s%s.eps',prefix,figname)
    print(hsilkm,fullfile(experimentdir,fname),'-depsc2');
    
    figname = 'silhouetteEM';
    fname = sprintf('%s%s.eps',prefix,figname)
    print(hsilem,fullfile(experimentdir,fname),'-depsc2');
    
    figname = 'silhouetteKMpp';
    fname = sprintf('%s%s.eps',prefix,figname)
    print(hsilkmpp,fullfile(experimentdir,fname),'-depsc2');
    
    figname = 'silhouetteEMkm';
    fname = sprintf('%s%s.eps',prefix,figname)
    print(hsilemkm,fullfile(experimentdir,fname),'-depsc2');
end

hsilkm = figure(1117)
plotSilhouetteBest(experiments,1);
hsilem = figure(1118)
plotSilhouetteBest(experiments,2);
hsilkmpp = figure(1119)
plotSilhouetteBest(experiments,3);
hsilemkm = figure(1110)
plotSilhouetteBest(experiments,4);


if saveplot
    
    figname = 'bestsilhouetteKM';
    fname = sprintf('%s%s.eps',prefix,figname)
    print(hsilkm,fullfile(experimentdir,fname),'-depsc2');
    
    figname = 'bestsilhouetteEM';
    fname = sprintf('%s%s.eps',prefix,figname)
    print(hsilem,fullfile(experimentdir,fname),'-depsc2');
    
    figname = 'bestsilhouetteKMpp';
    fname = sprintf('%s%s.eps',prefix,figname)
    print(hsilkmpp,fullfile(experimentdir,fname),'-depsc2');
    
    figname = 'bestsilhouetteEMkm';
    fname = sprintf('%s%s.eps',prefix,figname)
    print(hsilemkm,fullfile(experimentdir,fname),'-depsc2');
end
% 
% hcoskm = figure(1)
% plotCohesions(experiments,1);
% 
% hcosem = figure(2)
% plotCohesions(experiments,2);
% 
% hvarkm = figure(3)
% plotVariance(experiments,1);
% 
% hvarem = figure(4)
% plotVariance(experiments,2);
% 
% hsepkm = figure(5)
% plotSeparation(experiments,1);
% hsepem = figure(6)
% plotSeparation(experiments,2);
% 
% 
% hsilkm = figure(7)
% plotSilhouetteSummary(experiments,1);
% hsilem = figure(8)
% plotSilhouetteSummary(experiments,2);
% 
% hbic = figure(9)
% plotBIC(experiments);
% 
% 
% if saveplot
%     disp('saving');
%     
%     figname = 'cohesionKM';
%     fname = sprintf('%s%s.eps',prefix,figname)
%     print(hcoskm,fullfile(experimentdir,fname),'-depsc2');
%     
%     figname = 'cohesionEM';
%     fname = sprintf('%s%s.eps',prefix,figname)
%     print(hcosem,fullfile(experimentdir,fname),'-depsc2');
%     
%     figname = 'varianceKM';
%     fname = sprintf('%s%s.eps',prefix,figname)
%     print(hvarkm,fullfile(experimentdir,fname),'-depsc2');
%     
%     figname = 'varianceEM';
%     fname = sprintf('%s%s.eps',prefix,figname)
%     print(hvarem,fullfile(experimentdir,fname),'-depsc2');
%     
%     figname = 'separationKM';
%     fname = sprintf('%s%s.eps',prefix,figname)
%     print(hsepkm,fullfile(experimentdir,fname),'-depsc2');
%     
%     figname = 'separationEM';
%     fname = sprintf('%s%s.eps',prefix,figname)
%     print(hsepem,fullfile(experimentdir,fname),'-depsc2');
%     
%     figname = 'silhouetteKM';
%     fname = sprintf('%s%s.eps',prefix,figname)
%     print(hsilkm,fullfile(experimentdir,fname),'-depsc2');
%     
%     figname = 'silhouetteEM';
%     fname = sprintf('%s%s.eps',prefix,figname)
%     print(hsilem,fullfile(experimentdir,fname),'-depsc2');
%     
%     figname = 'BICEM';
%     fname = sprintf('%s%s.eps',prefix,figname)
%     print(hbic,fullfile(experimentdir,fname),'-depsc2');
%     
%     

% end

if saveplot
    close all
end
end

function [] = plotHartigan(experiments,cm)
    X = experiments{2,cm}.features;
    Hartigan = zeros(15,1);
    for k = 1:14
        ek = experiments{k,cm};
        ekn = experiments{k+1,cm};
        results = ek.getResults();
        resultsn = ekn.getResults();

        cidxk =  results(ek.bestRun()).cidx;
        ctrsk = results(ek.bestRun()).ctrs;
        cidxkn =  resultsn(ekn.bestRun()).cidx;
        ctrskn = resultsn(ekn.bestRun()).ctrs;
        Hartigan(k) = hartigan(X,k,cidxk,ctrsk,cidxkn,ctrskn);
    
    end

    plot(2:14,Hartigan(2:14));
% %     title(sprintf('Hartigan ratio - %s',experimentIDtoString(cm)));

    xlabel('K Clusters','FontSize',20);
    ylabel('H(K)','FontSize',20);
    set(gca,'FontSize',16);

end

function [] = plotCohesions(experiments,clustermethod)
% only accepts 1:1(or more) clustering, ignoring first cluster
% this is to enable different linestyles

% either make an array of line styles or just set up a common pattern
% we have to be painfully explicit here
cm = clustermethod;
if cm == 1
    methstring = 'k-means';
elseif cm == 2
    methstring = 'EM';
end
co2 = experiments{2,cm}.cohesion(experiments{2,cm}.bestRun());
co3 = experiments{3,cm}.cohesion(experiments{3,cm}.bestRun());
co4 = experiments{4,cm}.cohesion(experiments{4,cm}.bestRun());
co5 = experiments{5,cm}.cohesion(experiments{5,cm}.bestRun());
co6 = experiments{6,cm}.cohesion(experiments{6,cm}.bestRun());
co7 = experiments{7,cm}.cohesion(experiments{7,cm}.bestRun());
co8 = experiments{8,cm}.cohesion(experiments{8,cm}.bestRun());
co9 = experiments{9,cm}.cohesion(experiments{9,cm}.bestRun());
co10= experiments{10,cm}.cohesion(experiments{10,cm}.bestRun());



co11= experiments{11,cm}.cohesion(experiments{11,cm}.bestRun());
co12= experiments{12,cm}.cohesion(experiments{12,cm}.bestRun());
co13= experiments{13,cm}.cohesion(experiments{13,cm}.bestRun());
co14= experiments{14,cm}.cohesion(experiments{14,cm}.bestRun());
co15= experiments{15,cm}.cohesion(experiments{15,cm}.bestRun());
subplot(121)
plot(1:2,co2,1:3,co3,1:4,co4,1:5,co5,1:6,co6,1:7,co7,1:8,co8,1:9,co9,1:10,co10,1:11,co11,1:12,co12,1:13,co13,1:14,co14,1:15,co15)
xlabel('Cluster')
ylabel('Cohesion within cluster')
title(sprintf('Cluster cohesion - %s',methstring))
legend(legendArray(2,10, ''))
subplot(122)
plot(2:10,[mean(co2),mean(co3),mean(co4),mean(co5),mean(co6),mean(co7),mean(co8),mean(co9),mean(co10)],'rx--')
xlabel('Number of Clusters')
ylabel('Mean cohesion of clusters');
xlim([1,11])
title(sprintf('Mean cluster cohesion - %s',methstring))
end

function legendarray = legendArray(bottomK,topK, prefix)
ks = bottomK:topK;

legendarray = cell(numel(ks),1);
for i = 1:numel(ks)
    k = ks(i);
    legendarray{i} = sprintf('%s K=%d',prefix,k);
end
end

function [ax1,ax2] = plotVariance(experiments,clustermethod)
% this time use variance

% either make an array of line styles or just set up a common pattern
% we have to be painfully explicit here
cm = clustermethod;
if cm == 1
    methstring = 'k-means';
elseif cm == 2
    methstring = 'EM';
end
co2 = experiments{2,cm}.clusterVariance(experiments{2,cm}.bestRun());
co3 = experiments{3,cm}.clusterVariance(experiments{3,cm}.bestRun());
co4 = experiments{4,cm}.clusterVariance(experiments{4,cm}.bestRun());
co5 = experiments{5,cm}.clusterVariance(experiments{5,cm}.bestRun());
co6 = experiments{6,cm}.clusterVariance(experiments{6,cm}.bestRun());
co7 = experiments{7,cm}.clusterVariance(experiments{7,cm}.bestRun());
co8 = experiments{8,cm}.clusterVariance(experiments{8,cm}.bestRun());
co9 = experiments{9,cm}.clusterVariance(experiments{9,cm}.bestRun());
co10= experiments{10,cm}.clusterVariance(experiments{10,cm}.bestRun());
co11= experiments{11,cm}.clusterVariance(experiments{11,cm}.bestRun());
co12= experiments{12,cm}.clusterVariance(experiments{12,cm}.bestRun());
co13= experiments{13,cm}.clusterVariance(experiments{13,cm}.bestRun());
co14= experiments{14,cm}.clusterVariance(experiments{14,cm}.bestRun());
co15= experiments{15,cm}.clusterVariance(experiments{15,cm}.bestRun());

subplot(121)
ax1 = plot(1:2,co2,1:3,co3,1:4,co4,1:5,co5,1:6,co6,1:7,co7,1:8,co8,'d-',1:9,co9,'s-',1:10,co10,'o-',1:11,co11,1:12,co12,1:13,co13,1:14,co14,1:15,co15)
xlabel('Cluster')
ylabel('Variance within cluster')
title(sprintf('Cluster variance - %s',methstring))
legend(legendArray(2,15, ''))
subplot(122)
ax2 = plot(2:15,[mean(co2),mean(co3),mean(co4),mean(co5),mean(co6),mean(co7),mean(co8),mean(co9),mean(co10),mean(co11),mean(co12),mean(co13),mean(co14),mean(co15)],'rx--')
xlabel('Number of Clusters')
ylabel('Mean variance of clusters');
xlim([1,16])
title(sprintf('Mean cluster variance - %s',methstring))
end


function [] = plotSeparation(experiments,clustermethod)
% this is a measure of how well separated the cluster centroids are
% (weighted by size of clusters).

cm = clustermethod;
if cm == 1
    methstring = 'k-means';
elseif cm == 2
    methstring = 'EM';
end
co2 = experiments{2,cm}.separation(experiments{2,cm}.bestRun());
co3 = experiments{3,cm}.separation(experiments{3,cm}.bestRun());
co4 = experiments{4,cm}.separation(experiments{4,cm}.bestRun());
co5 = experiments{5,cm}.separation(experiments{5,cm}.bestRun());
co6 = experiments{6,cm}.separation(experiments{6,cm}.bestRun());
co7 = experiments{7,cm}.separation(experiments{7,cm}.bestRun());
co8 = experiments{8,cm}.separation(experiments{8,cm}.bestRun());
co9 = experiments{9,cm}.separation(experiments{9,cm}.bestRun());
co10= experiments{10,cm}.separation(experiments{10,cm}.bestRun());
co11= experiments{11,cm}.separation(experiments{11,cm}.bestRun());
co12= experiments{12,cm}.separation(experiments{12,cm}.bestRun());
co13= experiments{13,cm}.separation(experiments{13,cm}.bestRun());
co14= experiments{14,cm}.separation(experiments{14,cm}.bestRun());
co15= experiments{15,cm}.separation(experiments{15,cm}.bestRun());

ax1 = plot(2:15,[co2,co3,co4,co5,co6,co7,co8,co9,co10,co11,co12,co13,co14,co15],'rx--');
xlabel('Clusters')
ylabel('Separation measure')
title(sprintf('Cluster separation measure - %s',methstring))


end


function [] = plotSilhouetteSummary(experiments,clustermethod)
cm = clustermethod;

hold on

meanofmeanAndError = zeros(14,2);
meanovertrials = zeros(14,2);
for k = 2:15
    [~,meank] = experiments{k,cm}.getSilhouette(experiments{k,cm}.bestRun());
   
    [~,alltrialsmean,alltrialsstd] = experiments{k,cm}.getMeanSilhouette();
    
    meanofmeanAndError(k-1,1) = mean(meank);
    meanofmeanAndError(k-1,2) = std(meank);
    
    meanovertrials(k-1,1) = mean(alltrialsmean); % mean over all clusters
    meanovertrials(k-1,2) =  mean(alltrialsstd);
    
    
end

% plot(2:15,meanofmeanAndError(:,1),'rs--');
% errorbar(2:15,meanofmeanAndError(:,1),meanofmeanAndError(:,2))
% hold on

plot(2:15,meanovertrials(:,1),'bo-');
errorbar(2:15,meanovertrials(:,1),meanovertrials(:,2))

%     ax1 = plot(2:15,[mean(mean2),mean(mean3),mean(mean4),mean(mean5),mean(mean6),mean(mean7),mean(mean8),mean(mean9),mean(mean10),mean(mean11),mean(mean12),mean(mean13),mean(mean14),mean(mean15)],'bo-')
xlabel('K','FontSize',20)
ylabel('Mean Silhouette value','FontSize',20);
    set(gca,'FontSize',16);
%     title('Mean Silhouette  across all clusters')
% title(sprintf('Mean Silhouette values - %s',experimentIDtoString(cm)))
xlim([1,16])
hold off

end


function [] = plotSilhouetteBest(experiments,clustermethod)
cm = clustermethod;

hold on

meanofmeanAndError = zeros(14,2);
meanovertrials = zeros(14,2);
for k = 2:15
    [~,meank] = experiments{k,cm}.getSilhouette(experiments{k,cm}.bestRun());
   
    [~,alltrialsmean,alltrialsstd] = experiments{k,cm}.getMeanSilhouette();
    
    meanofmeanAndError(k-1,1) = mean(meank);
    meanofmeanAndError(k-1,2) = std(meank);
    
    meanovertrials(k-1,1) = mean(alltrialsmean); % mean over all clusters
    meanovertrials(k-1,2) =  mean(alltrialsstd);
    
    
end

plot(2:15,meanofmeanAndError(:,1),'rs--');
errorbar(2:15,meanofmeanAndError(:,1),meanofmeanAndError(:,2))


%     ax1 = plot(2:15,[mean(mean2),mean(mean3),mean(mean4),mean(mean5),mean(mean6),mean(mean7),mean(mean8),mean(mean9),mean(mean10),mean(mean11),mean(mean12),mean(mean13),mean(mean14),mean(mean15)],'bo-')
xlabel('K','FontSize',20)
ylabel('Mean Silhouette value','FontSize',20);
    set(gca,'FontSize',16);
%     title('Mean Silhouette  across all clusters')
% title(sprintf('Mean Silhouette values - %s',experimentIDtoString(cm)))
xlim([1,16])
hold off

end



function [] = plotBIC(experiments,cm)
% basic plotting of the BIC analysis for all the k sizes
BICError = zeros(14,2);
BICMeanError = zeros(14,1);
for k = 2:15
    
    % note get BIC gives all the different trials
    BICalltrials = experiments{k,cm}.getBIC();
    
    BICgmm = experiments{k,cm}.getBestBIC();
%     BICgmmkm = experiments{k,4}.getBestBIC();

    %
    BICMeanError(k-1,1) = mean(BICalltrials);
    BICError(k-1,1) = BICgmm;
%     BICError(k-1,2) = BICgmmkm;
    
    
end

plot(2:15,BICError(:,1),'bd--');
hold on
plot(2:15,BICMeanError,'ro--');
hold off
% title(sprintf('BIC values for %s',experimentIDtoString(cm)));
ylabel('BIC','FontSize',20);
xlabel('K clusters','FontSize',20);
legend('Best run','Mean (10 trials)')
set(gca,'FontSize',15)
end

function methstring = experimentIDtoString(cm)
if cm == 1
    methstring = 'k-means';
elseif cm == 2
    methstring = 'GMM random';
elseif cm == 3
    methstring = 'k-means++';
elseif cm == 4
    methstring = 'GMM from KM++';
end
end

function [] = plotGMMContrib(experiments, cm, experimentdir)
   
    for k = 2:15
        
        results = experiments{k,cm}.getResults();
        trial = experiments{k,cm}.bestRun();
        
        P = results(trial).P;
        cidx = results(trial).cidx;
        h = figure(3000);
        plotEMComponentContributions(k,cidx,P);
        
        fname = sprintf('contrib.eps');
        if cm == 2
            subdir = sprintf('%d-EM-images',k)
        else
            subdir = sprintf('%d-EMfromKMPP-images',k)
        end
        print(h,fullfile(experimentdir,subdir,fname),'-depsc2');
        clf   
    end
end
function [] = plotFtest(experiments,cm)

    methstring = experimentIDtoString(cm);

    Fratio = zeros(15,1);
    for k = 2:15
        Fratio(k) = experiments{k,cm}.Fratio(experiments{k,cm}.bestRun());

    end

    plot(2:15,Fratio(2:15),'rx--')
    %  ax1 = plot(2:15,[icv2/mean(co2),icv3/mean(co3),icv4/mean(co4),icv5/mean(co5),icv6/mean(co6),icv7/mean(co7),icv8/mean(co8),mean(co9)/icv9,mean(co10)/icv10,mean(co11)/icv11,mean(co12)/icv12,mean(co13)/icv13,mean(co14)/icv14,mean(co15)/icv15],'rx--')
    xlabel('K','FontSize',16)
    ylabel('F-ratio','FontSize',16);
    set(gca,'FontSize',16)
    xlim([1,16])
%     title(sprintf('F-ratio - %s',methstring))
end

