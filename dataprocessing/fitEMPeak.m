% function [] = fitEMPeak()
% fits EM gaussian 2D components to the image

workingevents = '/Users/jens/Desktop/Aurora-Working/EventsProcessing/';
intensityscale = 4.3;
compselection = 1; % use all components

rootoutdir = '/Users/jens/Desktop/Aurora-Working/EMPeak/';

[imgs, imgs_norm, names, eventdirs] = loadPeakImages(workingevents);

% 
% ellipsehandle = @(x,outdir,fname) fitEllipseToImage(x,outdir, fname, intensityscale);
% eventhandle =   @(x) processEvent2mat(ellipsehandle, x,'mat','oval');
% batchProcessEvents(eventhandle,workingevents,1);

%% cartesian conversion
[M,N,Q] = size(imgs_norm);
% %%%%%%%%%%%%%%%%%
saveIt = 1;
%%%%%%%%%%%%%%%%%
resolution = 360;
startdeg = 360;
finishdeg = 0;

imgs_cart = zeros(128,resolution,Q);

for q = 1:Q
    rect = polar_conversion(imgs_norm(:,:,q),resolution, startdeg, finishdeg);
    
    imgs_cart(:,:,q) = rect;
end

[M,N,Q] = size(imgs_cart);

% COMPONENTS
init_K = [50]; % [50,100,200];

image_ids = 1:length(names);

step = 0.0001;
epsilon = 0.0001;

scale = 5;
siz = [M,N];

it = 25;


% get the coordinates
[rs,cs] = meshgrid(1:M,1:N);

rs_ = reshape(rs,1,M*N);
cs_ = reshape(cs,1,M*N);
coords = [rs_',cs_'];

%% loop over k and images
E = 1;
for k = init_K
    
    for imgid = image_ids
        
        img = imgs_cart(:,:,imgid);
        
        % initialisation
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
            colorbar()
            hold on
            for m = 1:length(mu)
                plot(mu(m,2), mu(m,1),'wo');
            end
            hold off

            subplot(212);

           
            Eold = E;
            [ canvas, E, errorsit ] = reconstruct( mu, cov, alpha, img, compselection, 0 );
            
            
            if (Eold-E < -0.02) & (iteration > 5)
                disp('error value increased - stopping')
                Eold
                E
                break
            end
            
             % show all components
            imagesc(canvas*sum(img(:)))
            colorbar()
            axis image
            disp(['iteration ' num2str(iteration) ' rmsE: ' num2str(E)]);
            errors = [errors; E];

            if saveIt==1
                fname = sprintf('%s-%dcomponents-iter%d.png',names{imgid},k,iteration);
                if ~isdir(fullfile(eventdirs{imgid},'emfit'))
                    mkdir(eventdirs{imgid},'emfit')
                end
                fullfilename = fullfile(eventdirs{imgid},'emfit',fname);
                print(h,'-dpng',fullfilename);
                close(h);
%             print(h,'-depsc2',[figures_path '/' num2str(imgid) '_' num2str(k) 'components_iter' num2str(iteration) '.eps']);
            end
            
            
            
            % Expectation Maximisation of the model parameters
            [ W,alpha,mu,cov ] = update_mixture( img, k, alpha, mu, cov );
    
            % Save the intermediate state
%             tracing(iteration) = struct('W',W,'alpha',alpha,'mu',mu,'cov',cov);

        end % end iterating
        
        if saveIt==1
            fname = sprintf('%d-%s',k,names{imgid});
            fullfilename = fullfile(eventdirs{imgid},'emfit',fname)
                   
            save(fullfilename, 'W', 'cov', 'mu', 'alpha', 'errors');
           fprintf('done with image %s \n',names{imgid})
        end
    end % end image loop
    
    
    
end % end components loop


%end

