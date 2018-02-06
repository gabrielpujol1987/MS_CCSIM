%% 2D   S I M U L A T I O N    E X A M P L E
% clc
clear all
close all
global timeTablePath;

xSize =    [256 256 400 400];	% X size of Simulation grid (Ex. 1000x1000)
ySize =    [256 256 400 400];	% Y size of Simulation grid (Ex. 1000x1000)
TT    =    [16  16  16  16];	% Template size which should be even
OOLL  =    [4   4   4   4];	% Overlap size which should be even
nSims =    50;			 		% Number of realizations
ms_level = [1   3   1   3];				% Number of MultiScale level (ONLY: 1, 2, 3).


inputPath = 'C:\Users\gfarina\Documents\GitHub\MS_CCSIM\tis\';

resultsFolderPath = ['Experiment 2017-04-10 MINCUT MS=1and3 nSims=' num2str(nSims) 'x Strebelle\'];
basePath  = ['C:\Users\gfarina\Desktop\Realizations\' resultsFolderPath];
if ~(exist(basePath, 'dir') == 7)
	mkdir(basePath);
end


%% %%%%%%%%%


trainingImageFiles = dir([inputPath '*.sgems']);	
nfiles = length(trainingImageFiles);	% Number of files found
nfiles = 1;                                                                 %waaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa

for i_trainingImage = 1:nfiles
% 	currentTrainingImageFileName = trainingImageFiles(i_trainingImage).name;
	currentTrainingImageFileName = 'ti_strebelle.sgems';
%     currentTrainingImageFileName = 'Bangladesh.sgems';
	ti = read_eas_sq([inputPath currentTrainingImageFileName]);		% read the TI
    
	
	baseTIPath = [basePath currentTrainingImageFileName '\'];
	if ~(exist(baseTIPath, 'dir') == 7)
		mkdir(baseTIPath);
	end

	for i = 1:size(xSize,2)

		hd = NaN(xSize(i), ySize(i));	% Simulation grid (1000x1000)
		CT = [2 2];				% Co-Template size in 'i' and 'j' directions
		T = TT(i);				% Template size which should be even
		OL = OOLL(i);			% Overlap size which should be even
		cand = 10;				% Number of candidate pattern which the final pattern is selected from
		fc = 0;					% 0: no need for facies matching. Otherwise, the facies proportion should be provided (e.g. for a 2 facies TI, this matrix should be like [0.28 0.72])
		mrp = 1;				% Multiple random path flag (1:on, 0:off). It is strongly suggested to on it option for conditional simulation.
		T_vibration = 1;		% Multiple template size flag (1:on, 0:off)
% 		ms_level = 3;			% Number of MS level (1, 2, 3).
		prop = 0.1;				% The proportion of TI which will be scanned to find the matched hard data (0 < prop <=1)). Larger cofficient helps the hard data to honred, but it may cause some discountinuties.
		rad = 1;				% Neighbourhood radius for MS simulation (default or the best radius is [1 1])
		real_numb = nSims;		% Number of realizations

		
		experiment_folder_name = ['MS-CCSIM ' num2str(xSize(i)) 'x' num2str(ySize(i)) ' T=' num2str(TT(i)) ' OL=' num2str(OOLL(i)) ' MS=' num2str(ms_level(i))];
		experimentPath = [baseTIPath experiment_folder_name '\'];
		if ~(exist(experimentPath, 'dir') == 7)
			mkdir(experimentPath);
		end
		
		
		timeTablePath = [experimentPath 'TimeTable.csv'];
		fileID = fopen(timeTablePath,'w');
		fprintf(fileID,'Time for every realization, in seconds:\n');
		fclose(fileID);
		
		% Main Function
		[C_2D, ~] = CCSIM_2D(ti, hd, T, OL, CT, fc, prop, rad, cand, mrp, T_vibration, ms_level(i), real_numb);	% location_2D
		
		% Creating the output directory for this iteration (this TI)
		% curr_result_path = [experimentPath currentTrainingImageFileName '\'];
		% mkdir(curr_result_path);
		
		% Saving the results
		for j = 1:real_numb			% for each realization:
			filename = [experimentPath 'Image_' int2str(j)];
		
			b = reshape(C_2D(:,j), xSize(i), ySize(i));	% do the reshape business.
			% UNNORMALIZED!!!
			csvwrite([filename '.csv'], b);		% write it down to the CSV	(:,:,i)
			
			% Normalizing the values of B, to get the GRAY tones!!!
			maxInMatrix = max(b(:));
			b(:,:) = b(:,:)/maxInMatrix;
			% finished normalizing.
						
			imwrite(b, [filename '.jpg']);		% and write it down to the JPG
		end
	end
end