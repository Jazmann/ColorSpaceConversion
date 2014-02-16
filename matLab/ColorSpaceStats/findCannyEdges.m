total = uint8(zeros(size(img)));
result = zeros(size(img));
tol_start = 95;
tol_end= 104;
for i=0:7
tol= i*(tol_end-tol_start)/7 + tol_start;
result = cv.Canny(img, [tol,(tol * 0.8)])/255;
total = total + result * 2^i;
end
imagesc(total)
figure(gcf)