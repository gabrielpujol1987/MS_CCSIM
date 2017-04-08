% Created by Gabriel Santiago Pujol Farina
% gabrielpujol87@gmail.com

function image = ReadImageOrCSV_Gabriel(filePath)
	isCSV = strcmpi(filePath(end-2:end), 'csv'); % Compare strings ignoring case.
	eend = filePath(end-4:end);
	isSGEMS = strcmpi(eend, 'sgems'); % Compare strings ignoring case.
	
	if(isCSV) % Verify that this file filePath corresponds to a CSV file
		image = csvread(filePath);
		return;
	elseif(isSGEMS)
		
		try									% attempt to read the image as a 3D image.
			image = read_eas_3D(filePath);		% read the TI
			
		catch								% if treating it as 3D raised an error, then treat it as 2D.
			image = read_eas_sq(filePath);		% read the TI
			
		end
		
		
		
		
		return;
		
	else % If this file filePath is an image file, read it. Else, throw error.
		imfinfo(filePath);
		image = im2double(imread(filePath));
	end