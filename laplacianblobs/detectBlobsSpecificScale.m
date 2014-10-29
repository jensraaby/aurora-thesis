function [ blobs, scales ] = detectBlobsSpecificScale( I, scales, thres, show )
%DETECTBLOBS Extract multiscale blobs
%   NUMSCALES and INITIALSCALE should be fairly obvious
%   THRES determines a cutoff for feature strength in the laplacian image
%   SHOW will plot blobs on a figure

    
    channels = size(I,3);
    if channels ~= 1
        error('grayscale only!');
    end

    % fourier transform of I
    If = fft2(double(I));

    % build scalespaces

% ssDBL = buildscalespace(If,scalesDBL);
    ss = buildscalespace(If,scales);
    
    % find maxima by switching sign (think of the shape of a laplacian)
    Maxima = LocalMaxima3DFastIntermediate(-ss);
    idx=find(Maxima > 0);
    idxidx = find(abs(Maxima(idx)) > thres);

    % get the subscript indices for the maxima
    % note s is the index into the ss matrix
    [r, c, s] = ind2sub(size(Maxima), idx(idxidx));

    % now get the actual scales and put them in the structure
    % note that the C code will be offset by 1
    blobs = [r, c, scales(s-1)'];
    
    
% %     blobs = vl_covdet(im2single(immatrix),'EstimateAffineShape', true);
%     [blobs, ~, ~] = vl_covdet(im2single(I),'EstimateAffineShape', true) ;
%     if show == 1
%        imagesc(I);
%        hold on;
%        vl_plotframe(blobs);
%        hold off;
%        info
%     end
    
    % note on output: the frames are matrices 1x2 and 2x2 
%     http://www.vlfeat.org/overview/covdet.html

    if show==1
       plotBlobsImage(I, blobs, 22);
    end
end
