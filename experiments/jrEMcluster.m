function [ cidx, ctrs, AIC, BIC, P, Sigma, gm, mahalaD ] = jrEMcluster( data, k, initCentroids, initIDX, fullcovariance)
%jrEMcluster This is a wrapper for the built in EM clustering functions
%   This allows me to change things later if necessary
% [ cidx, ctrs, AIC, BIC, P, Sigma, gm ] = jrEMcluster( data, k, initCentroids, initIDX, fullcovariance)

if size(data,2) > size(data,1)
    disp('warning: more dimensions than data points!')
end

if nargin < 5
    fullcovariance = 0;
end

if fullcovariance
    covtype = 'full';
else
    % default is diagonal - fewer parameters to estimate!
    covtype = 'diagonal';
end

if nargin > 2
    % in this case we have existing centroids (means) and clusters (IDX)
%     use the IDX as our initialisation
  initGMM = initIDX;
%     d = size(data,2);
%     n = size(data,1);
%     %d-by-d-by-k if there are no restrictions on the form of the covariance. In this case, sigma(:,:,I) is the covariance of component I.
%     %1-by-d-by-k if the covariance matrices are restricted to be diagonal, but not restricted to be same across components. In this case, sigma(:,:,I) contains the diagonal elements of the covariance of component I.
%     covariance0 = zeros(d,d,k);
%     mean0 = zeros(k,d);
%     p0 = zeros(k,1); % prior probability
%     
%     for j=1:k
%         p0(j) = length(find(initIDX==j)) / n;
%         mean0(j,:) = initCentroids(j,:);
%         
%         % get the data for this cluster so we can compute covariance
%         jdata = data(initIDX==j,:);
%         covariance0(:,:,j) = cov(jdata);
%     end
%     
%     if strcmp(covtype,'diagonal')
%         newcov = zeros(1,d,k);
%         disp('NOTE: DIAGONAL COVARIANCES')
%         for j = 1:k
%             newcov(:,:,k) = diag(covariance0(:,:,k))
%         end
%         initGMM.Sigma = newcov;
%     else
%         initGMM.Sigma = covariance0;
% 
%     end
%     % now wrap this up in a gmdistribution!
%     initGMM.mu = mean0;
%     initGMM.PComponents = p0;
    
 
else
    % randomly pick initial clusters
    initGMM = 'randSample';
end


% pass in to a fitter
options = statset('Display','final','MaxIter',1000);
gm = gmdistribution.fit(data,k,'Options',options,'CovType',covtype,'regularize',eps,'Start',initGMM);



% make a fit
[ cidx,NlogL,P,logpdf,mahalaD] = cluster(gm,data);

P = posterior(gm,data);
ctrs = gm.mu;
Sigma = gm.Sigma;


AIC = gm.AIC;
BIC = gm.BIC;

end

