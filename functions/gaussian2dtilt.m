function gauss = gaussian2dtilt(x,y, Amplitude, Offset, sigma, centre, theta)
    xc = centre(1);
    yc = centre(2);
    sigmax = sigma(1);
    sigmay = sigma(2);

    % tilted - so use cos/sin
    xs = (x-xc)*cos(theta) + (y-yc)*sin(theta);
    ys =-(x-xc)*sin(theta) + (y-yc)*cos(theta);
    
    exponent = (xs.^2/2/sigmax^2 + ...
                 ys.^2/2/sigmay^2);
    
    gauss = Amplitude*exp(-exponent)+Offset;

end