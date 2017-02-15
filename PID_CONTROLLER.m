function [ Control_Signal ] = PID_CONTROLLER(pid_data)


%--pid_data. --

%previous_error = = input pid previous error
%integral = pid integral buffer 
%e = input pid error
%dt == sample time
%Kp
%Ki
%Kd

% -- Init values -

if isempty(pid_data.Kp)
    
    pid_data.Kp = 1;
    pid_data.Ki = 0;
    pid_data.Kd = 0;
    
    pid_data.previous_error = 0;
    pid_data.integral = 0;
    pid_data.dt = 1;
    pid_data.e = 0;   

end

% -- PID controller --

derivative = (pid_data.e - pid_data.previous_error)/pid_data.dt;
pid_data.integral = pid_data.integral + (pid_data.e*pid_data.dt);

pid_data.previous_error = pid_data.e;

Control_Signal = pid_data.Kp*pid_data.e + pid_data.Ki*pid_data.integral +  pid_data.Kd*derivative;

end

