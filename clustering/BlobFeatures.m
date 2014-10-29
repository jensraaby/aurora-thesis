classdef BlobFeatures < AbstractFeatures
    
    properties
        Name = 'Multiscale blob features at peak';
        
        % this is a simple struct for storing anything we want to persist:
        EventsStruct;
        
        % these parameters affect the feature set. treat them like 'FINAL'
        % parameters in a Java object
        NumBlobs;
        UsePosition;
        UseScale;
        UseEigenvalues;
        UseEigenvectors;
        UseMeanIntensity;
        UseFeatureStrength;
        UseOnset
        FeatureDimensions; % how many dimensions are we using?
        
        
        % variables which are implementation linked, but stored here for the
        % sake of clarity:
%         matsubdirectory = 'laplacianblobs11-105-90'; % where are features
        matsubdirectory;
        imageintensityscale = 4.3; % convert raw to 'counts'
        filterfun;
    end
    
    methods
        
        % constructor
        function CF = BlobFeatures(eventsd, NumBlobs, ...
                UsePosition, UseScale,UseEigenvalues,UseEigenvectors,...
                UseMeanIntensity,UseFeatureStrength,filterfun, Onsetinsteadofpeak,matsubdirectory)
            
            
            CF = CF@AbstractFeatures(eventsd);
            if nargin >= 8
                if nargin <9
                    filterfun = 'default';
                end
                if nargin < 10
                    Onsetinsteadofpeak = 0;
                end
                if nargin < 11
                    matsubdirectory = 'laplacianblobs11-105-90-eig';
                end
                CF.matsubdirectory = matsubdirectory;
                
                if strcmp(filterfun,'')
                    filterfun = 'default'
                end
                
                CF.filterfun = filterfun;
                
                
                % set all the properties for the blobs
                CF.NumBlobs = NumBlobs;
                CF.UsePosition = UsePosition;
                if UsePosition ~= 0
                    posdims = 2;
                else
                    posdims = 0;
                end
                CF.UseScale = UseScale;
                CF.UseEigenvalues = UseEigenvalues; % if 1 then ratio - if 2 then eigenvalues
                CF.UseEigenvectors = UseEigenvectors;
                CF.UseMeanIntensity = UseMeanIntensity;
                CF.UseFeatureStrength = UseFeatureStrength;
                CF.UseOnset = Onsetinsteadofpeak;
                % work out how many dimensions we will have:
                CF.FeatureDimensions = NumBlobs * (posdims ...
                    + UseScale + (UseEigenvalues) ...
                    + (4*UseEigenvectors) ...
                    + UseMeanIntensity ...
                    + UseFeatureStrength);
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
                blobmatfiles = getAllMatPaths(CF.EventsFolder,CF.matsubdirectory);
                
                % loop over events
                for i = 1:length(blobmatfiles)
%                     clc
                    fprintf(1,'event:  ');
                    fprintf(1,'\b%d',i); %pause(.1)
                    fprintf('\n')
                    
                    % get the folder path and a list of the files for this event:
                    eventdir = blobmatfiles{i}.dirname;
                    CF.EventsStruct{i}.eventdir = eventdir;
                    
                    eventfiles = blobmatfiles{i}.files;
                    numeventfiles = length(eventfiles);
                    
                    % we assume that first image is onset, last is peak
                    CF.EventsStruct{i}.onsetname = eventfiles(1).name;
                    CF.EventsStruct{i}.peakname = eventfiles(numeventfiles).name;
                    
                    if CF.UseOnset
                        dataOnset = matfile(fullfile(eventdir,CF.matsubdirectory,...
                            CF.EventsStruct{i}.onsetname));
                        imageOnsetmat = matfile(fullfile(eventdir,'mat',...
                            CF.EventsStruct{i}.onsetname));
                        imageOnset = imageOnsetmat.image256 * CF.imageintensityscale;
                        [x,blobs] = CF.generateFeatureVecFromMat(dataOnset,imageOnset);
                        
                        CF.EventsStruct{i}.imageOnset = imageOnset;
                        %                 CF.EventsStruct{i}.featurevec = x;
                        CF.Features(i,:) = x;
                        CF.EventsStruct{i}.usedblobs = blobs;
                    else
                        dataPeak = matfile(fullfile(eventdir,CF.matsubdirectory,...
                            CF.EventsStruct{i}.peakname));
                        imagePeakMat = matfile(fullfile(eventdir,'mat',...
                            CF.EventsStruct{i}.peakname));
                        imagePeak = imagePeakMat.image256 * CF.imageintensityscale;
                        
                        
                        [x,blobs] = CF.generateFeatureVecFromMat(dataPeak,imagePeak);
                        
                        CF.EventsStruct{i}.imagePeak = imagePeak;
                        %                 CF.EventsStruct{i}.featurevec = x;
                        CF.Features(i,:) = x;
                        CF.EventsStruct{i}.usedblobs = blobs;
                    end
                   
                    
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
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function [blobs,blobidx] = defaultBlobsFilter(CF,blobs)
            morning = 10;
            afternoon = 14;
            
            % filter away smallest blobs
            nblobs = length(blobs);
            minscale = min(blobs(:,3));
            %                 minblobs = find(blobs(:,3) == minscale);
            blobs(blobs(:,3) == minscale,:) = [];
            
            % remove dayside blobs
            %                 dayside = find(blobs(:,8)<=afternoon & blobs(:,8)>=morning);
            blobs(blobs(:,5)<=afternoon & blobs(:,5)>=morning,:) = [];
            
            % sort by strength, scale
            [blobs,blobidx] = sortrows(blobs,[-6, -3]);
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            if CF.NumBlobs == 1
                % use max feature strength
                disp('using max feature strength for single blob')
            else
            % look for blobs with high intensity
            % in the top 25% of this list
            disp('get 75th percentile of blob feature strength')
                top75pc = prctile(blobs(:,6),75)
                disp('how many blobs above this?')
                topblobs = find(blobs(:,6)>=top75pc);
                length(topblobs)
            
            if length(topblobs) < CF.NumBlobs
                nblobs = CF.NumBlobs
                disp('not enough in top 25% of feature strength')
            
                top50pc = prctile(blobs(:,6),50)
            disp('how many blobs in top 50% of feature strength?')
                topblobs = find(blobs(:,6)>=top50pc);
                ntop50 = length(topblobs)
                if ntop50 < CF.NumBlobs
                    disp('not enough in top 50pc of feature strength');
                    topblobs = 1:nblobs; % just use all of them
                end
            end
            
            % now sort by scale descending
            [blobs,blobidxsort] = sortrows(blobs(topblobs,:),[-3]);
            blobidx = blobidx(blobidxsort);
            end
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            % eliminate unused blobs
            blobs = blobs(1:CF.NumBlobs,:);
            blobidx = blobidx(1:CF.NumBlobs);
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function [blobs,blobidx] = biggestBlobfilter(CF,blobs)
            morning = 10;
            afternoon = 14;

            % remove dayside blobs
            %                 dayside = find(blobs(:,8)<=afternoon & blobs(:,8)>=morning);
            blobs(blobs(:,5)<=afternoon & blobs(:,5)>=morning,:) = [];
%                first find the top 50% by feature strength
            top50pc = prctile(blobs(:,6),50);
            
            ftblobidx = 1:size(blobs,1);
            % eliminate blobs below top 50% of feature strength
            if size(blobs,1) >= (2 * CF.NumBlobs)
                [blobs,ftblobidx] = sortrows(blobs,[-6]);
                badblobs = find(blobs(:,6)<top50pc);
                blobs(badblobs,:) = [];
                ftblobidx(badblobs) = [];
            end
            
            % sort by scale, no other 
            %TODO try alternative approach!
            [blobs,blobidx] = sortrows(blobs,[-3]);
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % reorder indices
            blobidx = ftblobidx(blobidx);
            

            % eliminate unused blobs
            blobs = blobs(1:CF.NumBlobs,:);
            blobidx = blobidx(1:CF.NumBlobs);
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function [blobs,blobidx] = brightestBlobfilter(CF,blobs)
            morning = 6;
            afternoon = 18;

            % remove dayside blobs
            %                 dayside = find(blobs(:,8)<=afternoon & blobs(:,8)>=morning);
            blobs(blobs(:,5)<=afternoon & blobs(:,5)>=morning,:) = [];
            
               
%             first find the top 50% by feature strength
            top50pc = prctile(blobs(:,6),50);
            
            ftblobidx = 1:size(blobs,1);
            % eliminate blobs below top 50% of feature strength
            if size(blobs,1) > CF.NumBlobs
                [blobs,ftblobidx] = sortrows(blobs,[-6]);
                badblobs = find(blobs(:,6)<top50pc);
                blobs(badblobs,:) = [];
                ftblobidx(badblobs) = [];
            end
            
            % sort by scale, no other 
            %TODO try alternative approach!
            [blobs,blobidx] = sortrows(blobs,[-7]);
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % reorder indices
            blobidx = ftblobidx(blobidx);

            % eliminate unused blobs
            blobs = blobs(1:CF.NumBlobs,:);
            blobidx = blobidx(1:CF.NumBlobs);
        end
        
        %blobs(b,1:3), alllats(b), alltimes(b), strengths2(b), meanintensities(b), eigenvals(b,:), eigenvecs(b,:)
         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function [blobs,blobidx] = strongestBlobfilter(CF,blobs)
            morning = 10;
            afternoon = 14;

            % remove dayside blobs
            %                 dayside = find(blobs(:,8)<=afternoon & blobs(:,8)>=morning);
            blobs(blobs(:,5)<=afternoon & blobs(:,5)>=morning,:) = [];
            
            % sort by scale, no other 
            %TODO try alternative approach!
            % 6 is strength
            % 3 is scale
            [blobs,blobidx] = sortrows(blobs,[-6]);
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            

            % eliminate unused blobs
            blobs = blobs(1:CF.NumBlobs,:);
            blobidx = blobidx(1:CF.NumBlobs);
        end
        
        function [x,blobs,blobidx] = generateFeatureVecFromMat(CF,mat,I)
            % since this class is somewhat dynamic in terms of the features we
            % allow, there has to be some fiddly logic to handle varying
            % indices. all for the sake of keeping things fast with a simple data
            % structure (matrix of all features)
            %
            %
            %
            % Note: What are the dimensions of the blobs matrix?
            % row, col, scale, mlat, mlt, strength, mean intensity,
            % eigenvals (2), eigenvec1, eigenvec2
            %[blobs(b,1:3), alllats(b), alltimes(b), strengths2(b), meanintensities(b), eigenvals(b,:), eigenvecs(b,:)];
            
            x = zeros(1,CF.FeatureDimensions);
            fstruct = mat.savestruct;
            blobs = fstruct.blobsData;
            
            if strcmp(CF.filterfun,'default')
                [blobs,blobidx] = CF.defaultBlobsFilter(blobs);
                
            elseif strcmp(CF.filterfun,'biggest')
                [blobs,blobidx] = CF.biggestBlobfilter(blobs);
                
            elseif strcmp(CF.filterfun,'brightest')
                [blobs,blobidx] = CF.brightestBlobfilter(blobs);
            
            elseif strcmp(CF.filterfun,'strongest')
                [blobs,blobidx] = CF.strongestBlobfilter(blobs);
            else
               error('need more filter functions') 
            end
            
            % now convert MLT to signed midnight offset (easy to reverse)
            fixmlts = find(blobs(:,5) > 12);
            blobs(fixmlts,5) = blobs(fixmlts,5) - 24;
            
            % sort the blobs by the MLT rather than Feature strength
            [blobs,sortidx] = sortrows(blobs,5);
            blobidx = blobidx(sortidx);
            
            %
            bloboffset = 0;
            dimoffset = 0;
            
            for b = 1:CF.NumBlobs
                % now get all the relevant features, for this blob
                
                if CF.UsePosition == 1
                    % DON'T use the mlat and mlt
                    % X,Y can be compared with euclidean distance
                    x(bloboffset+dimoffset+1) = blobs(b,1); % row
                    x(bloboffset+dimoffset+2) = blobs(b,2); % col
                    dimoffset = dimoffset + 2;
                end
                % use the MLAT and MLT
                if CF.UsePosition == 2
                    x(bloboffset+dimoffset+1) = blobs(b,4); % MLAT
                    x(bloboffset+dimoffset+2) = blobs(b,5); % MLT
                    dimoffset = dimoffset + 2;
                end
                
                if CF.UseScale == 1
                    x(bloboffset+dimoffset+1) = blobs(b,3);
                    dimoffset = dimoffset + 1;
                end
                size(blobs)
                if CF.UseEigenvalues >= 1
                    eig1 = blobs(b,8);
                    eig2 = blobs(b,9);
                    if abs(eig1) > abs(eig2)
                        % largest curvature goes first
                        principaleig = 1;
                    else
                        principaleig = 2; 
                    end
            
     
%                     % warning: we should not sign change these.
                    if CF.UseEigenvalues == 2
                        
                        if principaleig == 1
                          
                            x(bloboffset+dimoffset+1) = blobs(b,8);
                            x(bloboffset+dimoffset+2) = blobs(b,9);
                        else
                           
                            x(bloboffset+dimoffset+1) = blobs(b,9);
                            x(bloboffset+dimoffset+2) = blobs(b,8);
                        end
                        
                        dimoffset = dimoffset + 2;
                    elseif CF.UseEigenvalues == 1
                        % use ratio of curvatures
                        sorteigs = sort(abs(blobs(b,8:9)));
                        eigratio = sorteigs(1)/sorteigs(2);
                        x(bloboffset+dimoffset+1) = eigratio;
                        dimoffset = dimoffset+1;
                    end
                    if CF.UseEigenvectors == 1
                        % same order as eigenvalues/curvatures
                        if principaleig == 1
                            x(bloboffset+dimoffset+1) = blobs(b,10);
                            x(bloboffset+dimoffset+2) = blobs(b,11);
                            x(bloboffset+dimoffset+3) = blobs(b,12);
                            x(bloboffset+dimoffset+4) = blobs(b,13);
                        else
                            x(bloboffset+dimoffset+1) = blobs(b,12);
                            x(bloboffset+dimoffset+2) = blobs(b,13);
                            x(bloboffset+dimoffset+3) = blobs(b,10);
                            x(bloboffset+dimoffset+4) = blobs(b,11);
                        end
                        dimoffset = dimoffset + 4;
                    end
                end
                if CF.UseFeatureStrength == 1
                    x(bloboffset+dimoffset+1) = blobs(b,6);
                    dimoffset = dimoffset+1;
                end
                if CF.UseMeanIntensity == 1
                   x(bloboffset+dimoffset+1) = blobs(b,7); 
                end
                
                % offset update
                bloboffset = bloboffset + CF.FeatureDimensions/CF.NumBlobs;
                dimoffset = 0;
            end % end blob loop
        end
        
        
        
        function h = plotEventFeatures(CF, eventid, justblobs)
            % this will plot a given event using any relevant features
            % e.g. if we use multiple images from the sequence, then plot
            % all of them and any relevant details on top
            if nargout >= 1
                h = figure();
            end
            if nargin < 3
                justblobs = 0;
            end
            
            if CF.UseOnset
                [im,pathonset] = CF.getOnsetImage(eventid);
                [~,nm,~] = fileparts(pathonset);
            else
                
                [im,pathpeak] = CF.getPeakImage(eventid);            
                [~,nm,~] = fileparts(pathpeak);
            end
            
            % we need to plot the relevant images for the given eventid
            % with any relevant features on top
            
            featuredata = CF.EventsStruct{eventid}.usedblobs;
            if ~justblobs
                plotBlobsImage(im,featuredata, 0)
            else
                % plot the blobs on whatever the current figure is
                plotBlobsImage(im,featuredata, 0, '', '', 0);

            end
            
%             text(15,15,nm,'Color',[ 1 1 1]);
%             hold off
            
        end
        
        function plotGenericFeatures(CF,x, zerocentred, image)
        % this is for taking some generic feature vector to see what it
        % represents. For example we want to show what a centroid
        % represents. This should be in this class as this is where the
        % feature vectors are created - I don't want to decouple this
        % functionality and forget about the method.
        
        if nargin < 4
            image = zeros(256,256);
        end
       
        imshow(image);
        hold on
        
        % 1. convert features back to unnormalised value
            x = CF.deNormaliseFeature(x,zerocentred);
        
          % helpers for indexing
            bloboffset = 0;
            dimoffset = 0;
            
        % 2. loop over blobs
        for b = 1:CF.NumBlobs
            if CF.UsePosition ~= 0      
                row = x(bloboffset+dimoffset+1);
                col = x(bloboffset+dimoffset+2);
                dimoffset = dimoffset + 2;
            end
            if CF.UseScale == 1
                blobscale = x(bloboffset+dimoffset+1);
                dimoffset = dimoffset + 1;
            end
            if CF.UseEigenvalues >= 1 || CF.UseEigenvectors == 1
                % find out the level of the scale here
                %                     [scaleind,~,~] = findclosest(blobs(b,3),scales);
                %
                %                     [v,d] = eig(getHessianXY(allhessians(:,:,scaleind),size(I),blobs(b,1),blobs(b,2)));
                %
                %                     % note that matlab uses leading diagonal for
                %                     % eigenvalues!
                %                     eigvals = [d(1), d(4)];
                %                     % warning: we should not sort or sign change these.
                %                     % but useful if you want to abstract away the
                %                     % actual orientation of the blobs
                %                     eigvals = ((eigvals));
                if CF.UseEigenvalues == 2
                    eig1 = x(bloboffset+dimoffset+1) ;
                    eig2 = x(bloboffset+dimoffset+2) ;
                    dimoffset = dimoffset + 2;
                elseif CF.UseEigenvalues == 1
                    % use ratio / cannot plot!
                    
                    eigratio = x(bloboffset+dimoffset+1) ;
                    dimoffset = dimoffset+1;
                end
                if CF.UseEigenvectors == 1
                    eig11 = x(bloboffset+dimoffset+1);
                    eig12 = x(bloboffset+dimoffset+2);
                    eig21 = x(bloboffset+dimoffset+3);
                    eig22 = x(bloboffset+dimoffset+4);
                    eigenvecs = [eig11,eig12,eig21,eig22];
                    dimoffset = dimoffset + 4;
                end
            end
            if CF.UseFeatureStrength == 1
                featstrengh = x(bloboffset+dimoffset+1);
                dimoffset = dimoffset+1;
            end
            if CF.UseMeanIntensity == 1
                meanintensity = x(bloboffset+dimoffset+1);
            end
            
            % now we have enough to draw a blob!
            %                 plotcircle([col, row],blobscale,'y');
            if CF.UseEigenvalues && CF.UseEigenvectors
%                 col
%                 row
%                 blobscale
%                 meanintensity
%                 eigenvecs
%                 eig1
%                 eig2
                plotblob(col,row, blobscale, 'r', eigenvecs, [eig1,eig2]);
                
            else
                if CF.UsePosition == 2
                    [col,row] = magnetic_to_pixels(row,col,256);
                end
                plotblob(col,row,blobscale,'y');
            end
            
            
            % offset update
            bloboffset = bloboffset + CF.FeatureDimensions/CF.NumBlobs;
            dimoffset = 0;
        end
        
        end
        
        
        
        
    end
    
    
end