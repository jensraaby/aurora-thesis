function [ W,alpha,mu,cov ] = update( img, components, alphas, mus, sigmas )
%UPDATE Update the parameters for a gaussian component


W = next_w(img,components,alphas, mus, sigmas);

% alpha = alphas;
% mu = mus;
% cov = sigmas;
alpha = next_alpha(img, W, components);
mu = next_mu(img, W, components);
cov = next_covariance(img, W, mu, components);


end


function w_mn = next_w(img, components, alphas, mus, sigmas)
    % m is the index of the component 
    % we need an m for every pixel n
    % assume that the other values are all at the value from the previous
    % iteration
    
    if size(mus) ~= [components,2]
        error('Wrong size mu')
    end
        
    if size(sigmas,1) ~= 2 || size(sigmas,2) ~= 2
        error('Covariance matrices wrong shape')
    end
    if size(sigmas,3) ~= components
        error('Wrong number of covariance matrices')
    end
    
    w_mn = zeros(components, numel(img));
    img_norm = inorm(img);
    N = numel(img);
    [i,j] = ind2sub(size(img),1:N);
    
    
    denominator = zeros(1,N);
    
    N_m = zeros(components, N);
    % now compute the components and the denominator for the weights
    %  the sum over all the components of the weighted Gaussian evaluations
    for m = 1:components
        N_m(m,:)    = gaussian(i,j,mus(m,:),sigmas(:,:,m));
        denominator = denominator + (alphas(m) * N_m(m,:));
    end
    
    
    % now compute weights using the normalised intensities:
    for m = 1:components
       
       % mix coeff * gaussian value * normalised intensity
         numerator = alphas(m) * N_m(m,:);

    % there will be numeric errors unless I do this:
        this_w = numerator ./ denominator;
        this_w(find(numerator==0)) = 0;
        this_w(find(denominator==0)) = 0;
        % now multiply through with the normalised pixels
        w_mn(m,:)  = this_w' .* img_norm(:);
    end

end

function imgNorm = inorm(img)
% First normalise image to have max value 1
% Then divide each pixel by the sum of all pixels (giving a PD of sorts)
    img = img/max(img(:));
    imgNorm = img/sum(img(:));
end

function v = gaussian(x,y, mu, sigma)
% this is the normalised PDF. should normalise it!
    X = [x',y'];
    v = mvnpdf(X, mu, sigma);
    v = v/max(v);
end



function A = next_alpha(img, W_mn, components)
% Compute the mixing weights for the next iteration
    N = numel(img);
    A = zeros(components,1);
    for m = 1:components
        A(m) = 1/N * sum(W_mn(m,:));
    end
end


function mu = next_mu(img, W_mn, components)
% Compute the means for the next iteration
    N = numel(img);
% mean is the 2D centre of the component
    mu = zeros(components,2);
    % get the x,y coordinates for all N pixels
    [I,J] = ind2sub(size(img),1:N);
    % each component has a mean based on the weightings
    for m = 1:components
        num = [0,0];
        for n = 1:N
            num = num + ([I(n), J(n)] * W_mn(m,n));
        end
        mu(m,:) = num / sum(W_mn(m,:));
    end
end

function cov = next_covariance(img, W, mu, components)
% compute the covariances - the big computation!
    cov = zeros(2,2,components);
    N = numel(img);
    % we subtract the means from each pixel location (i,j)
    [I,J] = ind2sub(size(img),1:N);
    
    % this loop can be optimised!!
    for m = 1:components
        num = zeros(2,2);
        for n = 1:N
           p = [I(n); J(n)] - mu(m,:)';
           
           num = num + (W(m,n) * (p * p')); 
        end
        cov(:,:,m) = num/sum(W(m,:));
    end
end


function [] = test()
    img = imgs_cart(:,:,1)
    components = 10;
    alphas = zeros(components,1);
    ws = zeros(components, numel(img));
    mus = zeros(components,2);
    sigmas = zeros(2,2,components);

    [~] = update(img, components, alphas, ws, mus, sigmas);
    
end