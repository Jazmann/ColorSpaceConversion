skin = colorSpace(theta, C(1,:), sig .* Sigma(1,:), [3,3,3], 0, 255, 0, 255, 1, 0);
 
img = imread('pressure1.png');
img2 = imread('pressure2.png');
img3 = imread('pressure3.png');
img4 = imread('pressure4.png');

imgRot = skin.toRot(img);
imgRot2 = skin.toRot(img2);
imgRot3 = skin.toRot(img3);
imgRot4 = skin.toRot(img4);

imgRotScaled = skin.toRotScaled(img);
imgRotScaled2 = skin.toRotScaled(img2);
imgRotScaled3 = skin.toRotScaled(img3);
imgRotScaled4 = skin.toRotScaled(img4);

imgRotCompactScaled = skin.toRotCompactScaled(img);
imgRotCompactScaled2 = skin.toRotCompactScaled(img2);
imgRotCompactScaled3 = skin.toRotCompactScaled(img3);
imgRotCompactScaled4 = skin.toRotCompactScaled(img4);

rotFig = figure('Name','Rotated','NumberTitle','off');

pressureList(img, imgRot, img2, imgRot2, img3, imgRot3, img4, imgRot4, rotFig);

rotFig = figure('Name','Rotated Scaled','NumberTitle','off');

pressureList(img, imgRotScaled, img2, imgRotScaled2, img3, imgRotScaled3, img4, imgRotScaled4, rotFig);

rotFig = figure('Name','Rotated Compact Scaled','NumberTitle','off');

pressureList(img, imgRotCompactScaled, img2, imgRotCompactScaled2, img3, imgRotCompactScaled3, img4, imgRotCompactScaled4, rotFig);