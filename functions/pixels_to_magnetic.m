function [mlat,mlt] = pixels_to_magnetic(row,col,imsize)
% pixels_to_magnetic - gets the mlt and mlat for the given xy coordinates in an images of width imsize


% get the matrix for the whole image
[mlatmat,mltmat] = generatepixelcoords(40, imsize);

% just convert to actual lats instead of colat
mlatmat2 = abs(bsxfun(@minus,mlatmat,90));
% north pole is then at 90 degrees


% imagesc(mltmat)


% now we want to get the respective mlat and mlt for x and y
if length(row) > 1
    % then we need to do it for each of them
    mlat = zeros(length(row),1);
    mlt = zeros(length(row),1);
    
    for i=1:length(row)
        
        mlat(i) = mlatmat2(row(i),col(i));
        mlt(i) = mltmat(row(i),col(i));
    end
else    
    mlat = mlatmat2(row,col);
    mlt = mltmat(row,col);
end


end



function [row,col] = magnetic_to_pixels(mlat,mlt,imsize)
    


end