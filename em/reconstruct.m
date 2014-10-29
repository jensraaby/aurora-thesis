function [ canvas, E, errors, K ] = reconstruct( mu, cov, alpha, img, component_selection, plotit, quant )
%RECONSTRUCT Reconstruct an image as a set of Gaussian components
% assume that the input image is normalised to sum to 1!
% MU - set of mean values
% COV - set of covariance matrices
% ALPHA - set of mixing weights
% IMG - original image
% COMPONENT_SELECTION - how components are selected. 
% Either a scalar: 
%   1 => all components, 
%   2 => top 50% of components ordered by ALPHA, 
%   3 => top 25% of components ordered by ALPHA, 
%   else plot the mixing weights in order for analysis) 
% Or a vector identifying which component indices to include
if nargin < 6
    plotit = 0
end

    
    % compute the coordinates needed:
    [R,C] = size(img);
    [rs,cs] = meshgrid(1:R,1:C);

    rs_ = reshape(rs,1,R*C);
    cs_ = reshape(cs,1,R*C);
    coords = [rs_',cs_'];
    
    % first determine which components to use
    if isscalar(component_selection)
        if component_selection == 1
            % all components - do nothing, but sort by mixing weight
            [~,ind] = sort(alpha);

        elseif component_selection == 2
            % top 50% components

            % sort the mixing coefficients
            cutoff = median(alpha);
            ind1 = find(alpha>cutoff);
            ind = sort(ind1);
        elseif component_selection == 3
            % top 25% components
%             y = quantile(ss,[0.25, 0.5, 0.75])
            % sort the mixing coefficients
            if nargin < 7
                quant = 0.75
            end
            cutoff = quantile(alpha,quant);
            ind1 = find(alpha>cutoff);
            ind = sort(ind1);
        else
            % find the point at which the mixing coefficients increase
            meansofar = 0;
            stdsofar = 0;
            valsofar = [];
            stds = [];
            means = [];
            cnt = 0;
            [a,ind] = sort(alpha);
            ss = []
            for i = 1:length(alpha)
    %             disp(['value: ' num2str(a(i))])
    %             a(i)

                if a(i) > (4 * meansofar)
                    disp(['jumped' num2str(i)])
                    cnt = cnt + 1;
                end
                valsofar = [valsofar; a(i)];
                meansofar = mean(valsofar);
                stdsofar = std(valsofar);

                if (i>1)
                    stepsize = a(i) - a(i-1);
                else
                    stepsize = 0;
                end
                ss = [ss; stepsize];
                stds = [stds; stdsofar];
                means = [means; meansofar];
               disp(['std: ' num2str(stdsofar)])
            end

            y = quantile(a,[0.25, 0.5, 0.75]) ;

           
            figure(1)
            subplot(131)
            plot(stds)
            hold on

             hold off
            title('standard deviations');

            subplot(132)
            plot(valsofar)
            title('values');
            hold on
            % the 75% line:
            plot([0, 100], [y(3), y(3)], 'r');
            % the 50% line:
            plot([0, 100], [y(2), y(2)], 'g');
            hold off

            subplot(133)
            plot(ss)
            hold on 
            y = quantile(ss,[0.25, 0.5, 0.75]) 
            plot([0, 100], [y(3), y(3)], 'r');
            hold off
            title('step size');
        end
    else % component selection is vector
        if isvector(component_selection)
            ind = component_selection;
        else
            error('Bad component selection. Use a scalar or a vector of indices');
        end
    end

    % create a blank canvas
    canvas = zeros(size(img));
    
    K = length(ind);
    
    % store the errors with the components so far
    errors = zeros(1,K);
    for index = 1:K
        % since we might use a subset, we need extra index
        i = ind(index);
        
        Mu = mu(i,:);
        Sig = cov(:,:,i);
        mix = alpha(i);
        
        thislayer1 = mvnpdf(coords,Mu,Sig);
        thislayer2 = reshape(thislayer1,C,R);
        thislayer = mix * thislayer2';

        canvas = canvas + thislayer;
        
    % store the reconstruction error 
        errors(index) = rmsthresh(img,canvas*sum(img(:)));
    end
   
%    
     E = errors(K);
     if (plotit)
%         he = figure(100);
        plot((errors));
        title('Error over time')
        xlabel('Components included');
        ylabel('Thresholded RMS Error');
        
     end
     
end

