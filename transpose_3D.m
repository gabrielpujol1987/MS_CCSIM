function [ out ] = transpose_3D( in )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here


out = zeros(size(in,2),size(in,1),size(in,3));
for i = 1:size(in,3)
    a = in(:,:,i);
    a = a';
    out(:,:,i) = a;
end;

end

