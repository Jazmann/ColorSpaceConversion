function [ ] = getSURF(imgCell,fig,chan)

kpts = cell(7);
kptsImg = cell(7);

kpts{1} = cv.SURF(imgCell{1}(:,:,chan));
kpts{2} = cv.SURF(imgCell{2}(:,:,chan));
kpts{3} = cv.SURF(imgCell{3}(:,:,chan));
kpts{4} = cv.SURF(imgCell{4}(:,:,chan));
kpts{5} = cv.SURF(imgCell{5}(:,:,chan));
kpts{6} = cv.SURF(imgCell{6}(:,:,chan));
kpts{7} = cv.SURF(imgCell{7}(:,:,chan));

kptsImg{1} = cv.drawKeypoints(imgCell{1}(:,:,chan),kpts{1});
kptsImg{2} = cv.drawKeypoints(imgCell{2}(:,:,chan),kpts{2});
kptsImg{3} = cv.drawKeypoints(imgCell{3}(:,:,chan),kpts{3});
kptsImg{4} = cv.drawKeypoints(imgCell{4}(:,:,chan),kpts{4});
kptsImg{5} = cv.drawKeypoints(imgCell{5}(:,:,chan),kpts{5});
kptsImg{6} = cv.drawKeypoints(imgCell{6}(:,:,chan),kpts{6});
kptsImg{7} = cv.drawKeypoints(imgCell{7}(:,:,chan),kpts{7});

figure(fig);
subplot(4,3,1);
image(kptsImg{1});
subplot(4,3,2);
image(kptsImg{2});
subplot(4,3,3);
image(kptsImg{3});
subplot(4,3,4);
image(kptsImg{4});
subplot(4,3,5);
image(kptsImg{5});
subplot(4,3,6);
image(kptsImg{6});
subplot(4,3,7);
image(kptsImg{7});

end