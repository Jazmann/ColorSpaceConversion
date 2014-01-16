Trans = transform(0,'no');
dirName = 'NSkinSamples';

Img1 = imread(strcat(dirName,'/pressure1.JPG'));
Img2 = imread(strcat(dirName,'/pressure2.JPG'));
Img3 = imread(strcat(dirName,'/pressure3.JPG'));
Img4 = imread(strcat(dirName,'/pressure4.JPG'));
Img5 = imread(strcat(dirName,'/pressure5.JPG'));
Img6 = imread(strcat(dirName,'/pressure6.JPG'));
Img7 = imread(strcat(dirName,'/pressure7.JPG'));

ImgX = Img1;

Img1 = reshape(double(Img1)./255,[],3);
Img2 = reshape(double(Img2)./255,[],3);
Img3 = reshape(double(Img3)./255,[],3);
Img4 = reshape(double(Img4)./255,[],3);
Img5 = reshape(double(Img5)./255,[],3);
Img6 = reshape(double(Img6)./255,[],3);
Img7 = reshape(double(Img7)./255,[],3);

Img1 = nTrans.toRot(Img1);
Img2 = nTrans.toRot(Img2);
Img3 = nTrans.toRot(Img3);
Img4 = nTrans.toRot(Img4);
Img5 = nTrans.toRot(Img5);
Img6 = nTrans.toRot(Img6);
Img7 = nTrans.toRot(Img7);


Img1 = reshape(Img1,size(ImgX));
Img2 = reshape(Img2,size(ImgX));
Img3 = reshape(Img3,size(ImgX));
Img4 = reshape(Img4,size(ImgX));
Img5 = reshape(Img5,size(ImgX));
Img6 = reshape(Img6,size(ImgX));
Img7 = reshape(Img7,size(ImgX));

d12 = negGet(Img1,Img2,255);
d23 = negGet(Img2,Img3,255);
d34 = negGet(Img3,Img4,255);
d45 = negGet(Img4,Img5,255);
d56 = negGet(Img5,Img6,255);
d67 = negGet(Img6,Img7,255);

save(strcat(dirName,'/d12'),'d12');
save(strcat(dirName,'/d23'),'d23');
save(strcat(dirName,'/d34'),'d34');
save(strcat(dirName,'/d45'),'d45');
save(strcat(dirName,'/d56'),'d56');
save(strcat(dirName,'/d67'),'d67');

imwrite(strcat(dirName,'/d12'),'D12.jpg');
imwrite(strcat(dirName,'/d23'),'D23.jpg');
imwrite(strcat(dirName,'/d34'),'D34.jpg');
imwrite(strcat(dirName,'/d45'),'D45.jpg');
imwrite(strcat(dirName,'/d56'),'D56.jpg');
imwrite(strcat(dirName,'/d67'),'D67.jpg');
