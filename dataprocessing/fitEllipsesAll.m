function [] = fitEllipsesAll()
% fitellipses

workingevents = '/Users/jens/Desktop/Aurora-Working/EventsProcessing/';
intensityscale = 4.3;

ellipsehandle = @(x,outdir,fname) fitEllipseToImage(x,outdir, fname, intensityscale);
eventhandle =   @(x) processEvent2mat(ellipsehandle, x,'mat','oval');
batchProcessEvents(eventhandle,workingevents,1);

end

function [tosave] = fitEllipseToImage(infile,outdir,fname,intensityscale)
    I = infile.image256;
    Iscl = I*intensityscale;
    
    thresh = std(Iscl(:))
    
    % initial fit: quite small, and right in the middle of the image
    initialfit = [128 128 50 50 0];
    
    % we first vary vertical position
    guesses = generateInitialGuesses(initialfit, 2, 10, 5);
    [opt1,indopt1] = selectOptimalEllipse(Iscl,guesses, thresh);
    
    % now vary best stretch in vertical direction
    guesses = generateInitialGuesses(opt1, 3, 2, 5);
    [opt2,indopt2] = selectOptimalEllipse(Iscl,guesses, thresh);
    
    % pick vary stretch in horz direction
    guesses = generateInitialGuesses(opt2, 4, 2, 5);
    [opt3,indopt3] = selectOptimalEllipse(Iscl,guesses, thresh);
    
    % plot the resulting fit
    h = figure(2);
    set(h,'Visible','off')
    drawEllipseOnImage(Iscl,opt3(1),opt3(2),opt3(3),opt3(4),opt3(5));
    fnameout = fullfile(outdir,[fname '.png'])
    print(h,fnameout,'-dpng')
    close(h);
    jheapcl();
   
    % tosave should be a struct that can be saved to a mat
    tosave = opt3;

end


function guesses = generateInitialGuesses(initialvec,parmtochange,jumpval,numjumps)
% build a matrix of initial values, with one dimension varied with the
% specified jump interval
    
    % vector of offsets for the selected parameter
    varyvals = (numjumps/2:numjumps/2) * jumpval;
    guesses = repmat(initialvec,numjumps,1);
    guesses(:,parmtochange) = guesses(:,parmtochange) + varyvals';
end

% function to pick the best Ellipse fit with a number of initial guesses
function [opt,indopt] = selectOptimalEllipse(I, guesses, thresh)
    numtotry = size(guesses,1);
    fval = zeros(1,numtotry);
    opts = zeros(size(guesses));
    for i = 1:numtotry
        [opts(i,:),fval(i)] = fit_ellipse( I, 2, guesses(i,:), 0, thresh);
    end
    
    [~,indopt] = min(fval);
    opt = opts(indopt,:);

end


