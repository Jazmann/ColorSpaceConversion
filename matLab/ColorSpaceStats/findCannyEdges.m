function [ total ] = findCannyEdges( img, tol_start, tol_end )
if nargin <=2
    tol_end= 104;
    if nargin ==1
        tol_start = 95;
    end
end
if length(size(img))>2
    total = uint8(zeros(size(img)));
    
    for i=1:size(img,3)
        total(:,:,i) = cv.Canny(img(:,:,i), [tol_end,tol_start]);
    end
else
    
    total = uint8(zeros(size(img)));
    result = zeros(size(img));
    
    for i=0:7
        tol= i*(tol_end-tol_start)/7 + tol_start;
        result = cv.Canny(img, [tol,(tol * 0.8)])/255;
        total = total + (result .* 2^i);
    end
    
end

end

