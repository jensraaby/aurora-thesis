function [ mu0, sigma0, alpha0 ] = initialise_components( siz, K, scale )
%INITIALISE_COMPONENTS Given the dimensions of the image, randomly
%initialise the mean positions and scales for the Gaussian functions


% initial mixing weights (all the same)
alpha0 = 1/K * ones(K,1);

% initial means
% should ideally be the local maxima or random
% local maxima is not a good method here!
mu0 = zeros(K,2);

mu0 = rand(size(mu0));
mu0(:,1) = mu0(:,1) * siz(1); % rows
mu0(:,2) = mu0(:,2) * siz(2); % cols

% clamp mean to a real coordinate.
% during optimisation it will float around between natural coordinates
mu0 = round(mu0);

% initialise the covariance to simple scaled identity matrix
sigma0 = repmat(scale * eye(2),[1,1,K]);



end

