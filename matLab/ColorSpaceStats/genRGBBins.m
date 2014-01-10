% [Y B R bin A] = colorStats( 0.114, 0.299, pi/2 -0.778, 0, 255, 256, 0, 255, 256, 0, 255, 256)
function [ Rv, Gv, Bv, binOut, cA ] = genRGBBins(dirName, rMin, rMax, rBins, gMin, gMax, gBins, bMin, bMax, bBins)
%
if nargin<2
    rMin = 0; rMax = 255; rBins = 256; gMin = 0; gMax = 255; gBins =256; bMin = 0; bMax =255; bBins = 256;
end

rScale = rMax - rMin;
gScale = gMax - gMin;
bScale = bMax - bMin;
Rv = rMin:(rMax-rMin)/(rBins-1):rMax;
Gv = gMin:(gMax-gMin)/(gBins-1):gMax;
Bv = bMin:(bMax-bMin)/(bBins-1):bMax;
[G, R, B] = meshgrid(Rv, Gv, Bv);
% Bin map : input chan value - chan min +1 (1:chanScale+1) : Output bin
% number (1:chanBins).
rBin = floor((0:rScale).*(rBins)./(rScale+1))+1;
gBin = floor((0:gScale).*(gBins)./(gScale+1))+1;
bBin = floor((0:bScale).*(bBins)./(bScale+1))+1;

bin = zeros(rBins,gBins,bBins);
chanVals = [0 0 0];
cT = [0 0 0];
cA = [0 0 0];
cN = 0;

D = [dir(strcat(dirName,'/*.jpg')),dir(strcat(dirName,'/*.JPG'))];
% D = dir('SkinSamples/*.jpg');
imcell = cell(1,numel(D));
for k = 1:numel(D)
  % imcell{k} = rgb2ycbcr(imread(strcat('Skin Samples/',D(k).name)));
  % imcell{k} = rgbToYcbcr(imread(strcat('Skin Samples/',D(k).name)), Kb, Kr, theta, yScale, bScale, rScale);
  imcell{k} = imread(strcat(dirName,'/',D(k).name));
[rows, cols, channels] = size(imcell{k});
for i = 1:rows
    for j = 1:cols
        chanVals = squeeze(imcell{k}(i,j,:)) - uint8([rMin; gMin; bMin]) + 1;
        bin(rBin(chanVals(1)),gBin(chanVals(2)),bBin(chanVals(3))) = bin(rBin(chanVals(1)),gBin(chanVals(2)),bBin(chanVals(3))) + 1;
    end
end

end

for i = 1:bBins
    for j = 1:gBins
        for k = 1:rBins
            cT(1) = cT(1) + bin(k,j,i) * R(k,j,i);
            cT(2) = cT(2) + bin(k,j,i) * G(k,j,i);
            cT(3) = cT(3) + bin(k,j,i) * B(k,j,i);
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

binOut = griddata(R(loc),G(loc),B(loc),ZGood,R,G,B);
NaNLoc = isnan(binOut)==1;
binOut(NaNLoc) = 0;

% save the output Rv, Gv, Bv, binOut, cA
save(strcat(dirName,'/Rv',Rv));
save(strcat(dirName,'/Gv',Gv));
save(strcat(dirName,'/Bv',Bv));
save(strcat(dirName,'/binOut',binOut));
save(strcat(dirName,'/cA',cA));

figure('Name','Bins','NumberTitle','off');
subplot(1,3,1)
imagesc(squeeze(sum(binOut,1)));
subplot(1,3,2)
imagesc(squeeze(sum(binOut,2)));
subplot(1,3,3)
imagesc(squeeze(sum(binOut,3)));

end

