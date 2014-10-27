function [SI, C] = shapeindex(If, sigma)
% [SI, C] = shapeindex(If, sigma)


Lxx = real(ifft2(scale(If, sigma, 0, 2)));
Lxy = real(ifft2(scale(If, sigma, 1, 1)));
Lyy = real(ifft2(scale(If, sigma, 2, 0)));


% Koenderinks shape index
SI = 2/pi * atan( (-Lxx - Lyy) ./ sqrt( 4 * Lxy.^2 + (Lxx - Lyy).^2) );
            
% Koenderinks scale normalized curvedness
C = 0.5 * sigma^2 * sqrt( Lxx.^2 + 2 * Lxy.^2 + Lyy.^2 );

return;

