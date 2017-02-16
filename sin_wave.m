function [ y ] = sin_wave (steps)
%UNTITLED8 Summary of this function goes here
%   Detailed explanation goes here
persistent x;

if isempty(x)
    x = 0;
end
    
x = x + 2*pi/steps;

if (x > (2 * pi))
    x = 0;
end

y = sin(x);

end

