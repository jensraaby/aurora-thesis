function [ scales ] = generateScaleVector( initialscale, numscales, growth )
%%% [ scales ] = generateScaleVector( initialscale, numscales, growth )

% default growth rate is 10% per scale
    if nargin < 3
        growth = 1.1;
    end
    scales = zeros(1,numscales);
    for n = 1:numscales
        scales(n) = growth.^(n) * initialscale ;
    end
end

