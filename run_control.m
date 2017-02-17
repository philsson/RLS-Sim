
% Setting set-points

% Follow the green boll
set_points(pd_index.height) = constrain(quad_target_pos(3),pid_data(pd_index.height).saturation);
set_points(pd_index.p_x)    = constrain(quad_target_pos(1),pid_data(pd_index.p_x).saturation);
set_points(pd_index.p_y)    = constrain(quad_target_pos(2),pid_data(pd_index.p_y).saturation);

pid_data(pd_index.height).e = set_points(pd_index.height)   -   states(pd_index.height);
pid_data(pd_index.p_x).e    = set_points(pd_index.p_x)      -   states(pd_index.p_x);
pid_data(pd_index.p_y).e    = set_points(pd_index.p_y)      -   states(pd_index.p_y);

% Generating position and height outputs 
outputs(pd_index.height)    =  PID_CONTROLLER(pd_index.height);
outputs(pd_index.p_x)       =  PID_CONTROLLER(pd_index.p_x);
outputs(pd_index.p_y)       =  PID_CONTROLLER(pd_index.p_y);

% 
% TODO: rotation matrix on yaw
set_points(pd_index.a_roll)     =...
    constrain(...
    outputs(pd_index.p_x)*sin(quad_angles(3)/180*pi) - outputs(pd_index.p_y)*cos(quad_angles(3)/180*pi),...
    pid_data(pd_index.a_roll).saturation);

set_points(pd_index.a_pitch)    =...
    constrain(...
    outputs(pd_index.p_x)*cos(quad_angles(3)/180*pi) + outputs(pd_index.p_y)*sin(quad_angles(3)/180*pi),...
    pid_data(pd_index.a_pitch).saturation);

set_points(pd_index.compass)    = 0; %Freaks out on 90. Why!?!?!?

pid_data(pd_index.a_roll).e     = set_points(pd_index.a_roll)       -   states(pd_index.a_roll);
pid_data(pd_index.a_pitch).e    = set_points(pd_index.a_pitch)      -   states(pd_index.a_pitch);
pid_data(pd_index.compass).e    = set_points(pd_index.compass)      -   states(pd_index.compass);

% Generating control data for acc and 
outputs(pd_index.a_roll)  = PID_CONTROLLER(pd_index.a_roll);
outputs(pd_index.a_pitch) = PID_CONTROLLER(pd_index.a_pitch);
outputs(pd_index.compass) = PID_CONTROLLER(pd_index.compass);

% Setpoints for gyro
set_points(pd_index.g_roll)  = constrain(outputs(pd_index.a_roll),pid_data(pd_index.g_roll).saturation);
%set_points(pd_index.g_roll) = set_points(pd_index.g_roll) + sin_wave(20)*30;
set_points(pd_index.g_pitch) = constrain(outputs(pd_index.a_pitch),pid_data(pd_index.g_pitch).saturation);
set_points(pd_index.g_yaw)   = constrain(outputs(pd_index.compass),pid_data(pd_index.g_yaw).saturation);

pid_data(pd_index.g_roll).e     = set_points(pd_index.g_roll)       -   states(pd_index.g_roll);
pid_data(pd_index.g_pitch).e    = set_points(pd_index.g_pitch)      -   states(pd_index.g_pitch);
pid_data(pd_index.g_yaw).e      = set_points(pd_index.g_yaw)        -   states(pd_index.g_yaw);

% Control for gyro
outputs(pd_index.g_roll)  = PID_CONTROLLER(pd_index.g_roll);
outputs(pd_index.g_pitch) = PID_CONTROLLER(pd_index.g_pitch);
outputs(pd_index.g_yaw)   = PID_CONTROLLER(pd_index.g_yaw);


% Retrieve amount of control loops
%control_loops = fieldnames(pd_index);
% Loop through all control loops. ex 1..7
%for i = 1:numel(control_loops)  
    % Calculating errors
%    pid_data(i).e = set_points(i) - states(i);
    
    % Running control loops
%    outputs(i) = PID_CONTROLLER(i);
%end    
    


