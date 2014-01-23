function [ rgbPoint ] = Lxy2RGB_bin( point )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

dataMin  = 0; dataMax = 255; 
TZero = [1,1,1;(-1),2,(-1);(-1),0,1];
TzeroScale = [1/sqrt(3),1/sqrt(6),1/sqrt(2)];
iTZero = inv(TZero);

rgbPoint = iTZero * (point - [0; 2*dataMax; dataMax] - 1);

end

