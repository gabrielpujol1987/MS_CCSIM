% Created by Gabriel Santiago Pujol Farina
% gabrielpujol87@gmail.com

function theMatrix = csvread3D(filename)

	% Step 1: read the dimensions of the 3D Matrix, and the WallOfText.
	m = csvread(filename);				% get the full WallOfText
	header = m(1,:);					% retrieve the first line
	sizes = header(header~=0);			% trim all zeroes out
	m = m(2:end,:);						% get the remaining WallOfText
	
	% Step 2: Create the big bad 3D Matrix.
	theMatrix = zeros(sizes);
	
	% Step 2: Read from the WallOfText.
	for z = 1:sizes(3)				% for each of the Z X-Y Matrices:
		start = ((z-1)*sizes(1))+1;		% beginning of the current interval
		endd = ((z)*sizes(1));			% end of the current interval
		interval = start:endd;			% defining the current interval
		
		M = m(interval, :);				% get the X-Y Matrix (curr interv)
		theMatrix(:,:,z) = M;			% put into theMatrix (Damathryx?)
	end
end