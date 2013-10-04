n=4;
angle = zeros(n+1);
x = zeros(n,6);
angle(1) = -0.9313;
for i=1:n
    [Y, B, R, bin, A] = colorStats( 0.114, 0.299, angle(i), 0, 255, 256, 0, 255, 256, 0, 255, 256);
    x(i,:) = GaussianFit( B, R, squeeze(sum(bin,2)), [1,A(3),20.5,A(2),20.5,-pi/8], 'spline', 0);
    angle(i+1) = angle(i) + x(1,6);
end
 T =  int8(transformationMatrix(0.114, 0.299, angle(n+1),255,255,255))