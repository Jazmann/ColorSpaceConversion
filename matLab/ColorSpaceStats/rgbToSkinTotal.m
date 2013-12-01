function outImage = rgbToSkinTotal(rgbImage, theta, sigma, c, sig, cubeSkin, sMin, sMax, dMin, dMax, cInRGB)

[rows, cols, chans] = size(rgbImage);
sRange = (sMax - sMin);
dRange = (dMax - dMin);

g = [ 1./(sqrt(2) .* sig(1) .* sigma(1)), 1./(sqrt(2) .* sig(2) .* sigma(2)), 1./(sqrt(2) .* sig(3) .* sigma(3))];
ErfA = erf((g.*(c - sMin)));
ErfB = erf((g.*(sMax - c))) + ErfA;
shift = dMin + dRange .* ErfA ./ ErfB;
scale = dRange ./ ErfB;
%# First convert the RGB image to double precision, scale its values to the
%#   range 0 to 1, reshape it to an N-by-3 matrix, and multiply by T:
uT = transformationMatrixLAB(theta);

if cInRGB
    uC = (c ./ sRange) * uT';
else
    uC = c ./ dRange;
end

uRGBImage = reshape(double(rgbImage)./sRange,[],3);
uSkinImage = uRGBImage * uT';
%# Shift each color plane (stored in each column of the N-by-3 matrix):
uSkinImage(:,1) = uSkinImage(:,1) ;
uSkinImage(:,2) = (uSkinImage(:,2) + 0.5);
uSkinImage(:,3) = (uSkinImage(:,3) + 0.5);
%# Shift each color plane (stored in each column of the N-by-3 matrix):
skinImage(:,1) = shift(1) + scale(1) * erf( g(1) * (uSkinImage(:,1) - uC(1)).* dRange );
skinImage(:,2) = shift(2) + scale(2) * erf( g(2) * (uSkinImage(:,2) - uC(2)).* dRange );
skinImage(:,3) = shift(3) + scale(3) * erf( g(3) * (uSkinImage(:,3) - uC(3)).* dRange );

uSkinProb = zeros(rows * cols, 2);
uSkinProb(:,1) = uRGBImage(:,1)<(255-cubeSkin)/255 & uRGBImage(:,2)<(255-cubeSkin)/255 & uRGBImage(:,3)<(255-cubeSkin)/255 & uRGBImage(:,1)>(cubeSkin)/255 & uRGBImage(:,2)>(cubeSkin)/255 & uRGBImage(:,3)>(cubeSkin)/255;
uSkinProb(:,2) = 1. ./ ( exp((uSkinImage(:,2) - uC(2)).^2 ./ ( 2. * (sig(2) * sigma(2)/sRange)^2)) .* exp((uSkinImage(:,3) - uC(3)).^2 ./ ( 2. * (sig(3) * sigma(3)/sRange)^2)));


%# Convert back to type uint8 and reshape to its original size:
outImage = reshape(horzcat(uint8(uRGBImage.* dRange),uint8(skinImage),uint8(uSkinProb.* dRange)),[rows, cols, chans+5]);

end % function


     