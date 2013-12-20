function imgOut = rgb2Rot(img, theta, yScale, aScale, bScale)
% Matrix multiplication with RGB 0:1 gives YCbCr 0:1 -0.5:0.5 -0.5:0.5
T = transformationMatrixLAB(theta);
%# First convert the RGB image to double precision, scale its values to the
%#   range 0 to 1, reshape it to an N-by-3 matrix, and multiply by A:
uImage = reshape(double(img)./255,[],3) * T';
%# Shift each color plane (stored in each column of the N-by-3 matrix):
imgOut(:,1) =  uImage(:,1) .* yScale ;
imgOut(:,2) = (uImage(:,2) + 0.5) .* aScale;
imgOut(:,3) = (uImage(:,3) + 0.5) .* bScale;

%# Convert back to type uint8 and reshape to its original size:
imgOut = reshape(uint8(imgOut),size(img));

end % function
