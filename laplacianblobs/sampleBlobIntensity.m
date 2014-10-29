function [ maxint, totalint, meanint, sample ] = sampleBlobIntensity( I, blobc, blobr, blobscale )
%SAMPLEBLOBINTENSITY Gets the max, total and mean intensity from the raw
%image
    
  
    sample = getBlobPixels(I, blobc, blobr, blobscale);
    
    maxint = max(sample(:));
    totalint = sum(sample(:));
    meanint = mean(sample(:));
end

