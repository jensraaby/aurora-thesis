function [] = fitEllipsesAllNew()
% fitellipses

workingevents = '/Users/jens/Desktop/Aurora-Working/EventsProcessing/';
intensityscale = 4.3;

% ellipsehandle = @(x,outdir,fname) fitEllipseToImage(x,outdir, fname, intensityscale);
ellipsehandle = @(x,outdir,fname) fitEllipse(x,outdir, fname, intensityscale);

eventhandle =   @(x) processEvent2mat(ellipsehandle, x,'mat','oval-new');
batchProcessEvents(eventhandle,workingevents,1);

end



