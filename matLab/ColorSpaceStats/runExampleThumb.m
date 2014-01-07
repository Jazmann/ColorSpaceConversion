skin = colorSpace(theta, C_Jasper(1,:), sig .* Sigma(1,:), [3,3,3], 0, 255, 0, 255, 1, 0);

img5 = imread('thumb1.JPG');
img6 = imread('thumb2.JPG');
img7 = imread('thumb3.JPG');
img8 = imread('thumb4.JPG');
img9 = imread('thumb5.JPG');
img10 = imread('thumb6.JPG');
img11 = imread('thumb7.JPG');

imgRot5 = skin.toRot(img5);
imgRot6 = skin.toRot(img6);
imgRot7 = skin.toRot(img7);
imgRot8 = skin.toRot(img8);
imgRot9 = skin.toRot(img9);
imgRot10 = skin.toRot(img10);
imgRot11 = skin.toRot(img11);

imgRotScaled5 = skin.toRotScaled(img5);
imgRotScaled6 = skin.toRotScaled(img6);
imgRotScaled7 = skin.toRotScaled(img7);
imgRotScaled8 = skin.toRotScaled(img8);
imgRotScaled9 = skin.toRotScaled(img9);
imgRotScaled10 = skin.toRotScaled(img10);
imgRotScaled11 = skin.toRotScaled(img11);

imgRotCompactScaled5 = skin.toRotCompactScaled(img5);
imgRotCompactScaled6 = skin.toRotCompactScaled(img6);
imgRotCompactScaled7 = skin.toRotCompactScaled(img7);
imgRotCompactScaled8 = skin.toRotCompactScaled(img8);
imgRotCompactScaled9 = skin.toRotCompactScaled(img9);
imgRotCompactScaled10 = skin.toRotCompactScaled(img10);
imgRotCompactScaled11 = skin.toRotCompactScaled(img11);


