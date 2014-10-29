function tosave = fitEllipse(infile, outdir, fname, intensityscale)
    Iorig = infile.image256;
    I = Iorig*intensityscale;
    
    % 1. blur the image with sigma=sqrt2
    sigma = sqrt(2);
    If = fft2(I);
    Iblur = real(ifft2(scale(If,sigma,0,0)));

    % 2. threshold to create a binary image
    thresh = std(I(:))/2;
    Ibinary = Iblur;
    Ibinary(Iblur > thresh) = 1;
    Ibinary(Iblur <= thresh) = 0;
    
    % 3. create some guesses of ellipse
    % initial guess
    [rows,cols] = size(I);

    % set the initial axis lengths higher as this seems to get a better fit
    initialfit = [rows/2 cols/2 60 60 0];
    guessvariance = [100,100,50,50,180]; % this is variance of the parameters

    % how many points on the ellipse to evaluate:
    steps = 50;
    
    nguesses = 1000;
    % create nguesses random versions of the initial guess
    guessfits = repmat(initialfit, nguesses,1 );

    ellipseguesses = mvnrnd(guessfits,guessvariance);


    % now evaluate all of them
    fval = zeros(1,nguesses);
    ellipsesquash = zeros(1,nguesses);
    minaxislength = zeros(1,nguesses);
    opts = zeros(nguesses,5);
    for i = 1:nguesses

        ellparams = ellipseguesses(i,:);
        [fval(i),ellipsesquash(i),minaxislength(i)] = eval_ellipse_binary( Ibinary, ellparams, 3, steps);
    end
    
    % try to find global min from top 5
    numtoimprove = 5;

    [vsort,vidx] = sort(fval,'descend');
    opts = zeros(numtoimprove,5);
    fval2 = zeros(1,numtoimprove);

    for j = 1:numtoimprove
        optimal = vidx(j);
        [ opts(j,:),fval2(j) ] = fit_ellipse( Iblur, 2, ellipseguesses(optimal,:), 0, thresh );
    end
    [fv,optimal] = min(fval2); 
    bestguess = opts(optimal,:);
    
    % create a plot
    h = figure(1);
     set(h,'Visible','off')
    subplot(141)
    imagesc(I)
    axis image

    subplot(142)
    imagesc(Iblur)
    axis image
    
    subplot(143)
    imagesc(Ibinary)
    axis image
    
    subplot(144)
    drawEllipseOnImage(Iblur,bestguess(1),bestguess(2),bestguess(3),bestguess(4),bestguess(5));
    
    fnameout = fullfile(outdir,[fname '.png'])
    print(h,fnameout,'-dpng')
    close(h);
    tosave = bestguess;
end