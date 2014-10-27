function eventfiles = getAllMatPaths(eventsdir,subdir)
% this function simply returns a cell array with all the VISE mat files in
% the given subdirectory of each event in EVENTSDIR.

if nargin < 2
    subdir = 'mat';
end

if ~strcmp(eventsdir(end),'/')
    eventsdir = [eventsdir '/'];
end

events1990s = dir([eventsdir '1*']);
events2000s = dir([eventsdir '200*']);
events = [events1990s; events2000s];

numevents = length(events);

eventfiles = cell(1,numevents);

for ei = 1:numevents
    eventdir = fullfile(eventsdir,events(ei).name);
    images = dir(fullfile(eventdir,[subdir '/*VISE*.mat']));
    eventfiles{ei}.files = images;
    eventfiles{ei}.dirname = eventdir;
end
