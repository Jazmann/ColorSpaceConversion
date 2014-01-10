function [RvOut, GvOut, BvOut, binOut] = binRot( Rv, Gv, Bv, bin, cA, theta )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
trans = transform(theta,'no');
binOut = zeros(trans.intIndx(1),trans.intIndx(2),trans.intIndx(3));
RvOut = zeros(size(Rv));
GvOut = zeros(size(Gv));
BvOut = zeros(size(Bv));

Yv = yMin:(yMax-yMin)/(yBins-1):yMax;
Bv = bMin:(bMax-bMin)/(bBins-1):bMax;
Rv = rMin:(rMax-rMin)/(rBins-1):rMax;

[rBins,gBins,bBins] = size(bin);
for i = 1:bBins
    for j = 1:gBins
        for k = 1:rBins
            idx = trans.toRotIndx([Rv(k), Gv(j), Bv(i)]);
            binOut(idx(k), idx(j), idx(i)) =  bin(k,j,i);
            [RvOut(k), GvOut(j), BvOut(i)] = trans.toRot([Rv(k), Gv(j), Bv(i)]);
        end
    end
end

end

