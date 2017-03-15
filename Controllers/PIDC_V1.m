function [ Control_Signal ] = PIDC_V1(pd_index)

% Variable to read from motormixer for windup prevention
global motorLimitReached;
global pid_data;
global dt;

% -- Init values -

if isempty(pid_data(pd_index).Kp)
    
    pid_data(pd_index).Kp = 1;
    pid_data(pd_index).Ki = 0;
    pid_data(pd_index).Kd = 0;
    
    pid_data(pd_index).prev_e = 0;
    pid_data(pd_index).integral = 0;
    pid_data(pd_index).e = 0;   

end

% -- PID controller --
derivative = (pid_data(pd_index).e - pid_data(pd_index).prev_e)/dt;

% Integral is only added if saturation is not reached
if ~motorLimitReached
    pid_data(pd_index).integral = pid_data(pd_index).integral + pid_data(pd_index).Ki*(pid_data(pd_index).e*dt);
end
% Make sure the integral does not overflow
pid_data(pd_index).integral = constrain(pid_data(pd_index).integral,pid_data(pd_index).i_max);

pid_data(pd_index).prev_e = pid_data(pd_index).e;

Control_Signal = ...
    pid_data(pd_index).Kp*pid_data(pd_index).e +...
    pid_data(pd_index).integral +...
    pid_data(pd_index).Kd*pt1filter(pd_index,derivative);

Control_Signal = constrain(Control_Signal,pid_data(pd_index).saturation);
end

