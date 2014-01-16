function [neg] = negGet( img1, img2, scale, pp1, pp2 )
if nargin<=3
    p1 = [1, 1];
    p2 = [min(size(img1,2),size(img2,2)), min(size(img1,1),size(img2,1))];
else
    p1 = [min(pp1(1),pp2(1)), max(pp1(1),pp2(1))];
    p2 = [min(pp1(2),pp2(2)), max(pp1(2),pp2(2))];
end

%dImg1 = im2double(img1);
%dImg2 = im2double(img2);

%neg = dImg1(p1(2):p2(2),p1(1):p2(1),:) - dImg2(p1(2):p2(2),p1(1):p2(1),:);

neg = img1(p1(2):p2(2),p1(1):p2(1),:) - img2(p1(2):p2(2),p1(1):p2(1),:) + scale;

%imageChannels(neg,cutFig1);

neg(:,:,1) = (neg(:,:,1)-(min(min(neg(:,:,1))))) ;
neg(:,:,2) = (neg(:,:,2)-(min(min(neg(:,:,2))))) ;
neg(:,:,3) = (neg(:,:,3)-(min(min(neg(:,:,3))))) ;

neg(:,:,1) = neg(:,:,1) ./ (max(max(max(neg(:,:,:)))));
neg(:,:,2) = neg(:,:,2) ./ (max(max(max(neg(:,:,2:3)))));
neg(:,:,3) = neg(:,:,3) ./ (max(max(max(neg(:,:,2:3)))));

%cutFig1 = figure('Name','Cut Fig Min/Max','NumberTitle','off');
%imageChannels(neg,cutFig1);

%edgeFilter = fspecial('gaussian');
%smoothNeg = imfilter(neg,edgeFilter,'same');

%cutFig2 = figure('Name','Cut Fig Smooth','NumberTitle','off');
%imageChannels(smoothNeg,cutFig2);

%negPressureEdge = zeros(size(smoothNeg));
%negPressureEdge(:,:,1) = edge(smoothNeg(:,:,1),'canny',0.6);
%negPressureEdge(:,:,2) = edge(smoothNeg(:,:,2),'canny',0.6);
%negPressureEdge(:,:,3) = edge(smoothNeg(:,:,3),'canny',0.6);

%cutFig3 = figure('Name','Cut Fig Edge','NumberTitle','off');
%imageChannels(negPressureEdge,cutFig3);

end
