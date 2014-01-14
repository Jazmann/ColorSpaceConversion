function [binOut] = binRot2D(bin, thetaIn )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
theta = -1. * thetaIn; % the src is rotated so flip the sign.
T = [cos(theta), sin(theta); -1*sin(theta),cos(theta)];
TScale = sqrt(2) * sin(mod(theta, pi/2.)+pi/4.);

CrBins = size(bin,1); CbBins = size(bin,2);
Crv = -1:2/(CrBins-1):1;
Cbv = -1:2/(CbBins-1):1;
[Cr, Cb] = meshgrid(Crv, Cbv);
Cr = Cr';
Cb = Cb';
CrCbT = T * vertcat(reshape(Cr,1,[]),reshape(Cb,1,[])) ./ TScale;
CrT = reshape(CrCbT(1,:),size(bin));
CbT = reshape(CrCbT(2,:),size(bin));

loc = find(bin>0);
ZGood = bin(loc)/max(max(max(bin)));

binOut = griddata(CrT(loc),CbT(loc),ZGood,Cr,Cb);
NaNLoc = isnan(binOut)==1;
binOut(NaNLoc) = 0;

end