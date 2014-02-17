function out = procImages(img1,img2,color_J)
tol = 100;
img1_prob = color_J.toProbability(img1);
img1_mask = uint8(img1_prob(:,:,5) > tol);
cont1_img = findContours(img1_mask);
img1_rot = color_J.toRot(img1);
img1_rot(:,:,1) = img1_rot(:,:,1) .* img1_mask;
img1_rot(:,:,2) = img1_rot(:,:,2) .* img1_mask;
img1_rot(:,:,3) = img1_rot(:,:,3) .* img1_mask;
img1_canny = findCannyEdges(img1_rot);
img1_crop = cont1_img.contours{1}.cropImg(img1_rot);
img1_mask = cont1_img.contours{1}.cropImg(img1_mask);
kill=8;
[row,col] = size(img1_mask);
img1_mask((1+kill/2):(row-kill/2),(1+kill/2):(col-kill/2)) = img1_mask((1+kill/2):(row-kill/2),(1+kill/2):(col-kill/2)) - uint8(abs(double(img1_mask(1:row-kill,1:col-kill))-double(img1_mask(kill+1:row,kill+1:col))));


img2_prob = color_J.toProbability(img2);
img2_mask = uint8(img2_prob(:,:,5) > tol);
cont2_img = findContours(img2_mask);
img2_rot = color_J.toRot(img2);
img2_rot(:,:,1) = img2_rot(:,:,1) .* img2_mask;
img2_rot(:,:,2) = img2_rot(:,:,2) .* img2_mask;
img2_rot(:,:,3) = img2_rot(:,:,3) .* img2_mask;
img2_canny = findCannyEdges(img2_rot);
img2_crop = cont2_img.contours{1}.cropImg(img2_rot);
img2_mask = cont2_img.contours{1}.cropImg(img2_mask);
kill=8;
[row,col] = size(img2_mask);
img2_mask((1+kill/2):(row-kill/2),(1+kill/2):(col-kill/2)) = img2_mask((1+kill/2):(row-kill/2),(1+kill/2):(col-kill/2)) - uint8(abs(double(img2_mask(1:row-kill,1:col-kill))-double(img2_mask(kill+1:row,kill+1:col))));
row = min(size(img2_crop,1),size(img1_crop,1));
col = min(size(img2_crop,2),size(img1_crop,2));

delta = abs(double(img1_crop(1:row,1:col,:)) - double(img2_crop(1:row,1:col,:)));
delta(:,:,1) = delta(:,:,1) .* double(img2_mask(1:row,1:col));
delta(:,:,2) = delta(:,:,2) .* double(img2_mask(1:row,1:col));
delta(:,:,3) = delta(:,:,3) .* double(img2_mask(1:row,1:col));

delta(:,:,1) = delta(:,:,1) .* double(img1_mask(1:row,1:col));
delta(:,:,2) = delta(:,:,2) .* double(img1_mask(1:row,1:col));
delta(:,:,3) = delta(:,:,3) .* double(img1_mask(1:row,1:col));


delta = delta /max(max(max(delta)));

% delta(:,:,1) = delta(:,:,1) /max(max(delta(:,:,1)));
% delta(:,:,2) = delta(:,:,2) /max(max(delta(:,:,2)));
% delta(:,:,3) = delta(:,:,3) /max(max(delta(:,:,3)));


out = delta;
end