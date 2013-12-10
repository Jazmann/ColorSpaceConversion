
% Load the images and perform the statistics for a histogram with theta = 0
% dirName = 'SkinSamples';
% [Y, B, R, bin, A] = colorStats(dirName, 0, 0, 255, 256, 0, 255, 256, 0, 255, 256);
% binBR=squeeze(sum(bin,1));
% binBR=binBR/max(max(binBR));
% Initialize the variables for the iteration over angle.
n=5;
ang = zeros(n+1,1);
c = zeros(n+1,2);
sigma = zeros(n+1,2);
x = zeros(n+1,6);
ang(1) = 0;
c = [A(2),A(3)];
sigma = [20.5,20.5];
BR = [B;R];
for i=1:n
 [YOut, BOut, ROut, binOut, AOut] = colorStats(dirName, ang(i), 0, 255, 256, 0, 255, 256, 0, 255, 256);
 binOutBR=squeeze(sum(binOut,1));
 binOutBR=binOutBR/max(max(binOutBR));
 %   x = [Amp,x0,wx,y0,wy,fi]: simulated centroid parameters
 x(i,:) = GaussianFit( BOut, ROut, binOutBR, [1,AOut(3),sigma(2),AOut(2),sigma(1),0], 'spline', 1);
    %   x = [Amp,x0,wx,y0,wy,fi]: simulated centroid parameters
 %   x(i,:) = GaussianFit( BR(1,:), BR(2,:), binBR, [1,c(2),sigma(1),c(1),sigma(2),0], 'spline', 0);
    ang(i+1) = ang(i) + x(i,6);
   % c = binRot([x(i,4);x(i,2)],x(i,6))';
    c(i,:) = [x(i,4),x(i,2)];
    sigma(i,:) = [x(i,5), x(i,3)];
 %   BR = binRot([B;R],ang(i+1));
end
 [YOut, BOut, ROut, binOut, AOut] = colorStats(dirName, ang(i+1), 0, 255, 256, 0, 255, 256, 0, 255, 256);
 binOutBR=squeeze(sum(binOut,1));
 binOutBR=binOutBR/max(max(binOutBR));
 %   x = [Amp,x0,wx,y0,wy,fi]: simulated centroid parameters
 x(n+1,:) = GaussianFit( BOut, ROut, binOutBR, [1,AOut(3),sigma(2),AOut(2),sigma(1),0], 'spline', 1);
 % Plot angle convergence
 angIterFig = figure('Name','Convergence of the skin space chromatic angle with itteration.','NumberTitle','off');
 plot(ang(:,1)); xlabel({'Iteration'}); ylabel({'Angle'}); title({'Convergence of the skin space chromatic angle with itteration.'});
 theta = ang(i+1)+ x(i,6);
 T =  int8(255 .* transformationMatrixLAB(theta));
 sigma = [255/sqrt(2), x(n+1,5), x(n+1,3)];
 g = [ 1, 255/(sqrt(2) .* sigma(2)), 255/(sqrt(2) .* sigma(3))];
 c = [128, x(n+1,4), x(n+1,2)];
 % Example
 img = imread('hand_skin_test_3_back_1.jpg');
 rgbFig = figure('Name','RGB','NumberTitle','off');
 imageChannels(img,rgbFig);
 allFig = figure('Name','spaces','NumberTitle','off');
 [ img2, img3] = showColorSpaces(img, theta, g, c, allFig);
 yabFig = figure('Name','Skin color space','NumberTitle','off');
 img2 = rgbToSkin(img, double(T), 255, 255, 255);
 imageChannels(img2,yabFig);
 yabScaledFig = figure('Name','Scaled Skin color space','NumberTitle','off');
 img3 = rgbToSkinScaled(img2, g, c, 0, 255, 0, 255);
 imageChannels(img3,yabScaledFig);