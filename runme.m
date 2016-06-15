% -----------------------------------------------------------------------------
% This script can be used for running MS-CCSIM for both 2D and 3D
% simulations.


% Reference: Tahmasebi, P., Sahimi, M., Caers, J., 2013. 
% MS-CCSIM: accelerating pattern-based geostatistical simulation of 
% categorical variables using a multi-scale search in Fourier space
% functions, Computers & Geosciences, 


% Author: Pejman Tahmasebi
% E-mail: pejman@stanford.edu
% Stanford Center for reservoir Forecasting, Stanford University.
% -----------------------------------------------------------------------*/


%% 2D   S I M U L A T I O N    E X A M P L E

clc
clear all
close all


% Input Parameters
% % % load ti_2D_1;   %  Two examples are avilable: ti_2D_1 and ti_2D_2

% ti = read_eas_sq('Bangladesh.sgems');
ti = read_eas_sq('tis\ti_strebelle.sgems');

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
real_numb = 10;   % Number of realizations


% Main Function
[C_2D, location_2D] = CCSIM_2D(ti, hd, T, OL, CT, fc, prop, rad, cand, mrp, T_vibration, ms_level, real_numb);

path = 'C:\Users\gfarina\Desktop\Realizations\';
for i = 1:real_numb             % for each realization:
    b = reshape(C_2D(:,i), nx_sim, ny_sim);      % do the reshape business.
    csvwrite([path 'MATRIX_' int2str(i) '.csv'], b);        % write it down to the CSV      (:,:,i)
    imwrite(b, [path 'MATRIX_' int2str(i) '.jpg']);         % and write it down to the JPG
end






%% NEXT TASK!!!
%  Locate in the original code the line(s) where the CONVOLUTION	 search is done, 
%  to find the best match for a PATTERN in the TRAINING IMAGE. 
%  
%  From there on, get the VALUE of the INNER PRODUCT for the found coordinates.
%  
%  Look for functions like:
%  		TemplateMatching(...)
%  		convfft(...)





%% 3D   S I M U L A T I O N    E X A M P L E

% clc
% clear all
% close all
% 
% % Input Parameters
% 
% load ti_3D_2f;   %  Two examples are avilable: ti_3D_3f and ti_3D_2f
% hd = NaN(180,140,30); % Simulation grid (180x140x30)
% CT = [2 2 2];   % Co-Template size in 'i' and 'j' directions
% OL = [12 12 4];   % Overlap size which should be even
% T = [32 32 10];   % Template size which should be even
% cand = 3;   % Number of candidate pattern which the final pattern is selected from
% fc = 0;   % 0: no need for facies matching. Otherwise, the facies proportion should be provided (e.g. for a 2 facies TI, this matrix should be like [0.28 0.72])
% mrp = 1; % Multiple random path flag (1:on, 0:off). It is strongly suggested to on it option for conditional simulation.
% T_vibration = 0; % Multiple template size flag (1:on, 0:off)
% ms_level = 3; % Number of MS level (1, 2, 3).
% prop = 0.01;   % The proportion of TI which will be scanned to find the matched hard data (0 < prop <=1)). Larger cofficient helps the hard data to honred, but it may cause some discountinuties.
% rad = 1;   % Neighbourhood radius for MS simulation (default or the best radius is [1 1])
% real_numb = 1;   % Number of realizations
% 
% 
% % Main Function
% 
% [C_3D, location_3D] = CCSIM_3D(ti, hd, T, OL, CT, fc, prop, rad, cand, mrp, T_vibration, ms_level, real_numb);




