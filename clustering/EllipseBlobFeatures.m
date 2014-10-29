classdef EllipseBlobFeatures < AbstractFeatures
% the idea with this class is to include both an ellipse feature
% and a blob feature object and provide their collective features
% as a single feature matrix.
    properties
        Name = 'Multiscale blobs with ellipse';
        ellipseobj; % handle to an ellipsefeature object
        blobsobj; % handle to a blobfeatures object
        FeatureDimensions; % how many dimensions in each feature vector
        EventsStruct;
    end

    methods
        function obj = EllipseBlobFeatures(eventsd, NumBlobs, ...
                UsePosition, UseScale,UseEigenvalues,UseEigenvectors,...
                UseMeanIntensity,UseFeatureStrength,filterfun,Onsetinsteadofpeak,matsubdir)
            
            % passthrough events directory to abstract class
            
            obj = obj@AbstractFeatures(eventsd);
            
            % passthrough blobs settings to a blobfeature object
            obj.blobsobj = BlobFeatures(eventsd,NumBlobs, ...
                UsePosition, UseScale,UseEigenvalues,UseEigenvectors,...
                UseMeanIntensity,UseFeatureStrength,filterfun,Onsetinsteadofpeak,matsubdir);
            
            % create ellipse object as well - no need to pass options at
            % the moment
            obj.ellipseobj = EllipseFeature(eventsd,1);
            
        end
        
        function [] = loadFeatures(obj)
           % pass through to children
           blobfeatures = obj.blobsobj.getFeatures();
           ellipsefeature = obj.ellipseobj.getFeatures();
           
           % workout the dimensions
           numdimsblobs = obj.blobsobj.FeatureDimensions;
           numdimsellipse = obj.ellipseobj.FeatureDimensions;
           totaldims = numdimsblobs + numdimsellipse;
           obj.FeatureDimensions = totaldims;
           
           obj.Features = zeros(obj.NumEvents,obj.FeatureDimensions);
           obj.EventsStruct = []; %cell(obj.NumEvents,1);
           
           if size(ellipsefeature,1) ~= size(blobfeatures,1)
               error('ellipse and blob features different length');
           end
           
           obj.Features = [blobfeatures,ellipsefeature];
%            obj.EventsStruct
        end
        
        function h = plotEventFeatures(obj, eventid)
            % function to plot the blobs and the ellipse on the same figure
            disp('plotting event');
            if nargout > 0
                h = figure();
            end
            obj.ellipseobj.plotEventFeatures(eventid);
            hold on
            obj.blobsobj.plotEventFeatures(eventid,1);
            hold off
            
        end
        
        function h = plotGenericFeatures(obj, featurevec, zerocentred, image)
            if nargout > 0
                h = figure();
            end
            % first plot blobs
            blobsfeature = featurevec(1:obj.blobsobj.FeatureDimensions);
            obj.blobsobj.plotGenericFeatures(blobsfeature,zerocentred)
            hold on
           
            % then plot ellipse
            ellipsefeature = featurevec(obj.blobsobj.FeatureDimensions+1:end);
            size(ellipsefeature)
            % convert features back to unnormalised value
            x = obj.ellipseobj.deNormaliseFeature(ellipsefeature,zerocentred);
            % 2. plot the ellipse
            ellipse = calculateEllipse(x(1),x(2),x(3),x(4),x(5));
            plot(ellipse(:,1),ellipse(:,2),'r-','LineWidth',1);
            hold off
            
        end

    end

end