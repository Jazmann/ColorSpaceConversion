function out = procImage(img,color_J)
tol = 100;
img_prob = color_J.toProbability(img);
img_mask = uint8(img_prob(:,:,5) > tol);
cont_img = findContours(img_mask);
kill=8;
[row,col] = size(img_mask);
img_mask((1+kill/2):(row-kill/2),(1+kill/2):(col-kill/2)) = img_mask((1+kill/2):(row-kill/2),(1+kill/2):(col-kill/2)) - uint8(abs(double(img_mask(1:row-kill,1:col-kill))-double(img_mask(kill+1:row,kill+1:col))));
img_rot = color_J.toRot(img);
img_rot(:,:,1) = img_rot(:,:,1) .* img_mask;
img_rot(:,:,2) = img_rot(:,:,2) .* img_mask;
img_rot(:,:,3) = img_rot(:,:,3) .* img_mask;
img_canny = findCannyEdges(img_rot);
img_crop = cont_img.contours{1}.cropImg(img_rot);
out = img_crop;
end