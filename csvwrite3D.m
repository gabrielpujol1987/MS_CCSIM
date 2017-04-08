% Created by Gabriel Santiago Pujol Farina
% gabrielpujol87@gmail.com

function csvwrite3D(filename, m)

	% Step 1: write the dimensions of the 3D Matrix.
	sizes = size(m);
	csvwrite(filename, sizes);
	
	% Step 2: Save a continous WallOfText.
	for z = 1:sizes(3)				% for each of the Z X-Y Matrices:
		M = m(:,:,z);					% get the X-Y Matrix
		dlmwrite (filename, M, '-append');	% and append it to the CSV.
	end
end