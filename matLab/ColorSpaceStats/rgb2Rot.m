function rgb2RotImage = rgb2Rot(rgbImage,theta, yScale, aScale, bScale)
% Matrix multiplication with RGB 0:1 gives YCbCr 0:1 -0.5:0.5 -0.5:0.5
T = transformationMatrixLAB(theta);
 
%# First convert the RGB image to double precision, scale its values to the
%#   range 0 to 1, reshape it to an N-by-3 matrix, and multiply by A:
rgb2RotImage = reshape(double(rgbImage)./255,[],3) * T';
%# Shift each color plane (stored in each column of the N-by-3 matrix):
rgb2RotImage(:,1) =  rgb2RotImage(:,1) .* yScale ;
rgb2RotImage(:,2) = (rgb2RotImage(:,2) + 0.5) .* aScale;
rgb2RotImage(:,3) = (rgb2RotImage(:,3) + 0.5) .* bScale;

%# Convert back to type uint8 and reshape to its original size:
rgb2RotImage = reshape(uint8(rgb2RotImage),size(rgbImage));

end % function
