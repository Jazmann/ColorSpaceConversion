function [ ] = imageChannels( img, fig )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
[rows, cols, chans] = size(img);
n = ceil(sqrt(chans+1));

figure(fig);
subplot(n,n,1)
image(img(:,:,1:3))
for c=1:chans
   subplot(n,n,c+1)
   image(rgbToMono(img,c))
end
end

