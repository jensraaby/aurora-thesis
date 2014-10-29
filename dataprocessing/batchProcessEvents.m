function [outvar] = batchProcessEvents(func, eventsdir, test)
%%% Batch processes events in eventsdir using FUNC to save results in
%%% OUTPUTSUBDIR
% [] = batchProcess(func, eventsdir, outputsubdir, test)
 
if nargin < 3
    test = 0;
end

% get all the matfiles for all the events
eventfiles = getAllMatPaths(eventsdir,'mat');
numevents = length(eventfiles);
if test
   fprintf('Batch processing events in %s\n',eventsdir); 
   fprintf('Found %d events\n\n',numevents);    

end

if numevents == 0
    error('No events found')
end

% map-like function. apply to all the event files:
cellfun(func,eventfiles);

% take a function for a raw image, and a subdirname, and the loop will
% basically do a map over all the events


end