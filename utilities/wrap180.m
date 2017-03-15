function [ value ] = wrap180( value )
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here

for i=1:size(value,2)
    if value(i) > 180
        value(i) = value(i) -360;
    end
    if value(i) < -180
        value(i) = value(i) +360;
    end
end

