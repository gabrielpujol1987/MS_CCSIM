%% 2D   S I M U L A T I O N    E X A M P L E

clc
clear all
close all



folder_path = 'C:\Users\gfarina\Documents\GitHub\MS_CCSIM\tis\';

results_path = 'C:\Users\gfarina\Desktop\Realizations\';
datee = ['experiment ' regexprep(num2str(fix(clock)),' +','-')];
results_path = [results_path datee '\'];

% Get list of all BMP files in this directory
% DIR returns as a structure array.  You will need to use () and . to get
% the file names.
imagefiles = dir([folder_path '*.sgems']);      
nfiles = length(imagefiles);    % Number of files found

for i_image=1:nfiles
       currentfilename = imagefiles(i_image).name;
    %    currentimage = imread(currentfilename);
    %    images{i_image} = currentimage;


    % Input Parameters
    % % % load ti_2D_1;   %  Two examples are avilable: ti_2D_1 and ti_2D_2

    % ti = read_eas_sq('Bangladesh.sgems');
%     ti = read_eas_sq('tis\ti_strebelle.sgems');
    ti = read_eas_sq([folder_path currentfilename]);

    nx_sim = 400;
    ny_sim = 400;

    % hd = NaN(1000); % Simulation grid (1000x1000)
    hd = NaN(nx_sim, ny_sim); % Simulation grid (1000x1000)

    CT = [2 2];   % Co-Template size in 'i' and 'j' directions
    OL = 4;%16;   % Overlap size which should be even
    T = 32;%100;   % Template size which should be even
    cand = 20;   % Number of candidate pattern which the final pattern is selected from
    fc = 0;   % 0: no need for facies matching. Otherwise, the facies proportion should be provided (e.g. for a 2 facies TI, this matrix should be like [0.28 0.72])
    mrp = 1; % Multiple random path flag (1:on, 0:off). It is strongly suggested to on it option for conditional simulation.
    T_vibration = 1; % Multiple template size flag (1:on, 0:off)
    ms_level = 3; % Number of MS level (1, 2, 3).
    prop = 0.1;   % The proportion of TI which will be scanned to find the matched hard data (0 < prop <=1)). Larger cofficient helps the hard data to honred, but it may cause some discountinuties.
    rad = 1;   % Neighbourhood radius for MS simulation (default or the best radius is [1 1])
    real_numb = 3;   % Number of realizations


    % Main Function
    [C_2D, location_2D] = CCSIM_2D(ti, hd, T, OL, CT, fc, prop, rad, cand, mrp, T_vibration, ms_level, real_numb);
    
    
    % Saving the results
    curr_result_path = [results_path currentfilename '\'];
    mkdir(curr_result_path);
    
    
    for i = 1:real_numb             % for each realization:
        b = reshape(C_2D(:,i), nx_sim, ny_sim);      % do the reshape business.
        csvwrite([curr_result_path 'MATRIX_' int2str(i) '.csv'], b);        % write it down to the CSV      (:,:,i)
        imwrite(b, [curr_result_path 'MATRIX_' int2str(i) '.jpg']);         % and write it down to the JPG
    end

    c = fix(clock);


end



