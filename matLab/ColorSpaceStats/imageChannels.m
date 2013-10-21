function [ ] = imageChannels( img, fig )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
figure(fig);
subplot(2,2,1)
image(img)
subplot(2,2,2)
image(rgbToMono(img,1))
subplot(2,2,3)
image(rgbToMono(img,2))
subplot(2,2,4)
image(rgbToMono(img,3))
end

