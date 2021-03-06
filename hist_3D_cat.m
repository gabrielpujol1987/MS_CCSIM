
% -----------------------------------------------------------------------------
%  This function can be used for histogram matching of 3D categorical TIs

% Reference: Tahmasebi, P., Sahimi, M., Caers, J., 2013. 
% MS-CCSIM: accelerating pattern-based geostatistical simulation of 
% categorical variables using a multi-scale search in Fourier space,
% Computers & Geosciences, 


% Author: Pejman Tahmasebi
% E-mail: pejman@stanford.edu
% Stanford Center for reservoir Forecasting, Stanford University.
% ----------------------------------------------------------------------------*/


function [pos, score] = hist_3D_cat(TI, imout, T, OL, fc, ibest, jbest, kbest, ii, jj, kk)

% clear
% load('C:\Users\Pejman\Desktop\hist.mat')

f = find(isnan(imout)==1);
known = numel(find(~isnan(imout))) + (T(1)-OL(1))*(T(2)-OL(2));
imout(f) = -1;

% Finding TI prop for each facies
prop_TI = zeros(1,fc);
for i = 0:fc-1
    prop_TI(i+1) = (numel(find(TI==i)))/(size(TI,1)*size(TI,2)*size(TI,3));
end; 

% Calculating prop for each candidate pattern and for each facies
prop_new = zeros(size(ibest,1),fc);
for i =1:size(ibest,1)
    
    % Inserting the candidate pattern
    imout(ii:ii+T(1)-1,jj:jj+T(2)-1, kk:kk+T(3)-1) = TI(ibest(i):ibest(i)+T(1)-1, jbest(i):jbest(i)+T(2)-1, kbest(i):kbest(i)+T(3)-1);
    
    % Calculating prop for each facies when new pattern inserted
    for j = 0:fc-1
        prop_new(i,j+1) = numel(find(imout==j))/known;
    end;
end

% Distance of TI prop and new patterns prop
dist = zeros(size(ibest,1),1);
for i = 1:size(ibest,1)
    dist (i,1) = sum(abs(prop_new(i,:)-prop_TI));
end

% Find the closest pattern
[score, pos] = min(dist);
