function [ blurred ] = gaussianblur( I, sigma )
%GAUSSIANBLUR Summary of this function goes here
%   Detailed explanation goes here
    If = fft2(double(I));
    
    G = scale(If,sigma,0,0);
    
    blurred = real(ifft2(G));

end

