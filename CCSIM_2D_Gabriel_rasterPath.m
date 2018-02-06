% -----------------------------------------------------------------------*/
% This function can be used for both 2D unconditional and conditional
% MS-CCSIM. For using in unconditional mode, the hd should be just NaN
% value.

% Reference: Tahmasebi, P., Sahimi, M., Caers, J., 2013. 
% MS-CCSIM: accelerating pattern-based geostatistical simulation of 
% categorical variables using a multi-scale search in Fourier space
% functions, Computers & Geosciences, 


% Author: Pejman Tahmasebi
% E-mail: pejman@stanford.edu
% Stanford Center for reservoir Forecasting, Stanford University.
% -----------------------------------------------------------------------*/
% 
function [ C, error_location ] = CCSIM_2D_Gabriel_rasterPath(ti, hd, T, OL, CT, fc, prop, rad, cand, mrp, T_vibration, ms_level, real_numb)
global timeTablePath prefix_timeTable;

%% Input Parameters
% - ti: Training image
% - hd: Hard data matrix
% - T: Template size
% - OL: Overlap size
% - CT: Size of Co-Template (e.g. [2 2])
% - fc: Number of facies (if fc = 0, histogram matching will not apply; default is 0)
% - prop: The proportion of TI which will be scanned to find the matched hard data (0 < prop <=1))
% - rad: Neighbourhood radius for MS simulation (default is [1 1])
% - cand: Number of candidates for pattern pool
% - mrp: Multiple random path flag (1:on, 0:off).
% - T_vibration : Multiple template size flag (1:on, 0:off).
% - ms_level: Number of MS level (1, 2, 3).
% - real_numb: Number of the realizations

%% Output Parameters
% - C: Simulation grid for output
% - error_location: The locations where the HD is macthed (all zero means
% no mismatch)

%%

% 'lag' is the 'step' used when there are multiple paths... to index which
% kind of path is in use. By default (one path) it should be 1, to address
% that all realizations are done 
HD1_1 = hd; ti1_1 = ti; lag = 1;        

if ms_level >=1 
end;


C = zeros(numel(hd),1);

if ms_level >=2
    HD1_2 = hd_resize_2D(HD1_1, size(HD1_1)/2); ti1_2 = ti_resize_2D(ti1_1, size(ti1_1)/2);
end
    
if ms_level >=3
    HD1_3 = hd_resize_2D(HD1_1, size(HD1_1)/4); ti1_3 = ti_resize_2D(ti1_1, size(ti1_1)/4);
end;


    % Initializing the random paths: 
        % R1 is the 'normal' one, 
        % the others are crazy

R1 = 1:lag:real_numb;

if (real_numb > 1) && (T_vibration == 1)
    T_new = ones(real_numb,1);
    T_new(1:ceil(real_numb/3),1) = T;
    T_new(1+ceil(real_numb/3):2*ceil(real_numb/3),1) = T + 4;
    T_new(1+2*ceil(real_numb/3):end,1) = T - 4;
    T_new(:,2) = rand(size(T_new,1),1);
    T_new = sortrows(T_new,2);
    T_new = T_new(:,1);
else
    T_new = repmat(T,[real_numb 1]);
end;

error_location = zeros(numel(find(~isnan(hd))),real_numb);






for i = 1:real_numb     % FOR EACH REALIZATION...
    
    if any(R1==i)
        hd0 = HD1_1; ti0 = ti1_1;
        if ms_level >=2
            hd1 = HD1_2; ti1 = ti1_2;
        end;
        if ms_level >=3
            hd2 = HD1_3; ti2 = ti1_3;
        end;
    end;



    % The real simulation part, once the previous shenanigans ended.

    tStart = tic;
    if ms_level ==1
        [MS0, ~] = CCSIM_2D_MS2_Gabriel(ti0, hd0, T_new(i), OL, CT, fc, prop, cand);
    elseif ms_level==2
        [~, LOC1] = CCSIM_2D_MS2_Gabriel(ti1, hd1, T_new(i)/2, OL/2, CT, fc, prop, cand);
        [MS0, ~] = CCSIM_2D_MS1_Gabriel(ti0, hd0, LOC1, T_new(i), OL, rad);
    else
        [~, LOC2] = CCSIM_2D_MS2_Gabriel(ti2, hd2, T_new(i)/4, OL/4, CT, fc, prop, cand);
        [~, LOC1] = CCSIM_2D_MS1_Gabriel(ti1, hd1, LOC2, T_new(i)/2, OL/2, rad);
        [MS0, ~]  = CCSIM_2D_MS1_Gabriel(ti0, hd0, LOC1, T_new(i), OL, rad);
    end;
    
    tEnd = toc(tStart);
        MS0 = MS0(1:size(hd,1),1:size(hd,2));
    

    C(:,i) = MS0(:);

    hd_all = numel(find(~isnan(hd0)));
    
    if hd_all ~=0
        [error, error_location(:,real_numb)] = hd_error(hd,MS0);
        mis_hd = 100*(error/hd_all);
        disp(['** Mismatch HD: ',num2str(mis_hd),'% ***'])
    end;

    
    disp(['********  CPU time for the grid size of ',num2str(size(hd,1)),'x',...
        num2str(size(hd,2)), ' is ', num2str(tEnd),...
        '  (s) ********'])
	
	
	if ~isempty(timeTablePath)
		fileID = fopen(timeTablePath,'a');
		fprintf(fileID,[num2str(tEnd) '\n']);
		fclose(fileID);
	end
	
end;

end
