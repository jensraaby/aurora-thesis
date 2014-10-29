function [] = replotClusters(experimentdir, version, saveplot, prefix)
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

features = experiments{1,1}.features;
ks = 1:15;
for o = 1:length(ks)
    K = ks(o);
    
    % load the experiments
    experimentkm = experiments{o,1};
    experimentem = experiments{o,2};
    experimentkmplusplus = experiments{o,3};
    experimentemkpp = experiments{o,4};

    
     %if we are saving images, then create a subdir for each experiment
     % and save the closest plot images
    if saveplot
        
        % 1: km
        outsubdir = sprintf('%s%d-images',prefix,K);
        outdir = fullfile(experimentdir,outsubdir);
        if ~isdir(outdir)
            mkdir(outdir);
        end
        trial = experimentkm.bestRun();
        nclosest = 7;
        results = experimentkm.getResults();
        ctrs = results(trial).ctrs;
        [idxplot,dists] = experimentkm.closestIndices(trial,nclosest);
        plotClosest(idxplot, featuresobj, dists, ctrs, outdir, 'k-means random');
        
        
        % 2:  em
        outsubdir = sprintf('%s%d-EM-images',prefix,K);
        outdir = fullfile(experimentdir,outsubdir);
        if ~isdir(outdir)
            mkdir(outdir);
        end
        trial = experimentem.bestRun();
        
        results = experimentem.getResults();
        ctrs = results(trial).ctrs;
        [idxplot,dists] = experimentem.EMclosestIndices(trial,nclosest,features);
        plotClosest(idxplot, featuresobj, dists, ctrs, outdir,'GMM random');
        
        % 3: kmeans++
        outsubdir = sprintf('%s%d-kmeansPP-images',prefix,K);
        outdir = fullfile(experimentdir,outsubdir);
        if ~isdir(outdir)
            mkdir(outdir);
        end
        trial = experimentkmplusplus.bestRun();
        
        results = experimentkmplusplus.getResults();
        ctrs = results(trial).ctrs;
        [idxplot,dists] = experimentkmplusplus.EMclosestIndices(trial,nclosest,features);
        plotClosest(idxplot, featuresobj, dists, ctrs, outdir, 'k-means++');
        
        % 4:  em with KM
        outsubdir = sprintf('%s%d-EMfromKMPP-images',prefix,K);
        outdir = fullfile(experimentdir,outsubdir);
        if ~isdir(outdir)
            mkdir(outdir);
        end
        trial = experimentem.bestRun();
        
        results = experimentem.getResults();
        ctrs = results(trial).ctrs;
        [idxplot,dists] = experimentem.EMclosestIndices(trial,nclosest,features);
        plotClosest(idxplot, featuresobj, dists, ctrs, outdir,'GMM from KM');
        
    end
end

end

function [] = plotClosest(idxs,featuresobj, dists, ctrs, outdir, method)
% save a grid of closest images to disk
    
    K = size(idxs,1); % how many clusters
    rows = 2;
    cols = 4;
    if nargin < 6
        method = 'k-Means';
    end
    
    % loop over each cluster
        for c = 1:K   
            idx = idxs(c,:);
            ctr = ctrs(c,:);
            nitems = length(idx);
            hs = figure(c+10);
            
set(hs,'Visible','off');

% 
% axes1 = axes('Visible','off','Parent',hs,'YDir','reverse',...
%     'TickDir','out',...
%     'Position',[0.05 0.505 0.2175 0.445],...
%     'Layer','top',...
%     'DataAspectRatio',[1 1 1],...
%     'CLim',[0 1]);
            %plot the features image
%             vl_tightsubplot(rows,cols,1,'MarginBottom',10);

   axesHandles(1) = subtightplot(2,4,1,[0.05,0.01],[0.05],[0.1]);
            featuresobj.plotGenericFeatures(ctr,0);
            text(25,25,'Centroid','FontSize',7,'BackgroundColor',[.7 .9 .7])
            title(sprintf('Cluster %d of %d, Method: %s',c,K,method),'FontSize',8);
     

    
            % loop over images in the cluster
            for im = 1:(rows*cols)-1
%                 vl_tightsubplot(rows,cols,im+1,'MarginBottom',10);
                axesHandles(im+1) = subtightplot(2,4,im+1,[0.05,0.01],[0.05],[0.1]);
                
                if idx(im) ~= 0
                    featuresobj.plotEventFeatures(idx(im));

                    hold on
                    title(sprintf('Distance = %0.2f',dists(c,im)));
                    
                    [~,filepath] = featuresobj.getPeakImage(idx(im));
                    [~,filename] = fileparts(filepath);
                    text(25,25,filename(1:12),'FontSize',7,'BackgroundColor',[.7 .9 .7])
                    hold off
                else
                    % just white
                    imshow(ones(256,256));
                end
                axis image % hide axis numbers
                    set(gca,'xtick',[])
                    set(gca,'xticklabel',[])
                    set(gca,'ytick',[])
                    set(gca,'yticklabel',[])
                %             imshow(imagesC(:,:,im),[]);
            end
          
                fname = sprintf('k%d-%d.eps',K,c);
%                 export_fig(hs,fullfile(outdir,fname), '-eps','-transparent');

% 850 by 400 is a bit too big on print
aspectr = 400/850;
width = 600;
height = width * aspectr;
                set(hs,'position',[1,1,width,height])
                export_fig(hs,fullfile(outdir,fname),'-eps','-transparent')
%                 print(hs,fullfile(outdir,fname),'-depsc2')
                close(hs)
            
            
        end

    
end