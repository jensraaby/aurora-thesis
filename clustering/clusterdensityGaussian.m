% density estimate for some point

% variables:
% K  =number of gaussian components
% N = number of points
% \sigma = variances within cluster
% x = input point

function [BIC,AIC] = clusterdensityGaussian(X,K,ctrs,cidx)
    
% dims:
    P = size(X,2);
% points:
    N = size(X,1);
    
  
    
    Vk = zeros(K,P);
    for k = 1:K
        
       Vk(k,:) = var(X(cidx==k,:));
    end
    Vall = var(X);
    
    loglikelihood = zeros(1,K);
    ltemp = bsxfun(@plus,Vk,Vall);
    
    for k =1:K
        
        ltemp2 = log(ltemp(k,:))/2;
        ltemp3 = sum(ltemp2);
        
        
        nk = length( find(cidx==k));
        loglikelihood(k) = -nk * ltemp3;
%         -nx * sum(log(),1)
    end
    
    
%     BIC
BIC = -2 * sum(loglikelihood) + 2*K*P * log(N);
BIC1 = sum(loglikelihood) - ((K*P +1)/2*log(N));
% AIC
AIC = -2 * sum(loglikelihood) + 4*K*P;
AIC1 = sum(loglikelihood) - (K*P + 1);

% nParam = nParam + k-1 + k * obj.NDimensions;
%     obj.BIC = 2*NlogL + nParam*log(n);
%     obj.AIC = 2*NlogL + 2*nParam;


  
    % compute within cluster variance
%     workingSqDiff = zeros(K,P);
%     for k = 1:K
%         thisC = X(cidx==k,:);
%         
%         yi = bsxfun(@minus,thisC,ctrs(k,:));
%         y2 = sum(abs(yi).^2, 1);
%         
%         workingSqDiff(k,:) = y2;%var(X(cidx==ki,:));
%         
%     end
%     % here we get the within-cluster variance:
%     sigmasqd = sum(workingSqDiff,1) / N;
%     sigma = sqrt(sigmasqd);
    % compute the density for each point in the clustering
%     dists2closestc=zeros(nx,1);
%     for k = 1:K
%         kx = X(cidx==k,:);
%         siglocal = var(kx);
%         temp = mvnpdf(kx,ctrs(k,:),siglocal);
%         dists2closestc(cidx==k) = temp;
%     end
%     dists2closestc



 %     p = zeros(nx,K);
%     for k = 1:K
%         % get the probabilities of all the points in this cluster
%         p(:,k) = mvnpdf(X,ctrs(k,:),sigma);
%     end
%     % this is the P (density) from the paper
%     density = sum(p,2) / K;
%     likelihood = prod(density)


%     p = zeros(nx,ndims);
%     for j = 1:nx
%        uj = X(j,:);
%        pj = zeros(K,ndims);
%        % sum over all clusters
%        for ki = 1:K
%            k = ks(ki);
%            ytmp = normpdf(uj,ctrs(ki,:),sigma);
%            pj(ki,:) =  pj(ki,:) + ytmp;
%        end
%        p(j,:) = sum(pj)./K;
%     end
    
    % now calculate density of entire dataset
%     likelihood = prod(p);
    
    % now we have enough:
%     Q = P;
%     AIC = log(likelihood) - ((K*Q)+1)
%     BIC = log(likelihood) - ( ((K*Q)+1)/2 * log(N))
    %%
%     for j = 1:N
%         
% %         pj = zero
%         for k = 1:length(ks)
%            k = ks(k);
%            mu = ctrs(k,:);
%            workingSqDiff = var(
%         end
%         
%     end
%     % for each cluster, get the respective density
%     for ki = 1:length(ks)
%        k = ks(ki);
%        px = zeros(k,ndims);
%        for kk = 1:k
%            % compute variances (note this is sigma^2)
%            Xk = X(cidx==kk,:);
%            sigma = var(Xk);
%            mu = ctrs(kk,:);
%            
%            for xi = 1:size(Xk,1)
%                 px(kk,:) = px(kk,:) + normpdf(Xk(xi,:),mu,sigma);
%            end
%            px(kk,:) = px(ll,:)/
%        end
%        densities{ki} = px;
%     end
% 

% standard normalised Gaussian: normpdf
% y = exp(-0.5 * ((x - mu)./sigma).^2) ./ (sqrt(2*pi) .* sigma);


% end