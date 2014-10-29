function [ cidx, ctrs, sumd, d ] = jrKMeans( data, k, vlf)
%JRKMEANS This is a wrapper for the built in kmeans function
%   This allows me to change things later if necessary
% [ cidx, ctrs, sumd, d ] = jrKMeans( data, k)

% adding online phase guarantees the solution is a local minimum of the
% distance criteria (moving any point will increase the sum of distances to
% the centroid

if (nargin>2 && vlf == 1)
    % use ++ seeds
    
%     init = seeds(data',k);
    % init has a row for each dimension and a column for each cluster
%     [cidx,ctrs,sumd,d] = kmeans(data,k,'onlinephase','on', 'start',init');
    
%     % note everything is transposed with vl_feat
    [C, A, ENERGY] = vl_kmeans(data', k,'Initialization','PLUSPLUS', 'verbose', 'distance', 'l2');
    ctrs = C';
    cidx = A';
    sumd = ENERGY;
%     
else
    % use completely random seeds
    
    [cidx,ctrs,sumd,d] = kmeans(data,k,'onlinephase','on');
    
    
end
end

% % function for computing initial centroids for k-means++
% % % Written by Michael Chen (sth4nth@gmail.com).
% % http://www.mathworks.com/matlabcentral/fileexchange/34504-k-means++-kmeans-algorithm-with-smart-seeding/content/kmeanspp/kmeanspp.m
% function m = seeds(X, k)
% [d,n] = size(X);
% m = zeros(d,k);
% v = inf(1,n);
% m(:,1) = X(:,ceil(n*rand));
% for i = 2:k
%     Y = bsxfun(@minus,X,m(:,i-1));
%     v = cumsum(min(v,dot(Y,Y,1)));
%     m(:,i) = X(:,find(rand < v/v(end),1));
% end
% 
% end