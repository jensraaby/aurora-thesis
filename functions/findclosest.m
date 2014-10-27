function [closestIndex,closestValue,diff] = findclosest(item, vector)
%%% [closestIndex,closestValue,diff] = findclosest(item, vector)

[c closestIndex] = min(abs(vector-item));
closestValue = vector(closestIndex); 

diff = abs(closestValue-item);
end