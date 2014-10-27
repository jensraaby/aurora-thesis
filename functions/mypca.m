function [PC,score,latent,pcexplained] = mypca(X, method)
% MYPCA - use SVD to compute the PCA. X is assumed to have a row for each
% observation.
% METHOD - use 1 for my implementation. otherwise we use Matlab's own.


if nargin < 2
    % default to matlab's own PCA
    [PC,score,latent,~,pcexplained] = pca(X,'Algorithm','svd');

else
    if method == 1
        % using SVD
        disp('PCA: my SVD method');
    
    
        [M,N] = size(X);
    
        % subtract mean from each observation
        X_0 = X - repmat(mean(X,1),M,1);
    
    
    % construct the special Y matrix
        Y = X_0 / sqrt(M - 1);
%     
%     
%         [V D] = eig(Y.' * Y)
%         S=sqrt(D)
%         U = Y * V * S^(-1)
        
        
        [U,Sigma,PC] = svd(Y,0);
        
    
        S = diag(Sigma);
        latent = S.*S;
    
        % invert the sign of the pcs
        PC = -1 * PC;
        
        % project data to give scores
        score = (PC' *  X_0')';
    
%     score = bsxfun(@times,U,S');
        pcexplained = 100*latent/sum(latent);
    
        
        % delete unneeded components
        [idx0] = find(latent == 0);
        score(:,idx0) = [];
        PC(:,idx0) = [];
        latent(idx0) = [];
        pcexplained(idx0) = [];
        
        
         
    
    else
        % otherwise call matlab's version
        [PC,score,latent,~,pcexplained] = pca(X,'Algorithm','svd');

    end



end



