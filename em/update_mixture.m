function [ W_mn,alpha,mu,cov ] = update_mixture( img, components, alphas, mus, sigmas )
%UPDATE_MIXTURE Update the parameters for a gaussian mixture model



    if size(mus) ~= [components,2]
        error('Wrong size mu')
    end

    if size(sigmas,1) ~= 2 || size(sigmas,2) ~= 2
        error('Covariance matrices wrong shape')
    end
    if size(sigmas,3) ~= components
        error('Wrong number of covariance matrices')
    end

    % Solve the weights
    W_mn = zeros(components, numel(img));
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
        this_w(find(numerator==0)) = eps;
        this_w(find(denominator==0)) = 0;
        % now multiply through with the normalised pixels
        W_mn(m,:)  = this_w' .* img_norm(:);
    end




    % Compute the mixing weights for the next iteration
    alpha = zeros(components,1);
    for m = 1:components
        % in the paper, they normalise with 1/N
        % but then the sum of all alphas is not 1
        % and then we have to compensate with the scaling for
        % reconstruction
        alpha(m) = sum(W_mn(m,:));
    end


    % Compute the means for the next iteration
    % mean is the 2D centre of the component
    mu = zeros(components,2);
    % get the x,y coordinates for all N pixels
    [I,J] = ind2sub(size(img),1:N);
    % each component has a mean based on the weightings
    
    for m = 1:components
        % this is 20s faster per iteration!
        num = sum([I;J] .* repmat(W_mn(m,:),2,1),2);
%         for n = 1:N
%             num = num + ([I(n), J(n)] * W_mn(m,n));
%         end
%         mu(m,:) = num / sum(W_mn(m,:));
mu(m,:) = num/sum(W_mn(m,:));
    end

    % compute the covariances - the big computation!
    cov = zeros(2,2,components);

    for m = 1:components
        
        % vectorised code is 50 times faster but harder to explain
        P = bsxfun(@minus, [I;J], mu(m,:)');
        
        X = P(1,:);
        Y = P(2,:);
        
        % compute the 3 distinct parts of the covariance matrix
        XX = sum(W_mn(m,:) .* X .* X);
        XY = sum(W_mn(m,:) .* X .* Y);
        YY = sum(W_mn(m,:) .* Y .* Y);
        
        num = [XX, XY;...
               XY, YY];
        

        cov(:,:,m) = num/sum(W_mn(m,:));
        
        if illConditioned(cov(:,:,m),1)
            disp('bad components? ')
            m
            % reset it!
            cov(:,:,m) = [5,1;1,5];
            
           
        end
    end
end

function v = illConditioned(covariance,minallowedscale)
    % check the covariance matrix
    cs = sort( [ covariance(1,1), covariance(2,2)]);
    
    % compare the ratio. if one is a lot smaller, then this will be very
    % small
    v = min(cs) < minallowedscale;
    
end


function imgNorm = inorm(img)
% First normalise image to have max value 1
% Then divide each pixel by the sum of all pixels (giving a PD of sorts)
img = img/max(img(:));
imgNorm = img/sum(img(:));
end

function v = gaussian(x,y, mu, sigma)
% this is the PDF (ie. the estimate for the component). 
v = mvnpdf([x',y'], mu, sigma);
% v = v/max(v); % do we need to normalise here?
end

