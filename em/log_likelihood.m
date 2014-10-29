function [ ll ] = log_likelihood( img, mu, Sigma, alpha )
%log_likelihood Estimates log likelihood of gaussian parameters on given
%image
%   img is the original image
%   mu is K by 2 matrix
%   Sigma is 2 by 2 by K matrix
%   alpha is K element vector


% normalise the image
img_norm = img;%/max(img);

% reshape image to vector form
img_vector = reshape(img_norm, numel(img_norm), 1);

% coords
[rs,cs] = meshgrid(1:size(img,1),1:size(img,2));
% size(rs(:))
coordmat = [rs(:), cs(:)];


N = numel(img_norm);
K = size(alpha);

% loop over components
for k = 1:K
   S = Sigma(:,:,k);
   % cholesky
   [L,f] = chol(S);
   diagL = diag(L);
   logDetSigma = 2*sum(log(diagL));
   
   % subtract mean from each pixel location
   relocated = bsxfun(@minus, coordmat, mu(k,:));
   
   xRinv = relocated /L ;
   mahalaD(:,k) = sum(xRinv.^2, 2);
   log_lh(:,k) = -0.5 * mahalaD(:,k) +...
            (-0.5 *logDetSigma) - 2*log(2*pi)/2;
end
ll = log_lh;
end

