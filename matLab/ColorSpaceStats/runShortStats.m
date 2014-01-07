
% Load the images and perform the statistics for a histogram with theta = 0
dirName = 'Hands';
% theta = Must be defined before evaluation;
C = zeros(1,3);
Sigma = sigma(end,:);
x = zeros(1,6);
 [YOut, BOut, ROut, binOut, AOut] = colorStats(dirName, theta, 0, 255, 256, 0, 255, 256, 0, 255, 256);
 newBins = binOut(50:200,:,:);
 binOutBR=squeeze(sum(newBins,1));
 binOutBR=binOutBR/max(max(binOutBR));
 %   x = [Amp,x0,wx,y0,wy,fi]
 x(1,:) = GaussianFit( BOut, ROut, binOutBR, [1,AOut(3),Sigma(1,3),AOut(2),Sigma(1,2),0], 'spline', 1);
 C(1,:) = [128, x(1,4),x(1,2)];
 Sigma(1,:) = [255/sqrt(2), x(1,5), x(1,3)];
 
g = [ 1, 255/(sqrt(2) .* Sigma(1,2)), 255/(sqrt(2) .* Sigma(1, 3))];
 
skin = colorSpace(theta, C(1,:), Sigma(1,:), [3,3,3], 0, 255, 0, 255, 1, 0);
