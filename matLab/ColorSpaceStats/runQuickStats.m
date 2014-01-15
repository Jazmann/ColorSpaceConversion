% Load the images and perform the statistics for a histogram with theta = 0
dirName = 'SelfSkinSamples2';
load(strcat(dirName,'/chromBin.mat'));
load(strcat(dirName,'/cA.mat'));
AOutRGB = cA;
% Initialize the variables for the iteration over angle.
nMax=12; tol = 10^-6;
ang = zeros(nMax+1,1);
c = zeros(nMax+1,3);
sigma = zeros(nMax+1,3);
x = zeros(nMax+1,6);
sigma(1,:) = [0.5, 0.5,0.5];

CrBins = size(chromBin,1); CbBins = size(chromBin,2);

Crv = 0:1/(CrBins-1):1;
Cbv = 0:1/(CbBins-1):1;

trans = transform(ang(1),'yes');

c(1,:) = trans.toRot((AOutRGB ./ 255));

c(1,:) = AOut;

for i=1:nMax
 chromBinOut=binRot2D(chromBin,ang(i));
 %   x = [Amp,x0,wx,y0,wy,fi]
 x(i,:) = GaussianFit( Cbv, Crv, chromBinOut, [1,c(i,3),0.5,c(i,2),0.5,0], 'spline', 0);
 ang(i+1) = ang(i) + x(i,6);
 c(i+1,:) = [0.5, x(i,4),x(i,2)];
 sigma(i+1,:) = [1/sqrt(2), x(i,5), x(i,3)];
 if abs(x(i,6)) < tol 
     break
 end
end

theta = ang(i+1);
g = [ 1, 255/(sqrt(2) .* sigma(i+1,2)), 255/(sqrt(2) .* sigma(i+1, 3))];
sigma = sigma(1:i+1,:);
c = c(1:i+1,:);
ang = ang(1:i+1,1);

C = zeros(1,3); C = c(end,:);
Sigma = sigma(end,:); Sigma = sigma(end,:);

skin = colorSpace(theta, C, Sigma, [3,3,3], 0, 255, 0, 255, 1, 0);

save(strcat(dirName,'/theta'),'theta');
save(strcat(dirName,'/sigma'),'sigma');
save(strcat(dirName,'/c'),'c');
save(strcat(dirName,'/ang'),'ang');
save(strcat(dirName,'/C'),'C');
save(strcat(dirName,'/Sigma'),'Sigma');

 % Plot angle convergence
 angIterFig = figure('Name','Convergence of the skin space chromatic angle with itteration.','NumberTitle','off');
 plot(ang(:,1)); xlabel({'Iteration'}); ylabel({'Angle'}); title({'Convergence of the skin space chromatic angle with itteration.'});
 
 