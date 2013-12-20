function skinImage = rgbToSkinSpace(rgbImage, theta, g, c, sMin, sMax, dMin, dMax)
sRange = (sMax - sMin);
dRange = (dMax - dMin);
ErfA = erf((g.*(c - sMin))./sRange);
ErfB = erf((g.*(sMax - c))./sRange) + ErfA;
shift = dMin + dRange .* ErfA ./ ErfB;
scale = dRange ./ ErfB;
%# First convert the RGB image to double precision, scale its values to the
%#   range 0 to 1, reshape it to an N-by-3 matrix, and multiply by A:
skinImage = reshape(double(rgbImage),[],3);
T = transformationMatrixLAB(theta);
skinImage = reshape(double(rgbImage)./sRange,[],3) * T';
%# Shift each color plane (stored in each column of the N-by-3 matrix):
skinImage(:,1) = skinImage(:,1) .* dRange;
skinImage(:,2) = (skinImage(:,2) + 0.5) .* dRange;
skinImage(:,3) = (skinImage(:,3) + 0.5) .* dRange;

%# Shift each color plane (stored in each column of the N-by-3 matrix):
skinImage(:,1) = shift(1) + scale(1) * erf( g(1) * (skinImage(:,1) - c(1)) ./ sRange);
skinImage(:,2) = shift(2) + scale(2) * erf( g(2) * (skinImage(:,2) - c(2)) ./ sRange);
skinImage(:,3) = shift(3) + scale(3) * erf( g(3) * (skinImage(:,3) - c(3)) ./ sRange);

%# Convert back to type uint8 and reshape to its original size:
skinImage = reshape(uint8(skinImage),size(rgbImage));

end % function