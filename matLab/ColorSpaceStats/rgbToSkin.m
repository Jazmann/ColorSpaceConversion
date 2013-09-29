
% Kb = 0.114;  Kr = 0.299; yScale = 219; bScale = 224; rScale = 224;bMin=0;rMin=0;theta = 0.7854;
function skinImage = rgbToSkin(rgbImage, yScale, bScale, rScale)
T = [76,-128,41;127,36,-128;29,92,90];

%# First convert the RGB image to double precision, scale its values to the
%#   range 0 to 1, reshape it to an N-by-3 matrix, and multiply by A:
skinImage = reshape(double(rgbImage)./255,[],3) * T;
%# Shift each color plane (stored in each column of the N-by-3 matrix):
skinImage(:,1) = skinImage(:,1);
skinImage(:,2) = skinImage(:,2) + 0.5 .* bScale;
skinImage(:,3) = skinImage(:,3) + 0.5 .* rScale;

%# Convert back to type uint8 and reshape to its original size:
skinImage = reshape(uint8(skinImage),size(rgbImage));

end % function