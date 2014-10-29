function [hessian, Lxx,Lyy,Lxy ] = im2hessian( image, sigma )
%IM2HESSIAN Summary of this function goes here
%   Detailed explanation goes here
if nargin < 2
    sigma = 1;
end

% generate all the derivatives:
If = fft2(image);
Lxx = real(ifft2(scale(If, sigma, 0, 2)));
Lyy = real(ifft2(scale(If, sigma, 2, 0)));
Lxy = real(ifft2(scale(If, sigma, 1, 1)));

% store them in a npixels * 3 matrix 
hessian = [Lxx(:), Lxy(:), Lyy(:)];

% to get these out as a hessian for one pixel use the separate function get
%HessianXY
end


