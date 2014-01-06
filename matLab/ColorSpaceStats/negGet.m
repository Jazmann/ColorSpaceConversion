function [ ] = negGet( img1, img2, p1, p2 )

dImg1 = im2double(img1);
dImg2 = im2double(img2);

neg = dImg1(p2(2):p1(2),p1(1):p2(1),:) - dImg2(p2(2):p1(2),p1(1):p2(1),:);

%imageChannels(neg,cutFig1);

neg = neg - (min(min(min(neg))));

neg(:,:,1) = neg(:,:,1) ./ (max(max(neg(:,:,1))));
neg(:,:,2) = neg(:,:,2) ./ (max(max(neg(:,:,2))));
neg(:,:,3) = neg(:,:,3) ./ (max(max(neg(:,:,3))));

cutFig1 = figure('Name','Cut Fig Min/Max','NumberTitle','off');
imageChannels(neg,cutFig1);

edgeFilter = fspecial('gaussian');
smoothNeg = imfilter(neg,edgeFilter,'same');

cutFig2 = figure('Name','Cut Fig Smooth','NumberTitle','off');
imageChannels(smoothNeg,cutFig2);

negPressureEdge = zeros(size(smoothNeg));
negPressureEdge(:,:,1) = edge(smoothNeg(:,:,1),'canny',0.6);
negPressureEdge(:,:,2) = edge(smoothNeg(:,:,2),'canny',0.6);
negPressureEdge(:,:,3) = edge(smoothNeg(:,:,3),'canny',0.6);

cutFig3 = figure('Name','Cut Fig Edge','NumberTitle','off');
imageChannels(negPressureEdge,cutFig3);

end
