% read_eas : reads an GEO EAS formatted file into Matlab.
%
% Call [data,header,title]=read_eas(filename);
%
% TMH (tmh@gfy.ku.dk)
%
% Adaptation to 3D images by Gabriel Santiago Pujol Farina
% gabrielpujol87@gmail.com


function dataSQ=read_eas_3D(filename)

	[data, title, header] = read_eas(filename);

	dims = str2num(header);
	
	if(dims(3) == 1)		% if its only a matrix, not a "cube"
		% 2) Construct an MException object to represent the error.
		msgID = 'read_eas_3D:BadInputData';
		msg = 'The file contains a 2D Matrix, not a 3D Matrix.';
		baseException = MException(msgID,msg);

		throw(baseException);
	end
	
	dataSQ = reshape(data, dims(1), dims(2), dims(3));

end


% coming from read_eas_sq
%    dataSQ = transpose(dataSQ);
% 	dataSQ = permute(dataSQ, [3 2 1]);

%dataSQ = flipud(dataSQ);   






function transparence()

% make random image
im = rand(100,100);	% THE MATRIX OR IMAGE!!!
% store handle
hnd = imagesc(im);

% make example alphamask
alphamask = im<1;%0.3;		% THE MASK
% apply mask
set(hnd, 'AlphaData', alphamask);
end