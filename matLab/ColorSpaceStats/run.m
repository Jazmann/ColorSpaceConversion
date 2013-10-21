n=14;
ang = zeros(n+1);
x = zeros(n+1,6);
ang(1) = 0;
for i=1:n
    [Y, B, R, bin, A] = colorStats( ang(i), 0, 255, 256, 0, 255, 256, 0, 255, 256);
    %   x = [Amp,x0,wx,y0,wy,fi]: simulated centroid parameters
    x(i,:) = GaussianFit( B, R, squeeze(sum(bin,1)), [1,A(3),20.5,A(2),20.5,0], 'spline', 0);
    ang(i+1) = ang(i) + x(i,6);
end
 [Y, B, R, bin, A] = colorStats( ang(i+1), 0, 255, 256, 0, 255, 256, 0, 255, 256);
 %   x = [Amp,x0,wx,y0,wy,fi]: simulated centroid parameters
 x(n+1,:) = GaussianFit( B, R, squeeze(sum(bin,1)), [1,A(3),20.5,A(2),20.5,0], 'spline', 1);
 % Plot angle convergence
 angIterFig = figure('Name','Convergence of the skin space chromatic angle with itteration.','NumberTitle','off');
 plot(ang(:,1)); xlabel({'Iteration'}); ylabel({'Angle'}); title({'Convergence of the skin space chromatic angle with itteration.'});
 theta = sum(ang(6:15,1))/10;
 T =  int8(255 .* transformationMatrixLAB(theta));
 sigma = [255/sqrt(2), x(n+1,5), x(n+1,3)];
 g = [ 1, 255/(sqrt(2) .* sigma(2)), 255/(sqrt(2) .* sigma(3))];
 c = [128, x(n+1,4), x(n+1,2)];
 % Example
 img = imread(strcat('..\..\ColorSpaceConversion\hand_skin_test_3_back_1.jpg'));
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