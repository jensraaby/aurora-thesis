classdef ClusteringExperiment < handle
    %UNTITLED3 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        description
        trials
        K
        features
    end
    
    % these are used internally
    properties (Access = private)
        log
        test
        method
        results
    end
    
    methods
        
        function obj = ClusteringExperiment(description, features, method, K, Ntrials, test)
            % establish variables
            %             obj.storagedir = experimentdir;
            obj.trials = Ntrials;
            obj.description = description;
            obj.K = K;
            obj.features = features; % a matrix of features
            obj.test = test; % switch for debugging output
            obj.log = {};
            %             obj.results = cell(Ntrials,1);
            
            if strcmp(method,'kmeans')
                obj.method = 1;
            elseif strcmp(method,'gmm')
                obj.method = 2;
            elseif strcmp(method,'kmeans++')
                obj.method = 3;
            elseif strcmp(method,'gmmkm')
                obj.method = 4;
            else
                disp('choosing k-means method')
                obj.method = 1;
            end
            
            fprintf('Created experiment "%s" with %d clusters and %d trials\n',description,K,Ntrials);
            obj.run()
        end
        
        function [] = run(obj)
            % actually run all the experiments and save the results
            
            for n = 1:obj.trials
                obj.logit(sprintf('Running trial %d',n));
                if obj.method == 1
                    % k means
                        [ cidx, ctrs, sumd, d ] = jrKMeans( obj.features, obj.K);
                        obj.results(n).cidx = cidx;
                        obj.results(n).ctrs = ctrs;
                        obj.results(n).sumd = sumd;
                        obj.results(n).d = d;
                        obj.logit('kmeans');
                        
                elseif obj.method == 3
                    %k means ++ (using vl_feat)
                        [ cidx, ctrs, sumd ] = jrKMeans( obj.features, obj.K, 1);
                        obj.results(n).cidx = cidx;
                        obj.results(n).ctrs = ctrs;
                        obj.results(n).sumd = sumd;
                        obj.logit('kmeans++');
                        
                        
                elseif obj.method == 2
                    % gmm
                    obj.logit('gmm ');
                    
                    [ cidx, ctrs, AIC, BIC, P, Sigma, gmm, mahalad ] = jrEMcluster( obj.features, obj.K);
                    obj.results(n).Converged = gmm.Converged;
                    obj.results(n).cidx = cidx;
                    obj.results(n).ctrs = ctrs;
                    obj.results(n).AIC = AIC;
                    obj.results(n).BIC = BIC;
                    obj.results(n).P = P;
                    obj.results(n).Sigma = Sigma;
                    obj.results(n).NLogL = gmm.NlogL;
                    obj.results(n).d = mahalad; %mahalanobis distances :)
                
                 elseif obj.method == 4
                    % gmm but kmeans initialised
                    obj.logit('gmm  with Kmeans++ init');
                    if obj.K == 1
                        Ktemp = 2;
                    else
                        Ktemp = obj.K;
                    end
                    [ cidxKM, ctrsKM ] = jrKMeans( obj.features, Ktemp, 1);
                    obj.results(n).cidxKM = cidxKM;
                    obj.results(n).ctrsKM = ctrsKM;
                    
                    [ cidx, ctrs, AIC, BIC, P, Sigma, gmm, mahalad ] = jrEMcluster( obj.features, Ktemp, ctrsKM, cidxKM);
                    obj.results(n).Converged = gmm.Converged;
                    obj.results(n).cidx = cidx;
                    obj.results(n).ctrs = ctrs;
                    obj.results(n).AIC = AIC;
                    obj.results(n).BIC = BIC;
                    obj.results(n).P = P;
                    obj.results(n).Sigma = Sigma;
                    obj.results(n).NLogL = gmm.NlogL;
                    obj.results(n).d = mahalad; %mahalanobis distances :)
                    
                end
                
                % store results
                %                 obj.results{n} = resultstmp;
            end
        end
        
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Analysis functions
        function [vv, varclusters] = clusterVariance(obj,trial)
            % this function goes through each cluster and finds the
            % variance of the data in that cluster
            % not enough on its own to understand quality
            % note that e
            varclusters = zeros(obj.K, size(obj.features,2));
            dataidx = obj.results(trial).cidx;
            for c = 1:obj.K
                X = obj.features(dataidx==c,:);
                varclusters(c,:) = var(X);
            end
            
            vv = zeros(1,obj.K);
            % now get the l2 norms (euclidean lengths) of these variances
            for c = 1:obj.K
                vv(c) = sum(varclusters(c,:)) ;
            end
            
        end
        
        
        function Fratio = Fratio(obj,trial)
            ctrs = obj.results(trial).ctrs;
            cidx = obj.results(trial).cidx;
            
            Fratio = fratio(obj.features,obj.K,cidx,ctrs);
        end
        
        function [icv,centroidvar] = interclusterVariance(obj,trial)
            % get the variance of the cluster centres
            centroids = obj.results(trial).ctrs;
            centroidvar = var(centroids);
            icv = sum(centroidvar);
        end
        
        function [ccohesion,total_cohesion] = cohesion(obj, trial)
            % measure of cohesion of each cluster or all together
            % cohesion uses the distance of each point to the mean of its
            % cluster
            
            dataidx = obj.results(trial).cidx;
            total_cohesion = 0;
            ccohesion = zeros(1,obj.K);
            for c=1:obj.K
                % get the sum of squared differences for this cluster
                mu = obj.results(trial).ctrs(c,:);
                X = obj.features(dataidx==c,:);
                sumdist = 0;
                % sum the dist from each point
                for p = 1:size(X,1)
                    d = norm((X(p,:) - mu));
                    sumdist = d + sumdist;
                end
                ccohesion(c) = sumdist;
                total_cohesion = total_cohesion + sumdist;
            end
        end
        
        function bss = separation(obj,trial)
            % a measure of cluster separation
            % sum of weighted distances of cluster means to global
            % mean
            Cidx = obj.results(trial).cidx;
            Ctrs = obj.results(trial).ctrs;
            
            globalmean = mean(obj.features);
            bss = 0;
            for c=1:obj.K
                % measure distance from each cluster mean to global mean
                d = globalmean - Ctrs(c,:);
                
                %norm(d) = sqrt(sum(d.^2))
                ssd = norm(d);
                
                csize = length(find(Cidx==c));
                bss = bss + (csize*ssd);
            end
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function [n] = bestRun(obj)
            % this should pick the best clustering according to some
            % criterion - we use the min of the (max inclass) sumd values here
            % kmeans - minimal mean of sumd values
            if obj.method == 1 || obj.method == 3
                % collect the sumd values
                minsumd = max(obj.results(1).sumd);
                n = 1;
                for i = 2:obj.trials
                    s = max(obj.results(i).sumd);
                    
                    if s<minsumd
                        n = i;
                        minsumd = s;
                    end
                end
            elseif obj.method == 2 || obj.method ==4
                % in the case of a GMM, we can use some other measure.
                %
                % separation? GMMs have a tendency to add
                % clusters just to fill gaps. so try and maximise distance
                % between the clusters
                % loglikelihood is another option, or go straight to BIC
                
                n = 1;
                while  ~obj.results(n).Converged
                    n = n+1
                   disp('non converged is best run! Trying next trial') 
                   if n > obj.trials
                       error('no converged runs')
                   end
                end
                bestLL = obj.results(n).NLogL;
                for t = n+1:obj.trials
%                     thissep = obj.separation(t);
                    thisLL = obj.results(t).NLogL;
                    if thisLL < bestLL &&  obj.results(t).Converged
                 
                        % negative so lower is better
                        n = t;
                        bestLL = thisLL;
                    end
                    
                end
               
            end
        end
        
        function BIC = getBIC(obj)
           
            BIC = zeros(obj.trials,1);
            for c = 1:obj.trials
                BIC(c) = obj.results(c).BIC;
            end
        end
        function BIC = getBestBIC(obj)
           
            [n] = obj.bestRun();
           
            BIC = obj.results(n).BIC;
            
        end
        
        function [sil,perclustermean,hsil] = getSilhouette(obj, trial)
            obj.logit('Generating Silhouette');
            % this will compute mean per cluster and mean overall sils
            if nargout > 2
                [sil,hsil] = silhouette(obj.features,obj.results(trial).cidx);
                
            else
                [sil] = silhouette(obj.features,obj.results(trial).cidx);
            end
            
            perclustermean = zeros(obj.K,1);
            for c = 1:obj.K
                perclustermean(c) = mean(sil(obj.results(trial).cidx==c));
            end
        end
        
         function [sils,alltrialsmean,alltrialsstd] = getMeanSilhouette(obj)
            obj.logit('Generating Silhouette');
            % this will compute mean per cluster and mean overall sils
  
            sils = zeros(size(obj.features,1),obj.trials);
            perclustermean = zeros(obj.K,obj.trials);
            perclusterstd =  perclustermean;
            for t = 1:obj.trials
                sil = silhouette(obj.features,obj.results(t).cidx);
                sils(:,t) = sil;
            
                
                for c = 1:obj.K
                    thiscsil = sil(obj.results(t).cidx==c);
                    perclustermean(c,t) = mean(thiscsil);
                    perclusterstd(c,t) = std(thiscsil);
                end
            end
            % mean over all trials
            alltrialsmean = mean(perclustermean,2);
            alltrialsstd = mean(perclusterstd,2);
        end
        
        
        function [sortedclosest,sorteddist] = EMclosestIndices(obj,trial,nclosest,features)
            % we need to find the distances manually :(
            %
            
            sortedclosest = zeros(obj.K,nclosest);
            sorteddist = zeros(obj.K,nclosest);
            cidx = obj.results(trial).cidx;
%             ctrs = obj.results(trial).ctrs;
            
            if obj.method == 3
                dist = obj.generateSqEuclideanDists(trial);
            else
                dist = obj.results(trial).d;
            end
            
            
            for kk=1:obj.K
                % now let's get the idxs of this class's members
                kidx = find(cidx==kk);
                
                % get the distances for these points
                dk = dist(kidx);
                
                % matrix of idx and dist
                sortmat = [kidx, dk];
                
                sortmat = sortrows(sortmat,[2]);
                sorteddist(kk,1:length(kidx)) = sortmat(:,2)';
                if length(kidx) < nclosest
                    disp('not enough points in cluster')
                    sortedclosest(kk,1:length(kidx)) = sortmat(:,1);
                else
                    sortedclosest(kk,:) = sortmat(1:nclosest,1);
                end
%                 
%                
%                 % compare distances of each feature to each centroid
%                 tocompare = [ctrs(kk,:); features(kidx,:)];
%                 
%                 %                 dists = squareform(pdist(tocompare));
%                 %                 % now we have euclidean distance between all point pairs
%                 %                 % distance between cluster centre and points are in
%                 %                 % dists(1,:)
%                 %
%                 %                 comparedists = [kidx, dists(1,2:end)'];
%                 %
%                 %                 [sortedrows] = sortrows(comparedists,[2]);
%                 
%                 
%                 % use matlab style square euclidean distance
%                 D(:,kk) = (features(:,1) - ctrs(kk,1)).^2;
%                 for j = 2:size(features,2)
%                     D(:,kk) = D(:,kk) + (features(:,j) - ctrs(kk,j)).^2;
%                 end
%                 
%                 % now sort the points in this cluster by the distance to
%                 % cluster centroid (stored in D(:,kk))
%                 tosort = [kidx, D(kidx,kk)];
%                 sorteddistk = sortrows(tosort,2);
%                 
%                 % now store all the distances for this K
%                 sorteddist(kk,1:length(kidx)) = sorteddistk(:,2)';
%                 
%                 if length(kidx) < nclosest
%                     disp('not enough points in cluster')
%                     % fill as much as we can
%                     sortedclosest(kk,1:length(kidx)) = sorteddistk(:,1)';
%                 else
%                     
%                     % fill up with the indexes
%                     sortedclosest(kk,:) = sorteddistk(1:nclosest,1)';
%                 end
                
                
                
            end
            %             sorteddist
            disp('closest indices found $EM$')
        end
        
        function [D] = generateSqEuclideanDists(obj,trial)
           %%% distances is an N by K matrix of square euclidean distances
            % use matlab style square euclidean distance
            % store all cluster to point distances
            N = size(obj.features,1);
            D = zeros(N,obj.K);
            ndim = size(obj.features,2);
            cidx = obj.results(trial).cidx;
            ctrs = obj.results(trial).ctrs;
            
%             for n = 1:N
                % for each point, get distance to each centroid
                for kk = 1:obj.K
                    D(:,kk) = (obj.features(:,1) - ctrs(kk,1)).^2;
                    for j = 2:ndim
                        D(:,kk) = D(:,kk) + (obj.features(:,j) - ctrs(kk,j)).^2;
                    end
                end
               
%             end
        end
        
      
        
        function [sortedclosest,sorteddist] = closestIndices(obj,trial,nclosest)
            % basically extract the indices of the NCLOSEST images for each cluster
            % so we can plot the features or whatever
            
            sortedclosest = zeros(obj.K,nclosest);
            sorteddist = zeros(obj.K,nclosest);
            cidx = obj.results(trial).cidx;
            ctrs = obj.results(trial).ctrs;
            
            % now problem is getting the distance with EM
            if obj.method == 1
                dist = obj.results(trial).d;
            elseif obj.method == 3
                dist = obj.generateSqEuclideanDists(trial);
            else
                 error('need to implement distance for EM')
                dist = [];

            end
            
            for kk = 1:obj.K
                % now let's get the idxs of this class's members
                kidx = find(cidx==kk);
                
                
                % get the distances for these points
                dk = dist(kidx);
                
                % matrix of idx and dist
                sortmat = [kidx, dk];
                
                sortmat = sortrows(sortmat,[2]);
                sorteddist(kk,1:length(kidx)) = sortmat(:,2)';
                if length(kidx) < nclosest
                    disp('not enough points in cluster')
                    
                    
                    
                    sortedclosest(kk,1:length(kidx)) = sortmat(:,1);
                else
                    
                    sortedclosest(kk,:) = sortmat(1:nclosest,1);
                end
            end
            
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Utilities
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function r = getResults(obj)
            r = obj.results;
        end
        
        function logit(obj,string)
            if obj.test
                disp(string);
            end
            obj.log = {obj.log ; string};
        end
    end
    
end

