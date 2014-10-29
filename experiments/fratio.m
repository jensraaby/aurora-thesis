function [Fratio,SSW,SSB] = fratio(X,k,cidx,ctrs)
%%% [fratio,ssw,ssb] = fratio(X,k,cidx,ctrs)
% basically, when the fratio begins to increase, we have too many clusters
% minimum is usually best case

    
    SSW = 0;
    for i = 1:size(X,1)
       ctr = ctrs(cidx(i),:);
       SSW= SSW + sum((abs(ctr-X(i,:))).^2);
    end
    
    SSB = 0;
    xbar = mean(X);
    for c = 1:k
       ctr = ctrs(c,:);
       n = length(find(cidx==c));
       SSB = SSB + (n* (sum((abs(ctr-xbar)).^2)));
    end
    
    Fratio = (k*SSW)/SSB;
end
