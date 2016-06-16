%% 2D S I M U L A T I O N	E X A M P L E
function Experiment(xSize, ySize, T, OL, nSims, inputPath, outputPath, ms_level)
global timeTablePath prefix_timeTable;

% Get list of all SGEMS files in this directory
% DIR returns as a structure array. 
% You will need to use () and . to get the file names.
trainingImageFiles = dir([inputPath '*.sgems']);	
nfiles = length(trainingImageFiles);	% Number of files found


% nfiles = 1;
for i_trainingImage = 1:nfiles

	currentTrainingImageFileName = trainingImageFiles(i_trainingImage).name;
	ti = read_eas_sq([inputPath currentTrainingImageFileName]);		% read the TI

	hd = NaN(xSize, ySize); % Simulation grid (1000x1000)

	CT = [2 2];			% Co-Template size in 'i' and 'j' directions
% 	T = 32;%100;		% Template size which should be even
%	OL = 4;%16;			% Overlap size which should be even
	cand = 20;			% Number of candidate pattern which the final pattern is selected from
	fc = 0;				% 0: no need for facies matching. Otherwise, the facies proportion should be provided (e.g. for a 2 facies TI, this matrix should be like [0.28 0.72])
	mrp = 1;			% Multiple random path flag (1:on, 0:off). It is strongly suggested to on it option for conditional simulation.
	T_vibration = 1;	% Multiple template size flag (1:on, 0:off)
% 	ms_level = 3;		% Number of MS level (1, 2, 3).
	prop = 0.1;			% The proportion of TI which will be scanned to find the matched hard data (0 < prop <=1)). Larger cofficient helps the hard data to honred, but it may cause some discountinuties.
	rad = 1;			% Neighbourhood radius for MS simulation (default or the best radius is [1 1])
	real_numb = nSims;	% Number of realizations


	prefix_timeTable = [currentTrainingImageFileName ',' num2str(ms_level) ',' num2str(xSize) ',' num2str(ySize) ',' num2str(T) ',' num2str(OL) ','];
% 	fileID = fopen(timeTablePath,'a');
	%fprintf(fileID,'nSim,MultiScale,sizeX,sizeY,T,OL,Time(s)\n');
% 	fprintf(fileID, prefix_timeTable);
% 	fclose(fileID);
	
	
	% Main Function
	[C_2D, location_2D] = CCSIM_2D(ti, hd, T, OL, CT, fc, prop, rad, cand, mrp, T_vibration, ms_level, real_numb);
	
	
	% Creating the output directory for this iteration (this TI)
	curr_result_path = [outputPath currentTrainingImageFileName '\'];
	mkdir(curr_result_path);
	
	% Saving the results
	for i = 1:real_numb			% for each realization:
		b = reshape(C_2D(:,i), xSize, ySize);	% do the reshape business.
		csvwrite([curr_result_path 'MATRIX_' int2str(i) '.csv'], b);		% write it down to the CSV	(:,:,i)
		imwrite(b, [curr_result_path 'MATRIX_' int2str(i) '.jpg']);		% and write it down to the JPG
	end

	c = fix(clock);


end



