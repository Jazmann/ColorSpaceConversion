function skinImage = rgbToSkinScaledPixel(g, c, sMin, sMax, dMin, dMax)
sRange = (sMax - sMin);
dRange = (dMax - dMin);
ErfA = erf((g.*(c - sMin))./sRange);
ErfB = erf((g.*(sMax - c))./sRange) + ErfA;
shift = dMin + dRange .* ErfA ./ ErfB;
scale = dRange ./ ErfB;
%# Shift each color plane (stored in each column of the N-by-3 matrix):
points = sMin:sMax;
skinImage(:,1) = shift(1) + scale(1) * erf( g(1) * (points' - c(1)) ./ sRange);
skinImage(:,2) = shift(2) + scale(2) * erf( g(2) * (points' - c(2)) ./ sRange);
skinImage(:,3) = shift(3) + scale(3) * erf( g(3) * (points' - c(3)) ./ sRange);

end % function