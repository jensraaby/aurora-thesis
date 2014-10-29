function [H] = hartigan(X,k,cidx,ctrs, cidxk1, ctrsk1)
%%% generate hartigan raio K - needs K+1 results too!
% [H] = hartigan(X,k,cidx,ctrs, cidxk1, ctrsk1)


n = size(X,1);
    SSWk = 0;
    for i = 1:size(X,1)
       ctr = ctrs(cidx(i),:);
       SSWk= SSWk + sum((abs(ctr-X(i,:))).^2);
    end

    
    SSWk1 = 0;
    for i = 1:size(X,1)
       ctr = ctrsk1(cidx(i),:);
       SSWk1 = SSWk1 + sum((abs(ctr-X(i,:))).^2);
    end

    
    H = (n-k-1) ;
    H1= (SSWk/(SSWk1-1));
    H = H * H1;
  
end