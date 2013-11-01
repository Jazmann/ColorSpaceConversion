function skinImage = abcToMetric(rgbImage,point)
%# First convert the RGB image to double precision, scale its values to the
%#   range 0 to 1, reshape it to an N-by-3 matrix, and multiply by A:
thinImage = reshape(double(rgbImage),[],3);
%# Shift each color plane (stored in each column of the N-by-3 matrix):

skinImage(:,1) = sqrt((thinImage(:,2)-point(2)).^2 + (thinImage(:,3)-point(3)).^2 );
skinImage(:,2) = sqrt((thinImage(:,1)-point(1)).^2 + (thinImage(:,3)-point(3)).^2 );
skinImage(:,3) = sqrt((thinImage(:,2)-point(2)).^2 + (thinImage(:,2)-point(2)).^2 );

%# Convert back to type uint8 and reshape to its original size:
skinImage = reshape(uint8(skinImage),size(rgbImage));

end % function