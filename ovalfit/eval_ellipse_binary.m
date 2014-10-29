function [ y, axisratio, minaxislength ] = eval_ellipse_binary( binimage, ellipsefit, nellipses, steps )
%EVAL_ELLIPSE_BINARY Evaluate ellipse fits
%   Detailed explanation goes here


CentreX = ellipsefit(1);
CentreY = ellipsefit(2);
StretchX = ellipsefit(3);
StretchY = ellipsefit(4);
Angle = ellipsefit(5);

% one central ellipse
ellipse = calculateEllipse(CentreX,CentreY,StretchX,StretchY,Angle, steps);
ellx = ellipse(:,1);
elly = ellipse(:,2);

% nellipses determines the number of extra ellipses on either side of the
% central ellipse
if nellipses > 1
    ellipse_in = calculateEllipse(CentreX,CentreY,StretchX-1,StretchY-1,Angle, steps);
    ellipse_out = calculateEllipse(CentreX,CentreY,StretchX+1,StretchY+1,Angle, steps);
    
    ellx = [ellx; ellipse_in(:,1);  ellipse_out(:,1);];
    elly = [elly; ellipse_in(:,2);  ellipse_out(:,2);];
    
    if nellipses > 2
        ellipse_in2 = calculateEllipse(CentreX,CentreY,StretchX-2,StretchY-2,Angle,steps);
        ellipse_out2= calculateEllipse(CentreX,CentreY,StretchX+2,StretchY+2,Angle,steps);
        
        ellx = [ellx; ellipse_in2(:,1);  ellipse_out2(:,1);];
        elly = [elly; ellipse_in2(:,2);  ellipse_out2(:,2);];
        
        if nellipses > 3
            ellipse_in3 = calculateEllipse(CentreX,CentreY,StretchX-2,StretchY-2,Angle,steps);
            ellipse_out3= calculateEllipse(CentreX,CentreY,StretchX+3,StretchY+3,Angle,steps);
            ellx = [ellx; ellipse_in3(:,1);  ellipse_out3(:,1);];
            elly = [elly; ellipse_in3(:,2);  ellipse_out3(:,2);];
        end
    end
end
%
% if nellipses > 1
%
%     ellipse_in = calculateEllipse(CentreX,CentreY,StretchX-1,StretchY-1,Angle);
%     ellipse_in2 = calculateEllipse(CentreX,CentreY,StretchX-2,StretchY-2,Angle);
%
%
%     ellipse_out = calculateEllipse(CentreX,CentreY,StretchX+1,StretchY+1,Angle);
%     ellipse_out2= calculateEllipse(CentreX,CentreY,StretchX+2,StretchY+2,Angle);
%
%     ellx = [ellipse(:,1); ellipse_in(:,1); ellipse_in2(:,1); ellipse_in3(:,1); ellipse_out(:,1); ellipse_out2(:,1); ellipse_out3(:,1)];
%     elly = [ellipse(:,2); ellipse_in(:,2); ellipse_in2(:,2); ellipse_in3(:,2); ellipse_out(:,2); ellipse_out2(:,2); ellipse_out3(:,2)];
% else
%
%     ellx = ellipse(:,1);
%     elly = ellipse(:,2);
% end

% sample the intensity under the oval
oval_intensity = interp2(binimage,ellx,elly);

% objective is the sum - assume this is the binary
y = sum(oval_intensity);

if nargout > 1
    % get the order of the axis lengths
    axissort = sort([StretchX,StretchY]);
    % ratio is smallest over biggest. as they diverge
    axisratio = axissort(1)/axissort(2);
%     axisratio2 = axissort(2)/axissort(1);
end
if nargout > 2
   minaxislength = min([StretchX, StretchY]);
end
end

