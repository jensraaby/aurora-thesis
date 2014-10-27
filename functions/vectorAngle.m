function angle = vectorAngle(u,v)
    %  angle = vectorAngle(u,v)

if size(u) ~= size(v)
    error('vectors must be same size')'
end
CosTheta = dot(u,v)/(norm(u)*norm(v));
% convert to degrees:
angle = acos(CosTheta)*180/pi;


% quiver([0,0],[0,0],u,v,'AutoScale','off')