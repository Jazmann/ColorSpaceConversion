skinJasper = colorSpace(theta, C_Jasper(1,:), Sigma(1,:), [3,3,3], 0, 255, 0, 255, 1, 0);

img5 = imread('thumb1.JPG');
img6 = imread('thumb2.JPG');
img7 = imread('thumb3.JPG');
img8 = imread('thumb4.JPG');
img9 = imread('thumb5.JPG');
img10 = imread('thumb6.JPG');
img11 = imread('thumb7.JPG');

imgRot5 = skinJasper.toRot(img5);
imgRot6 = skinJasper.toRot(img6);
imgRot7 = skinJasper.toRot(img7);
imgRot8 = skinJasper.toRot(img8);
imgRot9 = skinJasper.toRot(img9);
imgRot10 = skinJasper.toRot(img10);
imgRot11 = skinJasper.toRot(img11);

imgRotScaled5 = skinJasper.toRotScaled(img5);
imgRotScaled6 = skinJasper.toRotScaled(img6);
imgRotScaled7 = skinJasper.toRotScaled(img7);
imgRotScaled8 = skinJasper.toRotScaled(img8);
imgRotScaled9 = skinJasper.toRotScaled(img9);
imgRotScaled10 = skinJasper.toRotScaled(img10);
imgRotScaled11 = skinJasper.toRotScaled(img11);

imgRotCompactScaled5 = skinJasper.toRotCompactScaled(img5);
imgRotCompactScaled6 = skinJasper.toRotCompactScaled(img6);
imgRotCompactScaled7 = skinJasper.toRotCompactScaled(img7);
imgRotCompactScaled8 = skinJasper.toRotCompactScaled(img8);
imgRotCompactScaled9 = skinJasper.toRotCompactScaled(img9);
imgRotCompactScaled10 = skinJasper.toRotCompactScaled(img10);
imgRotCompactScaled11 = skinJasper.toRotCompactScaled(img11);


