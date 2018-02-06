function result = BlackAndWhite_Gabriel(imageMatrix)

	result = zeros(size(imageMatrix, 1), size(imageMatrix, 2));
	
	red = imageMatrix(:,:,1);
	green = imageMatrix(:,:,2);
	blue = imageMatrix(:,:,3);

	for i = 1:size(result, 1)
		for j = 1:size(result, 2)
			result(i,j) = Filter_BW(red(i,j), green(i,j), blue(i,j));
		end
	end
	
	
end

function outputt = Filter_BW (red, green, blue)

	tolerance = 0.8;
	if(red > tolerance || green > tolerance || blue > tolerance) 
		outputt = 1;
	else
		outputt = 0;
	end

end