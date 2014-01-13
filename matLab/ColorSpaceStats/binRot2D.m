function [binOut] = binRot2D(bin, theta )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
T = [cos(theta), sin(theta); -1*sin(theta),cos(theta)];

CrBins = size(bin,1); CbBins = size(bin,2);
Crv = 0:1/(CrBins-1):1;
Cbv = 0:1/(CbBins-1):1;
[Cr, Cb] = meshgrid(Crv, Cbv);
Cr = Cr';
Cb = Cb';
CrCbT = T * vertcat(reshape(Cr,1,[]),reshape(Cb,1,[]));

loc = find(bin>0);
ZGood = bin(loc)/max(max(max(bin)));

binOut = griddata(Cr(loc),Cb(loc),ZGood,reshape(CrCbT(1,:),size(bin)),reshape(CrCbT(2,:),size(bin)));
NaNLoc = isnan(binOut)==1;
binOut(NaNLoc) = 0;

end