function [ pid_data_V2 ] = PID_ScaleOnGain( pid_data_V1_orig, pid_data_V2, system_gain, my)
% Scales K, Ti and Td dependent on the system gain
% takes in old PID data from old version of the controller and remaps it

% Kd, Ti and Td are translated from the manual tuning


           % gain scaling factor

manual_tune = K2T_Values(pid_data_V1_orig.Kp, pid_data_V1_orig.Ki, pid_data_V1_orig.Kd)



pid_data_V2.K = my / system_gain;

pid_data_V2.Ti = manual_tune(2);

pid_data_V2.Td = manual_tune(3);


end

