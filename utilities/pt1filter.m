function [ state ] = pt1filter( pd_index, input )
%UNTITLED9 Summary of this function goes here
%   Detailed explanation goes here
global filter_index;
global pid_data;

pid_data(pd_index).filter(filter_index.state) =... 
    pid_data(pd_index).filter(filter_index.state) + ...
    pid_data(pd_index).filter(filter_index.dT) / ...
    ( pid_data(pd_index).filter(filter_index.RC) + ...
    pid_data(pd_index).filter(filter_index.dT)) * ...
    (input - pid_data(pd_index).filter(filter_index.state));

state = pid_data(pd_index).filter(filter_index.state);

% y = y + dt/RC + dt*(x - y)
% where RC = 1/(2*pi*f_cut)
% and f_cut = 100
end

