function [ hessian ] = getHessianXY( hessianmatrix, sizeIm, row, col )
%GETHESSIANXY Look up the hessian matrix at the given row,col coordinates
%   The HESSIANMATRIX should contain the values of Lxx Lxy Lxy Lyy in a p by 4 matrix
%   SIZEIM is needed to find the linear index for the row and col.
    
    [linind] = sub2ind(sizeIm,row,col);
    temp = hessianmatrix(linind,[1 2 2 3]);
    % build the 2 x 2 matrix [Lxx Lxy; Lxy Lyy]
    hessian = reshape(temp,2,2);
    

end

