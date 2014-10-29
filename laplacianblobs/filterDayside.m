function [idx, lats,times] = filterDayside(blobs,diameter)
%[idx, lats,times] = filterDayside(blobs,diameter)

    % we convert all coords to MLAT and MLT
    [mlat,mlt] = generatepixelcoords(50, diameter);
  
    ind = sub2ind([diameter, diameter], blobs(:,1), blobs(:,2));
    % get all the lats
    lats = 90 - mlat(ind); % note colat to lat transform
    times = mlt(ind);
    
    % day is between 06:00 and 18:00
    idxDay = find(times >= 6 & times <= 18);

    % we might get something on dayside close to the middle
    % so we'll find them too: anything with colat < 60 is good
    idxLowLat = find(lats<70);
    
    % nightside toofar out
    idxNight = setxor(idxDay,1:length(blobs));
    idxNightTooLow = intersect(find(lats<50),idxNight);
    
    % just select the ones which are in both sets
    idxDay = intersect(idxDay, idxLowLat);
    idx = union(idxDay, idxNightTooLow);
end