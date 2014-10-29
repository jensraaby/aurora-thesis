function [version] = doClustering(experimentdir, featuresobj, ks, n, description, saveimages)
%%% inputs:
% experimentdir - where to save the working data
% featuresobj - an AbstractFeature instance which can be saved and used for generating images from the clusters

% ks - a vector of cluster sizes
% n - how many trials to run for each clustering experiment
% description - short description of experiment features

test = 1;

% increment this if anything about the data is changed
version = 5;

% now we have 4 experiments
% kmeans (1)
% GMM with random init (2)
% kmeans++ (3)
% GMM with kmeans++ init (4)

features = featuresobj.getNormalisedFeatures(0); % not zero centred
experiments = cell(length(ks),4);
for o = 1:length(ks)
    
    
    K = ks(o);
    experimentkm = ClusteringExperiment(sprintf('%s k-means %d',description,K), features, 'kmeans', K, n, test);
    
    experimentem = ClusteringExperiment(sprintf('%s GMM %d',description,K), features, 'gmm', K, n, test);
    
    experimentkmplusplus = ClusteringExperiment(sprintf('%s k-means++ %d',description,K), features, 'kmeans++', K, n, test);

    % does not run for k = 1
    experimentemkpp = ClusteringExperiment(sprintf('%s GMM with KM++ init %d',description,K), features, 'gmmkm', K, n, test);

    % outdir = '/Users/jens/Desktop/Aurora-Working/Experiments/';
    % save(fullfile(outdir,'test.mat'), 'experiment1');
    
    % save all the experiments to the cell array
    experiments{o,1} = experimentkm;
    experiments{o,2} = experimentem;
    experiments{o,3} = experimentkmplusplus;
    experiments{o,4} = experimentemkpp;

    %if we are saving images, then create a subdir for each experiment
    if saveimages
        
        % 1: km
        outsubdir = sprintf('%d-images',K);
        outdir = fullfile(experimentdir,outsubdir);
        if ~isdir(outdir)
            mkdir(outdir);
        end
        trial = experimentkm.bestRun();
        nclosest = 8;
        results = experimentkm.getResults();
        ctrs = results(trial).ctrs;
        [idxplot,dists] = experimentkm.closestIndices(trial,nclosest);
        plotClosest(idxplot, featuresobj, dists, ctrs, outdir, 'k-means random');
        
        
        % 2:  em
        outsubdir = sprintf('%d-EM-images',K);
        outdir = fullfile(experimentdir,outsubdir);
        if ~isdir(outdir)
            mkdir(outdir);
        end
        trial = experimentem.bestRun();
        nclosest = 8;
        results = experimentem.getResults();
        ctrs = results(trial).ctrs;
        [idxplot,dists] = experimentem.EMclosestIndices(trial,nclosest,features);
        plotClosest(idxplot, featuresobj, dists, ctrs, outdir,'GMM random');
        
        % 3: kmeans++
        outsubdir = sprintf('%d-kmeansPP-images',K);
        outdir = fullfile(experimentdir,outsubdir);
        if ~isdir(outdir)
            mkdir(outdir);
        end
        trial = experimentkmplusplus.bestRun();
        nclosest = 8;
        results = experimentkmplusplus.getResults();
        ctrs = results(trial).ctrs;
        [idxplot,dists] = experimentkmplusplus.EMclosestIndices(trial,nclosest,features);
        plotClosest(idxplot, featuresobj, dists, ctrs, outdir, 'k-means++');
        
        % 4:  em
        outsubdir = sprintf('%d-EMfromKMPP-images',K);
        outdir = fullfile(experimentdir,outsubdir);
        if ~isdir(outdir)
            mkdir(outdir);
        end
        trial = experimentem.bestRun();
        nclosest = 8;
        results = experimentem.getResults();
        ctrs = results(trial).ctrs;
        [idxplot,dists] = experimentem.EMclosestIndices(trial,nclosest,features);
        plotClosest(idxplot, featuresobj, dists, ctrs, outdir,'GMM from KM');
        
    end

end


fname = fullfile(experimentdir,sprintf('clusteringdata-%d.mat',version));

save(fname,'experiments','featuresobj');
fprintf('Done clustering - saved to %s',fname);


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

                set(hs,'position',[1,1,850,400])
                export_fig(hs,fullfile(outdir,fname),'-eps','-transparent')
%                 print(hs,fullfile(outdir,fname),'-depsc2')
                close(hs)
            
            
        end

    
end