function [ Control_Signal, pid_data ] = PIDC_V2(pid_data)

% Variable to read from motormixer for windup prevention
global motorLimitReached;
%global pid_data;
global dt;



N = 20;
N_tilde = N*pid_data.K;       % Filter variable


% -- Init values -



% -- PID controller --
P = pid_data.K * pid_data.e;

% Integral is only added if saturation is not reached
I = pid_data.integral;
if ~motorLimitReached
    I = pid_data.integral + (pid_data.K/pid_data.Ti)*(pid_data.e*dt);
end

% Derivative calculation
D = ((pid_data.Td*pid_data.K)/ N_tilde)/(dt+(pid_data.Td*pid_data.K/N_tilde))*pid_data.prev_Ud +...
    ((pid_data.Td*pid_data.K) / (dt + (pid_data.Td*pid_data.K)/N_tilde))*(pid_data.e - pid_data.prev_e);



% Make sure the integral does not overflow
I = constrain(I,pid_data.i_max);

pid_data.prev_e = pid_data.e;

Control_Signal = P + I + D;

Control_Signal = constrain(Control_Signal,pid_data.saturation);

pid_data.prev_e = pid_data.e;
pid_data.prev_Ud = D;
pid_data.integral = I;
end

