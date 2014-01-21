% [Y B R bin A] = colorStats( 0.114, 0.299, pi/2 -0.778, 0, 255, 256, 0, 255, 256, 0, 255, 256)
function [ rgbBin, LxyBin] = genRGBBins(dirName)
%
dataMin  = 0; dataMax = 255; 
rgbBin = Bin([dataMax+1,dataMax+1,dataMax+1],[dataMin,dataMin,dataMin],[dataMax,dataMax,dataMax]);
LxyBin = Bin([ceil(sqrt(3.) * dataMax)+1, ceil(2 * sqrt(2./3.) * dataMax)+1, ceil(sqrt(2.) * dataMax)+1], [0,0,0], [3*dataMax,4*dataMax,2*dataMax]);

TZero = [1,1,1;(-1),2,(-1);(-1),0,1];
TzeroScale = [1/sqrt(3),1/sqrt(6),1/sqrt(2)];

D = [dir(strcat(dirName,'/*.jpg')),dir(strcat(dirName,'/*.JPG'))];
for k = 1:numel(D)
  img = imread(strcat(dirName,'/',D(k).name));
[rows, cols, channels] = size(img);
for i = 1:rows
    for j = 1:cols
        chanVals = squeeze(img(i,j,:))  + 1;
        rgbBin = rgbBin.addValue(chanVals);
        chromVals = TZero * double((chanVals)) + [0; 2*dataMax; dataMax] +1;
        LxyBin = LxyBin.addValue(chromVals);
    end
end

end

% save the output Rv, Gv, Bv, binOut, cA
save(strcat(dirName,'/rgbBin'),'rgbBin');
save(strcat(dirName,'/LxyBin'),'LxyBin');

end

