% colorStats( 0.114, 0.299, pi/2 -0.778, 0, 255, 256, 0, 255, 256, 0, 255, 256)
function [ Yv, Bv, Rv, binOut ] = colorStats( Kb, Kr, theta, yMin, yMax, yBins, bMin, bMax, bBins, rMin, rMax, rBins)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

% xMin = 16/255; xMax = 240/255;
% yMin = 16/255; yMax = 240/255;
% [X,Y] = meshgrid(xMin:(xMax-xMin)/(MdataSize-1):xMax,yMin:(yMax-yMin)/(MdataSize-1):yMax);

% New values for YCbCr space.
% Kb = 0.114;  Kr = 0.299; theta = pi/2 -0.778;
yScale = yMax - yMin;
bScale = bMax - bMin;
rScale = rMax - rMin;
Yv = yMin:(yMax-yMin)/(yBins-1):yMax;
Bv = bMin:(bMax-bMin)/(bBins-1):bMax;
Rv = rMin:(rMax-rMin)/(rBins-1):rMax;
[Y, B, R] = meshgrid(Yv, Bv,Rv);
% Bin map : input chan value - chan min +1 (1:chanScale+1) : Output bin
% number (1:chanBins).
yBin = floor((0:yScale).*(yBins)./(yScale+1))+1;
bBin = floor((0:bScale).*(bBins)./(bScale+1))+1;
rBin = floor((0:rScale).*(rBins)./(rScale+1))+1;

bin(yBins,bBins,rBins) = 0;
c = [0 0 0];
cT = [0 0 0];
cA = [0 0 0];
cN = 0;


D = dir('Skin Samples/*.jpg');
imcell = cell(1,numel(D));
for k = 1:numel(D)
  % imcell{k} = rgb2ycbcr(imread(strcat('Skin Samples/',D(k).name)));
  imcell{k} = rgbToYcbcr(imread(strcat('Skin Samples/',D(k).name)), Kb, Kr, theta, yScale, bScale, rScale);
[rows, cols, channels] = size(imcell{k});
for i = 1:rows
    for j = 1:cols
        c = squeeze(imcell{k}(i,j,:)) - uint8([yMin; bMin; rMin]) + 1;
        bin(yBin(c(1)),bBin(c(2)),rBin(c(3))) = bin(yBin(c(1)),bBin(c(2)),rBin(c(3))) + 1;
    end
end

end


for i = 1:rBins
    for j = 1:bBins
        for k = 1:yBins
            cT(1) = cT(1) + bin(k,j,i) * Y(k,j,i);
            cT(2) = cT(2) + bin(k,j,i) * B(k,j,i);
            cT(3) = cT(3) + bin(k,j,i) * R(k,j,i);
            cN  = cN  + bin(k,j,i);
        end
    end
end

cA = cT/cN;


%--- Normalised Histogram data ---------------------
% we remove zeros from the input bin data as some are due to the color
% space rotation and they affect the sigma values.
loc = find(bin>0);
ZGood = bin(loc)/max(max(max(bin)));

binOut = griddata(Y(loc),B(loc),R(loc),ZGood,Y,B,R);
NaNLoc = isnan(binOut)==1;
binOut(NaNLoc) = 0;

data = zeros(size(Y,1),size(B,2),size(R,3), 4);
data(:,:,:,1) = Y;
data(:,:,:,2) = B;
data(:,:,:,3) = R;
data(:,:,:,4) = binOut;

imagesc(squeeze(sum(binOut,1)));
imagesc(squeeze(sum(binOut,2)));
imagesc(squeeze(sum(binOut,3)));

%[X, Y, Z] = meshgrid(0:1:254);

%scatter3(X(:),Y(:),Z(:),bin(:))

end

