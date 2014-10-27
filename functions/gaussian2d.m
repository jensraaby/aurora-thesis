function gauss = gaussian2d(x,y, Amplitude, Offset, Sigma, centre)
    xc = centre(1);
    yc = centre(2);
    
    xs = (x-xc);
    ys = (y-yc);
    
    normalise = 1/((2*pi)*sqrt(det(Sigma)));
    exponent = (1/2 * ([x-xc;y-yc]' * inv(Sigma) * [x-xc;y-yc]));
    
    gauss = Amplitude*normalise*exp(-exponent) +Offset;

end