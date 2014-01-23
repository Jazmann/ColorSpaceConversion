% [Y B R bin A] = colorStats( 0.114, 0.299, pi/2 -0.778, 0, 255, 256, 0, 255, 256, 0, 255, 256)
function [ rgbBin, LxyBin] = getRGBBinsImg(img)
%
dataMin  = 0; dataMax = 255; 
rgbBin = Bin([dataMax+1,dataMax+1,dataMax+1],[dataMin,dataMin,dataMin],[dataMax,dataMax,dataMax]);
LxyBin = Bin([ceil(sqrt(3.) * dataMax)+1, ceil(2 * sqrt(2./3.) * dataMax)+1, ceil(sqrt(2.) * dataMax)+1], [0,0,0], [3*dataMax,4*dataMax,2*dataMax]);

TZero = [1,1,1;(-1),2,(-1);(-1),0,1];
TzeroScale = [1/sqrt(3),1/sqrt(6),1/sqrt(2)];

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

