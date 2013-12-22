
% Kb = 0.114;  Kr = 0.299; yScale = 219; bScale = 224; rScale = 224;bMin=0;rMin=0;theta = 0.7854;
function ycbcrImage = rgbToYcbcr(rgbImage,Kb, Kr, theta, yScale, bScale, rScale)
% Matrix multiplication with RGB 0:1 gives YCbCr 0:1 -0.5:0.5 -0.5:0.5
A = [Kr.*yScale,                             (1+(-1).*Kb+(-1).*Kr).*yScale,                             Kb.*yScale;...
     (-1/2).*bScale.*(1+(-1).*Kb).^(-1).*Kr, (-1/2).*bScale.*(1+(-1).*Kb).^(-1).*(1+(-1).*Kb+(-1).*Kr), (1/2).*bScale;...
     (1/2).*rScale,                          (-1/2).*(1+(-1).*Kr).^(-1).*(1+(-1).*Kb+(-1).*Kr).*rScale, (-1/2).*Kb.*(1+(-1).*Kr).^(-1).*rScale ]; 
B = A' * [ 1, 0, 0; 0, cos(theta), sin(theta); 0, -sin(theta), cos(theta)]';

%# First convert the RGB image to double precision, scale its values to the
%#   range 0 to 1, reshape it to an N-by-3 matrix, and multiply by A:
ycbcrImage = reshape(double(rgbImage)./255,[],3) * B;
%# Shift each color plane (stored in each column of the N-by-3 matrix):
ycbcrImage(:,1) = ycbcrImage(:,1);
ycbcrImage(:,2) = ycbcrImage(:,2) + 0.5 .* bScale;
ycbcrImage(:,3) = ycbcrImage(:,3) + 0.5 .* rScale;

%# Convert back to type uint8 and reshape to its original size:
ycbcrImage = reshape(uint8(ycbcrImage),size(rgbImage));

end % function