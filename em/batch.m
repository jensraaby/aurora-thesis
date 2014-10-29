
% load in the usual paths and data
clear all 
clc
close all

% load in the functions and data
root_path = '/Users/Jens/Dropbox/Computer Science/Aurora/';
mat_path = [root_path 'mat/'];
addpath([root_path 'Code/aurora-project/functions/']);
addpath([root_path 'Code/aurora-project/basic_scripts/']);
addpath([root_path 'Code/aurora-project/experiments/em']);

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


%% Batch processing

% type:
% 1 - reconstruct with all components
% 2 - reconstruct with only top half (above median value)
% 3 - something a little cle
type = 1;

% iterations:
it = 25;

% save figures?
fname_prefix = [figures_path '/'];

%%
step = 0.0001; % how much to reduce by each time
epsilon = 0.0001; % precision for stopping criteria
imgid = 2;
for imgid = 2:2

img = imgs_cart(:,:,imgid);
K = 100; % components
scale = 20; % initial covariance scale
siz = size(img);
[ mu0, sigma0, alpha0 ] = initialise_components( siz, K, scale );

    % get the coordinates
    [R,C] = size(img);
    [rs,cs] = meshgrid(1:R,1:C);

    rs_ = reshape(rs,1,R*C);
    cs_ = reshape(cs,1,R*C);
    coords = [rs_',cs_'];
    
    
% Expectation Maximisation

% change this if we want to keep reusing the same initialisations
alpha = alpha0;
mu = mu0;
cov = sigma0;
errors = [];
for iteration = 1:it
    
    
    h = figure(1);
    subplot(211);
    imagesc(inorm(img));
    axis image
    colorbar()
    hold on
    for m = 1:length(mu)
        plot(mu(m,2), mu(m,1),'wo');
    end
    hold off
    
    subplot(212);
    canvas = zeros(size(img));
    
    sorted_alpha = sort(alpha);
    
    for i = 1:K
        
        Mu = mu(i,:);
        Sig = cov(:,:,i);
        mix = alpha(i);
        
        % determine which components to use for reconstruction
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
%     min_error = 0.02;
%     step = 0.0001;
%     factor = max_orig;
%     E = 2;%rmserror(img,norm_canvas)
%     while E>min_error
%         factor = factor -step;
%         E1 = rmserror(img,factor * norm_canvas);
%         
%         if (E1 <= (E*1.0001)) && (E1 >= (E*(1-0.0001)))
%             break
%         end
%             
%         E = E1;
%     end
 f = max_orig;
    E = 0.5;%rmserror(img,norm_canvas)
    E1 = rmserror(inorm(img),canvas)
    disp('ssim')
    Es = ssim(inorm(img)*f,canvas*f,[0.01 0.03],fspecial('gaussian', 11, 1.5),max(max(inorm(img))))
    
    % Gradient descent to find the best overal scaling factor
    % stop criteria -> convergence
    while ~(abs(E1-E) < epsilon)       
        E = E1;
        f = f-step;
        E1 = rmserror(img,f * norm_canvas);
    end
    
    disp(['scale: ' num2str(f)]);
    
E = rmserror(inorm(img),canvas,1)
%     imagesc(f * norm_canvas)
imagesc(canvas)
    axis image
    colorbar()
    disp(['iteraion ' num2str(iteration) ' rmsE: ' num2str(E)]);
    errors = [errors; E];
      
    % expectation
    % compute the log likelihood
    
%     subplot(133)
%     plot(errors);
%     title('RMSE');
    
%      print(h,'-depsc2',[figures_path '/' num2str(imgid) '_' num2str(K) 'components_iter' num2str(iteration) '_error' num2str(E) '.eps']);
    % maximisation of the model parameters
     [ W,alpha,mu,cov ] = update_mixture( img, K, alpha, mu, cov );
     
     data(iteration) = struct('W',W,'alpha',alpha,'mu',mu,'cov',cov);
%      cov(find(cov(1,1,:)==0)) = eps;
%      for m = 1:K
%         if (cov(1,1,m)) == 0
            
%      end
figure(2), plot(errors)
end
%
end
%%
