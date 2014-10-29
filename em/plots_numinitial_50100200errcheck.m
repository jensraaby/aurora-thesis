
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

% Cartesian conversion
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

[M,N,Q] = size(imgs_cart);

%% Try different number of initial components
% try initialising the mixture model with different numbers of components,
% and see whether 
% 1: convergence differs
% 2: final reconstruction error differs
% 3: actual error differs across the images in a consistent way

% Store the values of the components and the errors in a mat file

% Some parameters
init_K = [50, 100, 200];

image_ids = 1:2; % all images

step = 0.0001; % how much to reduce by each time
epsilon = 0.0001; % precision for stopping criteria

scale = 20; % initial covariance scale
siz = [M,N];

% iterations:
it = 25;


 % get the coordinates
[rs,cs] = meshgrid(1:M,1:N);

rs_ = reshape(rs,1,M*N);
cs_ = reshape(cs,1,M*N);
coords = [rs_',cs_'];
    
% errors
errors_all = [];

% START LOOPING #####################################
for k = init_K
    
    for imgid = image_ids
        
        img = imgs_cart(:,:,imgid);

        % get initial values
        [ mu0, sigma0, alpha0 ] = initialise_components( siz, k, scale );

        alpha = alpha0;
        mu = mu0;
        cov = sigma0;
        errors = [];
        for iteration = 1:it


            h = figure(1);
            subplot(211);
            imagesc(img);
            axis image
            hold on
            for m = 1:length(mu)
                plot(mu(m,2), mu(m,1),'wo');
            end
            hold off

            subplot(212);

            % show all components
            [ canvas, E, errorsit ] = reconstruct( mu, cov, alpha, img, 1, 0 );
            imagesc(canvas)
            axis image
            disp(['iteration ' num2str(iteration) ' rmsE: ' num2str(E)]);
            errors = [errors; E];

%             print(h,'-depsc2',[figures_path '/' num2str(imgid) '_' num2str(k) 'components_iter' num2str(iteration) '.eps']);
            
            
            
            
            % Expectation Maximisation of the model parameters
            [ W,alpha,mu,cov ] = update_mixture( img, k, alpha, mu, cov );
    
            % Save the intermediate state
            tracing(iteration) = struct('W',W,'alpha',alpha,'mu',mu,'cov',cov);

        end
        % Save the error plot
        h2 = figure(2)
        plot(errors, 'r-');
        title(sprintf('RMS Error convergence, %s',names{imgid}));
        xlabel('Iteration');
        ylabel('RMS Error for reconstructed image');
%         print(h2,'-depsc2',[figures_path '/errors_' num2str(imgid) '_' num2str(k) 'components.eps']);

        errors_all = [errors_all; errors];

         % test the error threshold
        [E, eimg] = rmsthresh(img, canvas*sum(img(:)));
        herr = figure(666);
        imagesc(eimg)
        axis image
        
        
        fname = [num2str(imgid) '_' num2str(k) '_components.mat'];
        
%         save(['data/' fname], 'mu0', 'sigma0', 'alpha0', 'W', 'cov', 'mu', 'alpha');
%         save(['data/' fname], 'mu0', 'sigma0', 'alpha0', 'tracing');
        
        clear tracing
    end % loop images
    
end % loop num components








