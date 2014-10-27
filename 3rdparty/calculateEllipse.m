% http://www.mathworks.co.uk/matlabcentral/fileexchange/29674-sampling-of-2d-geometrical-object-via-line-beams/content/calculateEllipse.m

function [X Y] = calculateEllipse(x, y, a, b, angle, steps)
    %# This function returns points to draw an ellipse
    %#
    %#  @param x     X coordinate
    %#  @param y     Y coordinate
    %#  @param a     Semimajor axis
    %#  @param b     Semiminor axis
    %#  @param angle Angle of the ellipse (in degrees)
    %#

    error(nargchk(5, 6, nargin));
    if nargin<6, steps = 36; end

    beta = -angle * (pi / 180);
    sinbeta = sin(beta);
    cosbeta = cos(beta);

    % 0 degrees is at 3 oclock?
    alpha = linspace(0, 360, steps)' .* (pi / 180);
    sinalpha = sin(alpha);
    cosalpha = cos(alpha);

    X = x + (a * cosalpha * cosbeta - b * sinalpha * sinbeta);
    Y = y + (a * cosalpha * sinbeta + b * sinalpha * cosbeta);

    if nargout==1, X = [X Y]; end
end
