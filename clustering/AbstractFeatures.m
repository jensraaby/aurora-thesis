classdef (Abstract) AbstractFeatures < handle
    properties (Abstract)
        Name
    end
    
    properties (GetAccess=private)
        Features % a matrix with 1 row for each event
        
    end
    
    properties
        EventsFolder % records the folder containing all the events
        EventsImages % struct which contains accessors to image
        NumEvents % how many events
        HaveFeatures = 0;
    end

    
    methods

        function CF = AbstractFeatures(eventsfolder)
        %%% default constructor - basically makes a list of events from
        %%% the given folder
            disp(['Creating features "' CF.Name '" from  folder ' eventsfolder]);
            
            if eventsfolder(end) ~= '/'
                eventsfolder = [eventsfolder '/'];
            end
            CF.EventsFolder = eventsfolder;
            
            % get the images
            CF.EventsImages = getAllMatPaths(eventsfolder);
            
            CF.NumEvents=length(CF.EventsImages);
            disp(['Events to process: ' num2str(CF.NumEvents)]);
        end
        
        
        function [I,fullpath] = getOnsetImage(CF, eventid)
        %%% [I,fullpath] = getOnsetImage(CF, eventid)
        % looks up the onset image file for the given ID
            if eventid > CF.NumEvents
                error('Eventid out of range')
            end
            filesevent = CF.EventsImages{eventid}.files;
            onsetfile = filesevent(1);
            fullpath = fullfile(CF.EventsImages{eventid}.dirname,'mat',onsetfile.name);
            diskref = matfile(fullpath);
            I = diskref.image256;
        end
        
        function [I,fullpath] = getPeakImage(CF, eventid)
        %%% [I,fullpath] = getPeakImage(CF, eventid)
        % looks up the peak image file for the given ID
            if eventid > CF.NumEvents
                error('Eventid out of range')
            end
            
            filesevent = CF.EventsImages{eventid}.files;
            numimages = length(filesevent);
            peakfile = filesevent(numimages);
            % now load the actual image from disk
            fullpath = fullfile(CF.EventsImages{eventid}.dirname,'mat',peakfile.name);
            diskref = matfile(fullpath);
            I = diskref.image256;
        end
        
        
        function X = getFeatures(CF)
        %%% X = getFeatures(CF)
        % simple accessor to the features matrix. forces loading
        % features if they are not already loaded in the object
            if CF.HaveFeatures == 0
                CF.loadFeatures();
            end
            X = CF.Features();
        end
        
        
        function X = getNormalisedFeatures(CF, zerocentred)
        % normalise the features
            X = CF.getFeatures();
            
            if zerocentred == 1
                % centre on the mean
                meanF = mean(X);
                X = bsxfun(@minus,X,meanF);
            end
            
            % normalise each column by dividing by its standard deviation
            stdF = std(CF.Features);
            X = bsxfun(@rdivide,X,stdF);
        end
        
        function Xorig = deNormaliseFeature(CF, Xf, zerocentred)
        % use this to take a normalised feature vector and transform it
        % back to the original scales
            
        % multiply by standard dev
            Xorig = Xf .* std(CF.Features);
            
            % remove the zero centring
            if zerocentred == 1
                meanF = mean(CF.Features);
                Xorig = Xorig + meanF;
            end
        end
    end
    
    properties (Abstract)
        EventsStruct % a structure with info about the events in this feature set
    end
    
    methods (Abstract)
        
        % this is where the magic happens. 
        [] = loadFeatures(CF)
        
        h = plotEventFeatures(CF, eventid)
        h = plotGenericFeatures(CF, featurevec, zerocentred, image)
        % this will plot a given event using any relevant features
        % e.g. if we use multiple images from the sequence, then plot
        % all of them and any relevant details on top
    end
    
    
end