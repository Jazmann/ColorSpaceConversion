
% Kb = 0.114;  Kr = 0.299; yScale = 219; bScale = 224; rScale = 224;bMin=0;rMin=0;theta = 0.7854;
function skinImage = rgbToMetric(rgbImage, M, c, sMin, sMax, dMin, dMax)
sRange = sMax-sMin;
dRange = dMax-dMin;
distMax = abs(sRange/2. - c) + sRange/2.;
sDistMax = sqrt(M * (distMax' .* distMax'));
scale = dRange'.*(1./sDistMax);
%# First convert the RGB image to double precision, scale its values to the
%#   range 0 to 1, reshape it to an N-by-3 matrix, and multiply by A:
skinImage = reshape(double(rgbImage),[],3);
%# Shift each color plane (stored in each column of the N-by-3 matrix):
skinImage(:,1) = skinImage(:,1) - c(1);
skinImage(:,2) = skinImage(:,2) - c(2);
skinImage(:,3) = skinImage(:,3) - c(3);
skinImage = sqrt(M * (skinImage' .* skinImage'))';
skinImage(:,1) = skinImage(:,1) .* scale(1);
skinImage(:,2) = skinImage(:,2) .* scale(2);
skinImage(:,3) = skinImage(:,3) .* scale(3);

%# Convert back to type uint8 and reshape to its original size:
skinImage = reshape(uint8(skinImage),size(rgbImage));

end % function