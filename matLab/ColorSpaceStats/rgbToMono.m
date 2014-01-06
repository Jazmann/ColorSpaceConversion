function channelImage = rgbToMono(img,chan)
myType = class(img);
[rows, cols, chans] = size(img);
%# Shift each color plane (stored in each column of the N-by-3 matrix):
channelImage = cast(zeros(rows, cols, 3),myType);
channelImage(:,:,mod(chan - 1,3)+1) = img(:,:,chan);

end % function