
edgeImgRotCompactScaled = imgRotCompactScaled;

%edgeImgRotCompactScaled(:,:,1) = 0;
%edgeImgRotCompactScaled(:,:,3) = 0;
grayImgRotCompactScaled = edgeImgRotCompactScaled(:,:,1);
%grayImgRotCompactScaled = rgb2gray(edgeImgRotCompactScaled);
pressureEdge = zeros(size(edgeImgRotCompactScaled));
pressureEdge(:,:,1) = edge(edgeImgRotCompactScaled(:,:,1), 'canny',0.16);
pressureEdge(:,:,2) = edge(edgeImgRotCompactScaled(:,:,2), 'canny',0.4);
pressureEdge(:,:,3) = edge(edgeImgRotCompactScaled(:,:,3), 'canny',0.4);

figure(21), imshow(pressureEdge(:,:,1));
figure(22), imshow(pressureEdge(:,:,2));
figure(23), imshow(pressureEdge(:,:,3));

edgeImgRotScaled = imgRotScaled;

edgeImgRotScaled(:,:,1) = 0;
edgeImgRotScaled(:,:,3) = 0;

grayImgRotScaled = rgb2gray(edgeImgRotScaled);

pressureEdge = edge(grayImgRotScaled, 'canny',0.5);

figure, imshow(pressureEdge);
%pressureEdge2 = edge(imgRotScaled2, 'canny');
%pressureEdge3 = edge(imgRotScaled3, 'canny');
%pressureEdge4 = edge(imgRotScaled4, 'canny');

