skin = colorSpace(theta, C2(1,:), Sigma(1,:), [3,3,3], 0, 255, 0, 255, 1, 0);

imgP1 = imread('pressure1.JPG');
imgP2 = imread('pressure2.JPG');
imgP3 = imread('pressure3.JPG');
imgP4 = imread('pressure4.JPG');
imgP5 = imread('pressure5.JPG');
imgP6 = imread('pressure6.JPG');
imgP7 = imread('pressure7.JPG');

imgRotP1 = skin.toRot(imgP1);
imgRotP2 = skin.toRot(imgP2);
imgRotP3 = skin.toRot(imgP3);
imgRotP4 = skin.toRot(imgP4);
imgRotP5 = skin.toRot(imgP5);
imgRotP6 = skin.toRot(imgP6);
imgRotP7 = skin.toRot(imgP7);

imgRotScaledP1 = skin.toRotScaled(imgP1);
imgRotScaledP2 = skin.toRotScaled(imgP2);
imgRotScaledP3 = skin.toRotScaled(imgP3);
imgRotScaledP4 = skin.toRotScaled(imgP4);
imgRotScaledP5 = skin.toRotScaled(imgP5);
imgRotScaledP6 = skin.toRotScaled(imgP6);
imgRotScaledP7 = skin.toRotScaled(imgP7);

imgRotCompactScaledP1 = skin.toRotCompactScaled(imgP1);
imgRotCompactScaledP2 = skin.toRotCompactScaled(imgP2);
imgRotCompactScaledP3 = skin.toRotCompactScaled(imgP3);
imgRotCompactScaledP4 = skin.toRotCompactScaled(imgP4);
imgRotCompactScaledP5 = skin.toRotCompactScaled(imgP5);
imgRotCompactScaledP6 = skin.toRotCompactScaled(imgP6);
imgRotCompactScaledP7 = skin.toRotCompactScaled(imgP7);

pFigP1 = figure('Name','Pressure 1','NumberTitle','off');
pFigP2 = figure('Name','Pressure 2','NumberTitle','off');
pFigP3 = figure('Name','Pressure 3','NumberTitle','off');
pFigP4 = figure('Name','Pressure 4','NumberTitle','off');
pFigP5 = figure('Name','Pressure 5','NumberTitle','off');
pFigP6 = figure('Name','Pressure 6','NumberTitle','off');
pFigP7 = figure('Name','Pressure 7','NumberTitle','off');