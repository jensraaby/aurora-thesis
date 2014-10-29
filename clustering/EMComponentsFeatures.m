classdef EMComponentsFeatures < AbstractFeatures
    
    properties
        Name = 'EM components features at peak';
        
        % this is a simple struct for storing anything we want to persist:
        EventsStruct;
        
        % these parameters affect the feature set. treat them like 'FINAL'
        % parameters in a Java object
        Totalnumblobs = 50;
        NumBlobs = 12; % top 25% of 50 blobs;
        UsePosition;
        UseMixingWeight;
        UseCovariance;
        FeatureDimensions; % how many dimensions are we using?
        
        
        % variables which are implementation linked, but stored here for the
        % sake of clarity:
        %         matsubdirectory = 'laplacianblobs11-105-90'; % where are features
        matsubdirectory = 'emfit';
        imageintensityscale = 4.3; % convert raw to 'counts'
    end
    
    methods
        
        % constructor
        function CF = EMComponentsFeatures(eventsd, ...
                UsePosition,UseMixingWeight,...
                UseCovariance)
            
            
            CF = CF@AbstractFeatures(eventsd);
            if nargin >= 4
                
                % set all the properties for the blobs
               
                CF.UsePosition = UsePosition;
                CF.UseMixingWeight = UseMixingWeight;
                CF.UseCovariance = UseCovariance;
                % work out how many dimensions we will have:
                CF.FeatureDimensions = CF.NumBlobs * ((2*UsePosition) ...
                    + (4*UseCovariance) + UseMixingWeight);
                disp('feature dims')
                CF.FeatureDimensions
            else
                error('Need to specify all options');
            end
        end
        
        % this is where the magic happens.  This needs to be called on
        % initialisation
        
        function [] = loadFeatures(CF)
            
            % do not recompute if we have already done so:
            if CF.HaveFeatures == 0
                disp('Loading features - may take a while');
                
                % initialise events structure
                CF.EventsStruct = cell(CF.NumEvents,1);
                CF.Features = zeros(CF.NumEvents,CF.FeatureDimensions);
                
                % get pointers to the mat files on disk:
                emmatfiles = getAllMatPaths(CF.EventsFolder,CF.matsubdirectory)
                
                % loop over events
                for i = 1:length(emmatfiles)
                    %                     clc
                    fprintf(1,'event:  ');
                    fprintf(1,'\b%d',i); %pause(.1)
                    fprintf('\n')
                    
                    % get the folder path and a list of the files for this event:
                    eventdir = emmatfiles{i}.dirname;
                    CF.EventsStruct{i}.eventdir = eventdir;
                    
                    eventfiles = emmatfiles{i}.files;
                    numeventfiles = length(eventfiles);
                    
                    % last file is peak
                    matname = eventfiles(numeventfiles).name;
                    % strip out the number of components from name
                    CF.EventsStruct{i}.peakname = strrep(matname,sprintf('%d-',CF.Totalnumblobs),'');
                    
                    
                    dataPeak = matfile(fullfile(eventdir,CF.matsubdirectory,matname));
                    
                    
                    imagePeakMat = matfile(fullfile(eventdir,'mat',...
                        CF.EventsStruct{i}.peakname));
                    imagePeak = imagePeakMat.image256 * CF.imageintensityscale;
                    x = CF.generateFeatureVecFromMat(dataPeak,imagePeak);
                    
                    CF.EventsStruct{i}.mat = dataPeak;
                    CF.EventsStruct{i}.imagePeak = imagePeak;
                    CF.Features(i,:) = x;
                    
                    
                    
                end
                
                % we use this bookkeeper to make sure calls to getFeatures
                % will always return the right value. At initialisation it
                % is 0.
                disp('Done loading features');
                
                CF.HaveFeatures = 1;
            else
                disp('Features were already loaded; skipping');
            end
            
            
        end
        
        
        
        
        function x = generateFeatureVecFromMat(CF,mat,I)
            % since this class is somewhat dynamic in terms of the features we
            % allow, there has to be some fiddly logic to handle varying
            % indices. all for the sake of keeping things fast with a simple data
            % structure (matrix of all features)
            %
            %
            %
            % Note: What are the dimensions of the blobs matrix?
            % we get separate params:
            % W, alpha, cov, mu
            x = zeros(1,CF.FeatureDimensions);
            
            
            % load the actual data for all the components
            mu = mat.mu;
            alpha = mat.alpha;
            cov = mat.cov;
            
            
            
            % now sort the data from left to right in mu
            [~,order] = sort(mu(:,2));
            
            musort = mu(order,:);
            alphasort = alpha(order,:);
            covsort = cov(:,:,order);
            
            
            % now remove bottom 50% of components by alpha
            if CF.NumBlobs == 25
                cutoff = median(alphasort)
            else
                % top 12 is the top 25%
                cutoff = quantile(alphasort,.75)
            end
            ind = find(alphasort<=cutoff);
            
            % eliminate those bewlow the cutoff
            musort(ind,:) = [];
            alphasort(ind) = [];
            covsort(:,:,ind) = [];
            length(alphasort)
            
            %
            bloboffset = 0;
            dimoffset = 0;
            
            for b = 1:CF.NumBlobs
                % now get all the relevant features, for this blob
                
                if CF.UsePosition == 1
                    
                    % X,Y can be compared with euclidean distance
                    x(bloboffset+dimoffset+1) = musort(b,1);
                    x(bloboffset+dimoffset+2) = musort(b,2);
                    dimoffset = dimoffset + 2;
                end
                if CF.UseMixingWeight == 1
                    x(bloboffset+dimoffset+1) = alphasort(b);
                    dimoffset = dimoffset + 1;
                end
                
                if CF.UseCovariance == 1
                    x(bloboffset+dimoffset+1:bloboffset+dimoffset+4) = reshape(covsort(:,:,b),1,4);
                    
                    dimoffset = dimoffset+4;
                end
                
                
                % offset update
                bloboffset = bloboffset + CF.FeatureDimensions/CF.NumBlobs;
                dimoffset = 0;
            end % end blob loop
        end
        
        
        
        function h = plotEventFeatures(CF, eventid, unused)
            % this will plot a given event using any relevant features
            
            if nargout >= 1
                h = figure();
            end
            if nargin < 3
                unused = 0;
            end
            
            dummyimage = zeros(128,360);
            matfile = CF.EventsStruct{eventid}.mat;
            alpha = matfile.alpha;
            mu = matfile.mu;
            cov = matfile.cov;
            
            % now remove bottom 50% of components by alpha
            cutoff = median(alpha);
            ind = find(alpha<cutoff);
            
            mu(ind,:) = [];
            alpha(ind) = [];
            cov(:,:,ind) = [];
            
            
            
            [ canvas ] = reconstruct( mu, cov, alpha, dummyimage, 1 );
            
            canvas2 = zeros(128*2+10,360);
            [im,~] = CF.getPeakImage(eventid);
            
%             subplot(211)
%             imagesc(CF.getCartesian( im ));
%             axis off
%             axis image
            
%             subplot(212)
            
            canvas2(1:128,:) = CF.getCartesian( im ) ./  sum(im(:));
            canvas2(128+11:266,:) = canvas;
            
            imagesc(CF.convertToPolar(canvas));
            axis off
            axis image
            
        end
        
        function plotGenericFeatures(CF,x, zerocentred, image)
            % this is for taking some generic feature vector to see what it
            % represents. For example we want to show what a centroid
            % represents. This should be in this class as this is where the
            % feature vectors are created - I don't want to decouple this
            % functionality and forget about the method.
            
            if nargin < 4
                image = zeros(256,256); % not used
            end
            
            
            
            % 1. convert features back to unnormalised value
            x = CF.deNormaliseFeature(x,zerocentred);
            
            % helpers for indexing
            bloboffset = 0;
            dimoffset = 0;
            
            
            allmu = zeros(CF.NumBlobs,2);
            allcov = zeros(2,2,CF.NumBlobs);
            allalpha = zeros(CF.NumBlobs,1);
            
            % 2. loop over components
            for b = 1:CF.NumBlobs
                
                
                % now get all the relevant features, for this blob
                
                if CF.UsePosition == 1
                    
                    % X,Y can be compared with euclidean distance
                    row = x(bloboffset+dimoffset+1);
                    col = x(bloboffset+dimoffset+2);
                    allmu(b,:) = [row,col];
                    
                    dimoffset = dimoffset + 2;
                end
                if CF.UseMixingWeight == 1
                    alpha = x(bloboffset+dimoffset+1);
                    allalpha(b) = alpha;
                    
                    dimoffset = dimoffset + 1;
                end
                
                if CF.UseCovariance == 1
                    cov1 = x(bloboffset+dimoffset+1:bloboffset+dimoffset+4);
                    allcov(:,:,b) = reshape(cov1,2,2);
                    
                    dimoffset = dimoffset+4;
                end
                
                
                % offset update
                bloboffset = bloboffset + CF.FeatureDimensions/CF.NumBlobs;
                dimoffset = 0;
            end
            
            % 3. reconstruct from components
            dummyimage = zeros(128,360);
            
            [ canvas ] = reconstruct( allmu, allcov, allalpha, dummyimage, 1 );
            
           
            imagesc(CF.convertToPolar(canvas));
            
            axis off
            axis image
        end
        
        function img = convertToPolar(CF,cartimage)
           img = flipud(PolarToIm(cartimage, 0,1,256,256)');
        end
        
        function img = getCartesian(CF,polarimage)
            %%% cartesian conversion
            [M,N] = size(polarimage);
            resolution = 360;
            startdeg = 360;
            finishdeg = 0;
            
            img = zeros(128,resolution);
            img = polar_conversion(polarimage,resolution, startdeg, finishdeg);
            
        end
        
    end
    
    
end