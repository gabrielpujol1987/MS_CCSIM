% Created by Gabriel Santiago Pujol Farina
% gabrielpujol87@gmail.com

function write_eas_3D(filename,data)%,header)

	fid=fopen(filename,'wt');

	fprintf(fid,'%d ',size(data));
	fprintf(fid,'\n');
		
	fprintf(fid,'1\n');		% don't know, what's this?
		
	fprintf(fid,'v\n');		%'v WAT DA FUK IS DIS?\n');
	
	fprintf(fid, '%d\n', reshape(data,1, numel(data)));
	
	fclose(fid);

return