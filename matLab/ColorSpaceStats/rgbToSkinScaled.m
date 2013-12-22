function skinImage = rgbToSkinScaled(rgbImage, g, c, sMin, sMax, dMin, dMax)
sRange = (sMax - sMin);
dRange = (dMax - dMin);
ErfA = erf((g.*(c - sMin))./sRange);
ErfB = erf((g.*(sMax - c))./sRange);
ErfAB = ErfB + ErfA;
shift = dMin + dRange .* ErfA ./ ErfAB;
scale = dRange ./ ErfAB;
sUnitGrad = [floor(c - (sRange .* sqrt(log((2*dRange .* g)./(ErfAB.*sqrt(pi) .* sRange))))./g); ceil(c + (sRange .* sqrt(log((2*dRange .* g)./(ErfAB .* sqrt(pi) .* sRange))))./g)];
sLowHigh = [c + (sRange .* erfinv((1 + dMin - shift)./scale))./g; c + (sRange .* erfinv((-1 + dMax - shift)./scale))./g];

dUnitGrad(1,1) = shift(1) + scale(1) * erf( g(1) * (sUnitGrad(1,1) - c(1)) ./ sRange);
dUnitGrad(1,2) = shift(2) + scale(2) * erf( g(2) * (sUnitGrad(1,2) - c(2)) ./ sRange);
dUnitGrad(1,3) = shift(3) + scale(3) * erf( g(3) * (sUnitGrad(1,3) - c(3)) ./ sRange);
dUnitGrad(2,1) = shift(1) + scale(1) * erf( g(1) * (sUnitGrad(2,1) - c(1)) ./ sRange);
dUnitGrad(2,2) = shift(2) + scale(2) * erf( g(2) * (sUnitGrad(2,2) - c(2)) ./ sRange);
dUnitGrad(2,3) = shift(3) + scale(3) * erf( g(3) * (sUnitGrad(2,3) - c(3)) ./ sRange);

linearConstant= dUnitGrad(1,:) - sUnitGrad(1,:);

linear[x_] := x + dUnitGrad[[1]] - sUnitGrad[[1]];

shiftednErfConstant = sUnitGrad(2,:) + dUnitGrad(1,:) - sUnitGrad(1,:) - dUnitGrad(2,:);

N[{nErf[sUnitGrad[[1]]], nErf[sUnitGrad[[2]]]}];
%# First convert the RGB image to double precision, scale its values to the
%#   range 0 to 1, reshape it to an N-by-3 matrix, and multiply by A:
skinImage = reshape(double(rgbImage),[],3);
%# Shift each color plane (stored in each column of the N-by-3 matrix):
skinImage(:,1) = shift(1) + scale(1) * erf( g(1) * (skinImage(:,1) - c(1)) ./ sRange);
skinImage(:,2) = shift(2) + scale(2) * erf( g(2) * (skinImage(:,2) - c(2)) ./ sRange);
skinImage(:,3) = shift(3) + scale(3) * erf( g(3) * (skinImage(:,3) - c(3)) ./ sRange);

%# Convert back to type uint8 and reshape to its original size:
skinImage = reshape(uint8(skinImage),size(rgbImage));

end % function