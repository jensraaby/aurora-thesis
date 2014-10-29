classdef EllipseFeature < AbstractFeatures
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Name = 'Oval fitted with ellipse feature'
    
        FeatureDimensions = 5;
        EventsStruct
        
        matsubdirectory = 'oval';
        imageintensityscale = 4.3;
    end
    
    methods
        function obj = EllipseFeature(eventsdir, newfits)
            obj = obj@AbstractFeatures(eventsdir);
            
            obj.EventsStruct = cell(obj.NumEvents,1);
            
            if newfits == 1
                obj.matsubdirectory = 'oval-new';
            end
        end
   
        function [] = loadFeatures(obj)
        % function to read in features
         % do not recompute if we have already done so:
            if obj.HaveFeatures == 0
                disp('Loading features - may take a while');
                
                % initialise events structure
                obj.EventsStruct = cell(obj.NumEvents,1);
                obj.Features = zeros(obj.NumEvents,obj.FeatureDimensions);
               
                ellipsematfiles = getAllMatPaths(obj.EventsFolder,obj.matsubdirectory);
                 for i = 1:length(ellipsematfiles)
                    
                    fprintf(1,'event:  ');
                    fprintf(1,'\b%d',i); %pause(.1)
                    fprintf('\n')
                    
                    % get the folder path and a list of the files for this event:
                    eventdir = ellipsematfiles{i}.dirname;
                    obj.EventsStruct{i}.eventdir = eventdir;

                    eventfiles = ellipsematfiles{i}.files;
                    numeventfiles = length(eventfiles);
                    
                    % we assume that first image is onset, last is peak
                    obj.EventsStruct{i}.onsetname = eventfiles(1).name;
                    obj.EventsStruct{i}.peakname = eventfiles(numeventfiles).name;
                    
                    dataPeak = matfile(fullfile(eventdir,obj.matsubdirectory,...
                        obj.EventsStruct{i}.peakname));
                    imagePeakMat = matfile(fullfile(eventdir,'mat',...
                        obj.EventsStruct{i}.peakname));

                    imagePeak = imagePeakMat.image256 * obj.imageintensityscale;
                    [x] = dataPeak.savestruct;

                    obj.EventsStruct{i}.imagePeak = imagePeak;
                     
                    obj.EventsStruct{i}.ellipse = x;
                    obj.Features(i,:) = x;

                    
                 end
                 obj.HaveFeatures = 1;
                 disp('Done loading ellipse features');
            else
                disp('features already loaded');
            end
            
        end

        
        function h = plotEventFeatures(obj, eventid)
        % nice and simple plot function
            if nargout >= 1
                h = figure();
            end
            
            Iscl = obj.EventsStruct{eventid}.imagePeak;
            ellipse = obj.EventsStruct{eventid}.ellipse;
            drawEllipseOnImage(Iscl,ellipse(1),ellipse(2),ellipse(3),ellipse(4),ellipse(5));
            
        end
        
        
        function h = plotGenericFeatures(CF, featurevec, zerocentred, image)
            % simple plotting of an ellipse
            
            if nargin < 4
                image = zeros(256,256);
            end
            
            if nargout >= 1
                h = figure()
            end
            
            imshow(image);
            hold on
            
            % 1. convert features back to unnormalised value
            x = CF.deNormaliseFeature(featurevec,zerocentred);
            % 2. plot the ellipse
            ellipse = calculateEllipse(x(1),x(2),x(3),x(4),x(5));
            plot(ellipse(:,1),ellipse(:,2),'y-','LineWidth',2);
            hold off
        end
    end
    
end

