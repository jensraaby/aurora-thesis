clear all
load('errors_all.mat');

% Extract the errors for the different numbers of components

total = size(errors_all,1);

breakpoint = total/3;

range_50 = 1:breakpoint;
range_100= breakpoint+1:breakpoint*2;
range_200= 2*breakpoint+1:total;

% now just pick the final iteration for each image
Q = 55; % total events
its = 25; %iterations per event

% indexes for the final iterations:
offsets = 25:25:length(range_50);

% let's start with all the 50s

errors_50 = errors_all(range_50);
errors_50_final = errors_50(offsets);
stddev(1) = std(errors_50_final);
m(1) = mean(errors_50_final);
% 100s
errors_100 = errors_all(range_100);
errors_100_final = errors_100(offsets);
stddev(2) = std(errors_100_final);
m(2) = mean(errors_100_final);
% 200s
errors_200 = errors_all(range_200);
errors_200_final = errors_200(offsets);
stddev(3) = std(errors_200_final);
m(3) = mean(errors_200_final);

h = figure()
errorbar(m,stddev)
xlabel('Components')
ylabel('Reconstruction error (RMS)')
title('Error bars for reconstruction RMS');