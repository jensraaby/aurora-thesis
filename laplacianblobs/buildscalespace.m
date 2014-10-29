function [ scalespace, blurred, hessian ] = buildscalespace( If, scales )
%BUILDSCALESPACE Build 3D matrix of multiscale normalised laplacians and
%the corresponding blurred images
% hessian is a numscale x (numpixel x 3) matrix with columns Lxx Lxy Lyy for each pixel

%   [ scalespace, laplacian, hessian ] = buildscalespace( If, scales )

    if nargout >= 2
       blurring = 1; 
    else
       blurring = 0;
    end
    if nargout >= 3
        secondorder = 1;
    else
        secondorder = 0;
    end
    
    
    scalespace = zeros(size(If,1),size(If,2),length(scales));
    if blurring
        % use the same dimensions for the blurred image
        blurred = scalespace;
    end
    if secondorder
        % this is a big set of second order derivatives for each and every
        % pixel
        hessian = zeros(numel(If),3,length(scales)); 
    end
    
    for n = 1:length(scales)
        sigmaD = scales(n);

        % get the 2nd order derivatives - note this will contain negatives
        Lxx = real(ifft2(scale(If, sigmaD, 0, 2)));
        Lyy = real(ifft2(scale(If, sigmaD, 2, 0)));
        
        % by adding this multiplication we normalise (to counteract
        % blurring's effect on intensity)
        scalespace(:, :, n) = sigmaD^2 *(Lxx + Lyy);
        
        if blurring
            % this is just a Gaussian blur of the image at scale sigmaD
            blurred(:, :, n) = real(ifft2(scale(If, sigmaD, 0, 0)));
        end
        
        if secondorder
            % need an additional 2nd order derivative of the image for the hessian
            Lxy = real(ifft2(scale(If, sigmaD, 1, 1)));
            hessian(:,:,n) = [Lxx(:), Lxy(:), Lyy(:)];

        end
    end
end

