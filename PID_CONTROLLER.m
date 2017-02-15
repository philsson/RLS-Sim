function [ Control_Signal ] = PID_CONTROLLER(pid_data)


%--pid_data--

%pid_data.e = input pid error
%pid_data.previous_error = = input pid previous error

%pid_data.integral = pid integral buffer 
% pid_data.dt == sample time

%pid_data.Kp
%pid_data.Ki
%pid_data.Kd


derivative = (pid_data.e - pid_data.previous_error)/pid_data.dt;
pid_data.integral = pid_data.integral + (pid_data.e*pid_data.dt);

pid_data.previous_error = pid_data.e;

Control_Signal = pid_data.Kp*pid_data.e + pid_data.Ki*pid_data.integral +  pid_data.Kd*derivative;

end

