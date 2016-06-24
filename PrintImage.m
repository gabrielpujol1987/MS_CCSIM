function PrintImage(Image)
	global index_printed_image;
		
	% Normalizing the values of B, to get the GRAY tones!!!
	maxInMatrix = max(Image(:));
	Image(:,:) = Image(:,:)/maxInMatrix;
	% finished normalizing.

	index_printed_image = index_printed_image+1;
	imwrite(Image, [path 'MATRIX_' int2str(index_printed_image) '.jpg']); % and write it down to the JPG
	
 
