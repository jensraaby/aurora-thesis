
% load in the usual paths and data
clear all 
clc
close all

% load in the functions and data
root_path = '/Users/Jens/Dropbox/Computer Science/Aurora/';
mat_path = [root_path 'mat/'];
addpath([root_path 'Code/aurora-project/functions/']);
addpath([root_path 'Code/aurora-project/basic_scripts/']);

% addpath('/Users/jens/Documents/Matlab/export_fig/');
figures_path = [root_path 'Figures/em'];

[imgs,imgs_norm,names] = loadNSPolar(mat_path);

%% Cartesian conversion
[K,N,Q] = size(imgs_norm);
resolution=360;
startdeg = 360;
finishdeg = 0;

imgs_cart = zeros(180,360,Q);
for q = 1:Q
    rect = polar_conversion(imgs_norm(:,:,q), resolution,startdeg,finishdeg);
% trim off the bottom (outside the mask)
    rect = rect(1:180,:);
    imgs_cart(:,:,q) = rect;
end

[K,N,Q] = size(imgs_cart);


%% GMM spots method
imgid = 2;

img = imgs_cart(:,:,imgid);
K = 100; % components


% initial mixing weights (all the same)
a0 = 1/K * ones(K,1);

% initial means
% should ideally be the local maxima or random
% local maxima is not a good method here!
mu0 = zeros(K,2);

mu0 = rand(size(mu0));
mu0(:,1) = mu0(:,1) * size(img,1); % rows
mu0(:,2) = mu0(:,2) * size(img,2); % cols

% clamp to a real coordinate
mu0 = round(mu0)

% initialise the covariance to simple scaled identity (stupid value)
% sig0 = zeros(2,2,M);
sig0 = repmat(20 * eye(2),[1,1,K]);


    % get the coordinates
    [R,C] = size(img);
    [rs,cs] = meshgrid(1:R,1:C);

    rs_ = reshape(rs,1,R*C);
    cs_ = reshape(cs,1,R*C);
    coords = [rs_',cs_'];
    
    
%% Expectation Maximisation

%expectation: log likelihood
% 
% maxll = max (log_lh,[],2);
% %minus maxll to avoid underflow
% post = exp(bsxfun(@minus, log_lh, maxll));
% %density(i) is \sum_j \alpha_j P(x_i| \theta_j)/ exp(maxll(i))
% density = sum(post,2);
% %normalize posteriors
% post = bsxfun(@rdivide, post, density);
% logpdf = log(density) + maxll;
% ll = sum(logpdf) ;
% 
% 

alpha = a0;
mu = mu0;
cov = sig0;
errors = [];
for iteration = 1:20
    
    
    h = figure(1);
    subplot(211);
    imagesc(img);
    axis image
    hold on
    for m = 1:length(mu)
        plot(mu(m,2), mu(m,1),'wo');
    end
    hold off
    max(img(:))
    
    subplot(212);
    canvas = zeros(size(img));
    
    sorted_alpha = sort(alpha);
    
    for i = 1:K
        
        Mu = mu(i,:);
        Sig = cov(:,:,i);
        mix = alpha(i);
        
        if (mix >= sorted_alpha(50))
        thislayer1 = mvnpdf(coords,Mu,Sig);
        % normalising messes up the mixing weights
%         thislayer1 = thislayer1/max(thislayer1);
        
        thislayer2 = reshape(thislayer1,C,R);
        thislayer = mix * thislayer2';
%         size(thislayer)
        %     max(thislayer(:))
        canvas = canvas + thislayer;
        end
    end
    
    % try to scale the reconstruction to closest match the image
    max_orig = max(img(:));
    % first scale so max is 1, and scale by original max:
    norm_canvas = canvas/max(canvas(:));
%     norm_canvas = norm_canvas * max_orig;
    
    % now search for the best scalar for error minimisation
    min_error = 0.02;
    step = 0.0001;
    factor = max_orig;
    E = 2;%rmserror(img,norm_canvas)
    while E>min_error
        factor = factor -step;
        E1 = rmserror(img,factor * norm_canvas);
        
        if (E1 <= (E*1.0001)) && (E1 >= (E*(1-0.0001)))
            break
        end
            
        E = E1;
    end
    imagesc(canvas)
    axis image
    disp(['iteraion ' num2str(iteration) ' rmsE: ' num2str(E)]);
    errors = [errors; E];
      
    % expectation
    % compute the log likelihood
    
%     subplot(133)
%     plot(errors);
%     title('RMSE');
    
     print(h,'-depsc2',[figures_path '/' num2str(imgid) '_' num2str(K) '_iter' num2str(iteration) '_error' num2str(E) '.eps']);
    % maximisation of the model parameters
     [ W,alpha,mu,cov ] = update_mixture( img, K, alpha, mu, cov );
end

%%
