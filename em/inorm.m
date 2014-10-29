function imgNorm = inorm(img)
% First normalise image to have max value 1
% Then divide each pixel by the sum of all pixels (giving a PD of sorts)
img = img/max(img(:));
imgNorm = img/sum(img(:));
end