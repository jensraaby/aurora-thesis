Aurora-thesis
=============

This repo contains a variety of Matlab scripts and functions used during my
thesis work. It's been cleaned up somewhat but can be messy in parts. It is not
intended for random people to be able to run this code, as they won't have the
data needed.

Notes for running
=================
It's easiest if you add all the directories to your MATLAB runtime path.
For example, you could run the following:
```
addpath(genpath('aurora-thesis'))
```

## Functions
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


## Scripts
### Experiments
