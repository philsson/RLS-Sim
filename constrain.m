function [ value ] = constrain( value, saturation )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here


if (abs(value) > saturation)
    value = saturation * sign(value);

end

