function [ h ] = plotBlobsImage( I, blobs, sigma, outdir, fname, plotimage )
%PLOTBLOBSIMAGE SIGMA applies a gaussian blur
%   Detailed explanation goes here

% iptsetpref('ImshowBorder','tight');

 
if sigma ~= 0
    I = gaussianblur(I,sigma);
end

if nargout > 0
    h=figure();
     set(gcf,'Visible', 'off'); 
    clf
end

% if nargin >= 4
%     set(gcf,'Visible', 'off'); 
%     clf
%     
% end

if nargin < 6
    plotimage = 1;
end
    
% added so we can just plot the features on their own
if plotimage
    imshow(I,[]);
end
hold on
numblobs = length(blobs);

for b = 1:numblobs
     
    plot(blobs(:,2), blobs(:,1), 'r.', 'MarkerSize',5.1);
    plotcircle([blobs(:,2), blobs(:,1)], blobs(:,3), 'r');
    
end
hold off;


% added guard against passing in an empty dir
if nargin >= 4 && ~strcmp(outdir,'')% this means we are saving the fig
    axis image

    
    
    % gahhhhhhhhhhhhhhh
    ti = get(gca,'TightInset');
set(gca,'Position',[ti(1) ti(2) 1-ti(3)-ti(1) 1-ti(4)-ti(2)]);

set(gca,'units','centimeters')
pos = get(gca,'Position');
ti = get(gca,'TightInset');

set(gcf, 'PaperUnits','centimeters');
set(gcf, 'PaperSize', [pos(3)+ti(1)+ti(3) pos(4)+ti(2)+ti(4)]);
set(gcf, 'PaperPositionMode', 'manual');
set(gcf, 'PaperPosition',[0 0 pos(3)+ti(1)+ti(3) pos(4)+ti(2)+ti(4)]);

    % file save:
    fnamepng = strrep(fname,'.mat','.png');
    fullpath = fullfile(fileparts(outdir),fnamepng);
%     axis normal,box off
% axis image
%     set(gca,'LooseInset',get(gca,'TightInset'))
    print(h,'-dpng',fullpath)
    
end

end

