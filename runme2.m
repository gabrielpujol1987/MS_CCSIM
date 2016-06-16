%% 2D   S I M U L A T I O N    E X A M P L E

clc
clear all
close all
nS = 5;
ol = 8;

xSize = [100; 256; 400];	% X size of Simulation grid (Ex. 1000x1000)
ySize = [100; 256; 400];	% Y size of Simulation grid (Ex. 1000x1000)
T     = [ 16;  16;  32];	% Template size which should be even
OL    = [  8;   8;   8];	% Overlap size which should be even
nSims = [ nS;  nS;  nS];%[ 20;  20;  20];	% Number of realizations
ms_level = 3;				% Number of MultiScale level (ONLY: 1, 2, 3).

% basePath  = 'C:\Users\gfarina\Desktop\Realizations\mincut ACTIVATED\';
basePath  = 'C:\Users\gfarina\Desktop\Realizations\mincut DEACTIVATED\';
inputPath = 'C:\Users\gfarina\Documents\GitHub\MS_CCSIM\tis\';

mkdir(basePath);

global timeTablePath;
% timeTablePath = [basePath 'TimeTable, mincut ATIVADO.csv'];
timeTablePath = [basePath 'TimeTable, mincut DESATIVADO.csv'];
fileID = fopen(timeTablePath,'w');
fprintf(fileID,'TrainingImage,MultiScale,sizeX,sizeY,T,OL,Time(s)\n');
fclose(fileID);


for i = 1:size(xSize,1)

	output_folder_name = ['experiment ' num2str(xSize(i)) 'x' num2str(ySize(i)) ' T=' num2str(T(i)) ' OL=' num2str(OL(i)) ' MultiScale=' num2str(ms_level)];
	outputPath = [basePath ' ' output_folder_name];

	Experiment(xSize(i), ySize(i), T(i), OL(i), nSims(i), inputPath, outputPath, ms_level);
end
