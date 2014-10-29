function [ blobs, scales, strengths, blurred, meanintensities, eigenvals,eigenvecs ] = detectBlobs( I, initialscale, numscales, thres, show, growthrate )
%DETECTBLOBS Extract multiscale blobs
% [ blobs, scales, strengths ] = detectBlobs( I, initialscale, numscales, thres, show, growthrate )
%   NUMSCALES and INITIALSCALE should be fairly obvious
%   THRES determines a cutoff for feature strength in the laplacian image
%   SHOW will plot blobs on a figure
    
    imsize = size(I);
    if nargin < 6
        growthrate = 1.1;
    end
    if nargin >= 6
        calculatehessian = 1;
    else
        calculatehessian = 0;
    end
    
    channels = size(I,3);
    if channels ~= 1
        error('grayscale only!');
    end

    % fourier transform of I, used for building scale space version
    If = fft2(double(I));
    
    if length(initialscale) > 1
        % then the argument is a list of scales
        scales = initialscale;
    else
        % exponential scale
        scales = generateScaleVector(initialscale,numscales,growthrate);
    end

    % build scalespaces
    % ss is the 3D matrix of normalised laplacians
    % blurred is the 3D matrix of Gaussian blurred images (used for getting
    % intensity information)
    % hessians is the multiscale hessian values for each pixel - this is
    % big!
    [ss, blurred, hessians] = buildscalespace(If,scales);
    
    
    % find maxima by switching sign (think of the shape of a laplacian)
    
    Maxima = LocalMaxima3DFastIntermediate(-ss);
    idx=find(Maxima ~= 0);

    % remove those blobs which are below a threshold
    idxidx = find(abs(Maxima(idx)) > thres);
    
    
    % get the subscript indices for the maxima
    % note s is the index into the ss matrix
    [r, c, s] = ind2sub(size(Maxima), idx(idxidx));

    % now get the actual scales and put them in the structure
    % note that the C code will be offset by 1 (IGNORE)
    blobs = [r, c, scales(s)'];
    
    % get the actual feature strength
    strengths = -ss(idx(idxidx));
    
    % the mean intensity for a blob is the intensity in the blurred version
    meanintensities = blurred(idx(idxidx));
    
    if calculatehessian
        % store in simple row per blob matrices
        eigenvals = zeros(length(idxidx),2);
        eigenvecs = zeros(length(idxidx),4);
        
        % now let's get the eigen values/vectors because this is useful later on
        for b=1:length(r)
            [evalue,evec] = blobEigen(hessians,imsize,r(b),c(b),s(b));
           
            eigenvals(b,:) = evalue;
            
            % unpack vectors into a row of 4
            eigenvecs(b,:) = [evec(:,1)', evec(:,2)'];
        end
        
    end
    
    
    if show==1
        plotBlobsImage(I, blobs, 0);
    end
end

function [eigenvalues, eigenvectors] = blobEigen(hessians, imsize, r, c, s)

% indices need to be linear because the hessian is stored in a pixel-per-
% row matrix
    [linind] = sub2ind(imsize,r,c);
    % now extract hessian for this row/col
    hessian = hessians(linind,[1 2 2 3],s);
    % compute eigenvalues/vectors
    [eigenvectors,d] = eig(reshape(hessian,2,2));
    eigenvalues = diag(d);
end
