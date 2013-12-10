function BROut = binRot( BR, theta )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
transformMatrix = ...
[cos(theta)*sec(pi/6. - mod((-pi/6. + theta), pi/3.)),(sqrt(3)*sec(pi/6. - mod((-pi/6. + theta), pi/3.))*sin(theta))/2.;...
 -(sec(pi/6. - mod(theta, pi/3.))*sin(theta)),(sqrt(3)*cos(theta)*sec(pi/6. - mod(theta, pi/3.)))/2.];
BROut = transformMatrix * BR;   
end

