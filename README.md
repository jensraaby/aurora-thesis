Aurora-thesis
=============

This repo contains a variety of Matlab scripts and functions used during my thesis work. 
It's been cleaned up somewhat but can be messy in parts. It is not intended for random people to be able to run this code, as they won't have the data needed.

Notes for using the code
========================
It's easiest if you add all the directories to your MATLAB runtime path.
For example, you could run the following:
```
addpath(genpath('aurora-thesis'))
```

### Functions
- ```cartesian2polar``` - used for resampling images using
  interpolation
- ```findclosest``` - utility for searching vectors
- ```fit_ellipse``` - function for fitting ellipses to polar projections
  of aurora (uses optimisation functions)
- ```gaussian2d``` - utility for Gaussian function
- ```gaussian2dtilt``` - utility for tilted 2D Gaussian function (given an angle
  of rotation)
- ```generatepixelcoords``` - generates matrices with the MLAT and MLT of each pixel for a polar projection
- ```getAllMatPaths``` - given the path to a directory containing multiple
  events, and the name of a subdirectory, this function creates a data structure
with all the filenames in the matching subdirectories (matching the VISE name
pattern)
- ```loadNSPolar``` - loads a 3D matrix of size 512x512xN given a path to a
  folder of files matching the pattern ```*NS_Polar.mat```. Also returns
normalised version of matrix and a cell array of their filenames
- ```loadPeakImages``` - improved version of above, used for thesis work where
  there are far more files to deal with
- ```loadpngto256sq``` - gets raw pixels from PNG images and converts to matlab
  format - very unlikely to need this!
- ```mypca``` - do not use this PCA function
- ``` removedaylight``` - pre-thesis - probably should avoid using as it cuts
  the top of the image off
- ```rmserror``` - compute RMS error of 2 images
- ```rmsthresh``` - as above, with a threshold on the error to avoid skewed
  result
- ```robustmse``` - robust mean squared error
- ```timestamp_to_date``` - unix to matlab date conversion
- ```vectorAngle```
- ```vise_fname_to_datenum``` converts filenames to matlab timestamps

- ```magnetic_to_pixels``` and ```pixels_to_magnetic``` are for general
  coordinate conversion


### Expectation Maximisation
In the ```em``` folder there are files from my 2013 project on extracting features using the E-M algorithm to represent images as a Gaussian Mixture Model.

For the thesis work, only ```update_mixture.m``` was used - this contains the algorithm for iterating the mixture model.

### Clustering
The ```clustering``` folder contains code used to running clustering experiments. Experiments involve creating a feature vector for each event, and these are generated from pre-computed features (saved to disk as MAT files).
-  ```AbstractFeatures``` is essentially a definition of an (object oriented) interface for a set of clustering features.
- ```BlobFeatures``` is a class for loading features for clustering using multi scale blobs. Instantiating an object of this class allows specifying which features are put into the feature vectors.
- ```EMComponentsFeatures``` - load features from Gaussian Mixture Models
- ```EllipseFeatures``` - load ellipse parameters
- ```EllipseBlobFeatures``` - load both ellipse and blob features
- ```clusteranalysis``` and ```clusterdensityGaussian``` are used for running some quick experiments and analysis of clustering. You probably can’t use them as is, but they demonstrate how to use the ```BlobFeatures``` class.

### Laplacianblobs
This folder contains a lot of functions and other code relating to detecting multi-scale blobs. Only listing interesting ones here:
- ```detectBlobs``` is the main function for extracting blobs given an image, and scale parameters
- ```filterDayside``` is an example of a way to filter irrelevant blobs. We assume dayside is between 06:00 and 18:00 MLT and the interesting range of latitudes is between 50 and 70 MLAT.
- ```saveAllBlobsOnlyPeak``` - this is a function for detecting blobs for peak images, and saving the results to disk. It has hard-coded parameters for the output directories (subdirectory name is the ‘blobsdirname’ parameter) and blob scales - it should be self-explanatory.

### Ovalfit
Functions for fitting ovals to the images. This could still be improved - the basic approach is Jesper’s, but probably simplified in places. The main issue is the image quality…
- ```fitEllipse``` - this method involves generating several guess ellipses and choosing the best of them using the ```eval_ellipse_binary``` function.
- ```fitEllipsesAllNew``` is a script function which uses ```fitEllipse``` to detect ellipses and save the parameters to disk. Note it uses hard-coded paths. The intensity-scale is a multiplicative factor for image intensity (basically a unit conversion).

### Experiments
This contains files for running clustering experiments.

### Data Processing
Scripts for extracting features over the entire data set.


