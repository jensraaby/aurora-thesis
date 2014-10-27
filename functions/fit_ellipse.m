function [ opt,fval ] = fit_ellipse( img, method, initialguess, show, thresh, Xmin,Xmax )
%%% FIT_ELLIPSE_LINOPT
% [ opt,fval ] = fit_ellipse( img, method, initialguess, show, thresh, Xmin,Xmax )
% IMG  - image to fit to
% METHOD - 1 for Simanneal, 2 for Neldermead
% set some sensible starting point in INITIALGUESS
% parameters are:
% centre row, centre column, height, width, rotation
% SHOW - set to 1 to plot the fitted ellipse
% THRESH - optional - set fixed threshold - this switches objective
% function

if nargin < 6
% Bounded values used for simanneal method:
 Xmin = [100,100,90,90,0];
% may need to restrict more
 Xmax = [400,400,150,150,360];
end

% create a function to minimise:
if nargin < 5
    ellipse_minimiser = @(X) -ellipse_sum_objective(X,img,0);
    disp('Using max intensity objective');
else
    % if we use the threshold method then use a different objective
    % function
    ellipse_minimiser = @(X) -ellipse_thresh_objective(X,img,0,thresh);
    disp('Using max coverage objective');
end

% call the optimisation routine:
if method == 1
    % SIMULATED ANNEALING
    [opt,fval] = simulannealbnd(ellipse_minimiser,initialguess,Xmin,Xmax);

elseif method == 2
    % NELDER MEAD 
    [opt,fval] = fminsearch(ellipse_minimiser,initialguess);

else
    error('Invalid method')
end
if show == 1

    if nargin < 5
        ellipse_sum_objective(opt,img,1);
        
    else
        ellipse_thresh_objective(opt,img,1, thresh);
    end
    
end

end


% this is an objective function based on the total intensity under the
% ellipse

function y = ellipse_sum_objective(X0,Image,Draw)
    CentreX = X0(1);
    CentreY = X0(2);
    StretchX = X0(3);
    StretchY = X0(4);
    Angle = X0(5);

    ellipse = calculateEllipse(CentreX,CentreY,StretchX,StretchY,Angle);
    ellipse_in = calculateEllipse(CentreX,CentreY,StretchX-1,StretchY-1,Angle);
    ellipse_in2 = calculateEllipse(CentreX,CentreY,StretchX-2,StretchY-2,Angle);
    ellipse_in3 = calculateEllipse(CentreX,CentreY,StretchX-2,StretchY-2,Angle);

    ellipse_out = calculateEllipse(CentreX,CentreY,StretchX+1,StretchY+1,Angle);
    ellipse_out2= calculateEllipse(CentreX,CentreY,StretchX+2,StretchY+2,Angle);
    ellipse_out3= calculateEllipse(CentreX,CentreY,StretchX+3,StretchY+3,Angle);


    if (Draw)
        imagesc(Image);
        axis square;
        hold on
        plot(ellipse(:,1),ellipse(:,2),'r-','LineWidth',2);
        hold off
    end

     ellx = [ellipse(:,1); ellipse_in(:,1); ellipse_in2(:,1); ellipse_in3(:,1); ellipse_out(:,1); ellipse_out2(:,1); ellipse_out3(:,1)];
    elly = [ellipse(:,2); ellipse_in(:,2); ellipse_in2(:,2); ellipse_in3(:,2); ellipse_out(:,2); ellipse_out2(:,2); ellipse_out3(:,2)];


    % sample the intensity under the oval
    oval_intensity = interp2(Image,ellx,elly);

    % objective is the sum
    y = sum(oval_intensity);
end

% an alternative objective function - count number of points with intensity
% above a threshold
function y = ellipse_thresh_objective(X0,Image,Draw, thresh)
    CentreX = X0(1);
    CentreY = X0(2);
    StretchX = X0(3);
    StretchY = X0(4);
    Angle = X0(5);

    ellipse = calculateEllipse(CentreX,CentreY,StretchX,StretchY,Angle);
    ellipse_in = calculateEllipse(CentreX,CentreY,StretchX-1,StretchY-1,Angle);
    ellipse_in2 = calculateEllipse(CentreX,CentreY,StretchX-2,StretchY-2,Angle);
    ellipse_in3 = calculateEllipse(CentreX,CentreY,StretchX-2,StretchY-2,Angle);

    ellipse_out = calculateEllipse(CentreX,CentreY,StretchX+1,StretchY+1,Angle);
    ellipse_out2= calculateEllipse(CentreX,CentreY,StretchX+2,StretchY+2,Angle);
    ellipse_out3= calculateEllipse(CentreX,CentreY,StretchX+3,StretchY+3,Angle);

    if (Draw)
        imgthr = Image;
        imgthr(Image<thresh) = 0;
        imagesc(imgthr);
        axis square;
        hold on
        plot(ellipse(:,1),ellipse(:,2),'r-','LineWidth',1);
        plot(ellipse_in(:,1),ellipse_in(:,2),'r-','LineWidth',1);
        plot(ellipse_in2(:,1),ellipse_in2(:,2),'r-','LineWidth',1);
        plot(ellipse_out(:,1),ellipse_out(:,2),'r-','LineWidth',1);
        plot(ellipse_out2(:,1),ellipse_out2(:,2),'r-','LineWidth',1);
        plot(ellipse_out3(:,1),ellipse_out3(:,2),'r-','LineWidth',1);

        hold off
    end

    ellx = [ellipse(:,1); ellipse_in(:,1); ellipse_in2(:,1); ellipse_in3(:,1); ellipse_out(:,1); ellipse_out2(:,1); ellipse_out3(:,1)];
    elly = [ellipse(:,2); ellipse_in(:,2); ellipse_in2(:,2); ellipse_in3(:,2); ellipse_out(:,2); ellipse_out2(:,2); ellipse_out3(:,2)];

    % sample the intensity under the ovals
    oval_intensity = interp2(Image,ellx,elly);

    % a negative thresh inverts the direction of the comparison
    if thresh>0
        % objective is the number of points > thresh
        idx = find(oval_intensity>thresh);
    else
        idx = find(oval_intensity<-thresh);
    end
    y = length(idx);
    
end