function channelImage = rgbToMono(rgbImage,chan)
%# First convert the RGB image to double precision, scale its values to the
%#   range 0 to 1, reshape it to an N-by-3 matrix, and multiply by A:
thinImage = reshape(double(rgbImage),[],3);
%# Shift each color plane (stored in each column of the N-by-3 matrix):
channelImage = zeros(size(thinImage));
channelImage(:,chan) = thinImage(:,chan);

%# Convert back to type uint8 and reshape to its original size:
channelImage = reshape(uint8(channelImage),size(rgbImage));

end % function