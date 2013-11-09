function channelImage = rgbToMono(img,chan)

[rows, cols, chans] = size(img);
%# Shift each color plane (stored in each column of the N-by-3 matrix):
channelImage = zeros(rows, cols, 3);
channelImage(:,:,mod(chan - 1,3)+1) = img(:,:,chan);

%# Convert back to type uint8 and reshape to its original size:
channelImage = uint8(channelImage);

end % function