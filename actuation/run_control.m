global outputs;
global pd_index;
global U_rescale;
global U_rescale_axis;
global dt;


% Setting set-points

% Follow the green boll
if (follow_target)
    %set_points(pd_index.height) = constrain(quad_target_pos(3),pid_data(pd_index.height).saturation);
    %set_points(pd_index.p_x)    = constrain(quad_target_pos(1),pid_data(pd_index.p_x).saturation);
    %set_points(pd_index.p_y)    = constrain(quad_target_pos(2),pid_data(pd_index.p_y).saturation);
    set_points(pd_index.height) = quad_target_pos(3);
    set_points(pd_index.p_x)    = quad_target_pos(1);
    set_points(pd_index.p_y)    = quad_target_pos(2);
else
    set_points(pd_index.height) = 1;
end

pid_data(pd_index.height).e = set_points(pd_index.height)   -   states(pd_index.height);
pid_data(pd_index.p_x).e    = set_points(pd_index.p_x)      -   states(pd_index.p_x);
pid_data(pd_index.p_y).e    = set_points(pd_index.p_y)      -   states(pd_index.p_y);

% Generating position and height outputs 
if (joy_throttle && (abs(map(RC.throttle,throttle_rate,1)) > 0.05))
    outputs(pd_index.height)    =  RC.throttle;
else
    outputs(pd_index.height)    =  PIDC_V1(pd_index.height);
end
outputs(pd_index.p_x)       =  PIDC_V1(pd_index.p_x);
outputs(pd_index.p_y)       =  PIDC_V1(pd_index.p_y);


set_points(pd_index.v_x) = outputs(pd_index.p_x);
set_points(pd_index.v_y) = outputs(pd_index.p_y);


pid_data(pd_index.v_x).e    = set_points(pd_index.v_x)      -   states(pd_index.v_x);
pid_data(pd_index.v_y).e    = set_points(pd_index.v_y)      -   states(pd_index.v_y);

outputs(pd_index.v_x)       =  PIDC_V1(pd_index.v_x);
outputs(pd_index.v_y)       =  PIDC_V1(pd_index.v_y);


set_points(pd_index.a_roll)     =...
    constrain(...
    outputs(pd_index.v_x)*sin(quad_angles(3)/180*pi) - outputs(pd_index.v_y)*cos(quad_angles(3)/180*pi),...
    pid_data(pd_index.a_roll).saturation);

set_points(pd_index.a_pitch)    =...
    constrain(...
    outputs(pd_index.v_x)*cos(quad_angles(3)/180*pi) + outputs(pd_index.v_y)*sin(quad_angles(3)/180*pi),...
    pid_data(pd_index.a_pitch).saturation);

% Test to set heading to green ball
%set_points(pd_index.compass)    = atan2(quad_target_pos(2)-quad_pos(2),quad_target_pos(1)-quad_pos(1));
if (adjust_heading)
    X = quad_target_pos(1) - states(pd_index.p_x);
    Y = quad_target_pos(2) - states(pd_index.p_y);
    if (nav_heading_threshold^2 < ( X^2 + Y^2) )
        set_points(pd_index.compass)    = atan2(Y,X)/pi*180;    
    else
        set_points(pd_index.compass)    = quad_angles(3); %Previous setpoint?
    end
else
    set_points(pd_index.compass)    = quad_angles(3);
end

   
pid_data(pd_index.a_roll).e     = set_points(pd_index.a_roll)       -   states(pd_index.a_roll);
pid_data(pd_index.a_pitch).e    = set_points(pd_index.a_pitch)      -   states(pd_index.a_pitch);
pid_data(pd_index.compass).e    = set_points(pd_index.compass)      -   states(pd_index.compass);
if (pid_data(pd_index.compass).e < -180)
   pid_data(pd_index.compass).e = 360 - pid_data(pd_index.compass).e;
elseif (pid_data(pd_index.compass).e > 180)
   pid_data(pd_index.compass).e = -360 + pid_data(pd_index.compass).e;
end


%if (abs(quad_angles(3) - set_points(pd_index.compass)) > 20)
%    pid_data(pd_index.a_roll).e = 0;
%    pid_data(pd_index.a_pitch).e = 0;
%end

% Generating control data for acc and 
outputs(pd_index.a_roll)  = PIDC_V1(pd_index.a_roll);
outputs(pd_index.a_pitch) = PIDC_V1(pd_index.a_pitch);
outputs(pd_index.compass) = PIDC_V1(pd_index.compass);

if (use_joystick && joy_gyro && (RC.roll^2 + RC.pitch^2 + RC.yaw^2) > joy_rate*0.01)
% Setpoints for gyro
    set_points(pd_index.g_roll)  = RC.roll;
    set_points(pd_index.g_pitch) = RC.pitch;
    set_points(pd_index.g_yaw)   = RC.yaw;
else
    %set_points(pd_index.g_roll)  = constrain(outputs(pd_index.a_roll),pid_data(pd_index.g_roll).saturation);
    %%set_points(pd_index.g_roll) = set_points(pd_index.g_roll) + sin_wave(20)*30;
    %set_points(pd_index.g_pitch) = constrain(outputs(pd_index.a_pitch),pid_data(pd_index.g_pitch).saturation);
    %set_points(pd_index.g_yaw)   = constrain(outputs(pd_index.compass),pid_data(pd_index.g_yaw).saturation);
    if ~step_enabled(1)
        set_points(pd_index.g_roll)  = outputs(pd_index.a_roll);
    end
    if ~step_enabled(2)
        set_points(pd_index.g_pitch) = outputs(pd_index.a_pitch);
    end
    if ~step_enabled(3)
        set_points(pd_index.g_yaw)   = outputs(pd_index.compass);
    end
end


% Steps (if active)
time_since_last_step = time_since_last_step + 1;
if (time_since_last_step*dt*1000 >= time_fraction*step_interval_ms)
    time_since_last_step = 0; % Reset step time
    
    for i=1:3
        if (logs_enabled(i) && step_enabled(i))
                step_sign = sign(set_points(pd_index.g_yaw - 3 + i));
                if step_sign == 0
                    step_sign = 1;
                end
                step_sign = -step_sign;
                if (rand_steps)

                    set_points(pd_index.g_yaw - 3 + i) = step_sign*rand*step_amplitude;
                    time_fraction = rand;

                else
                    set_points(pd_index.g_yaw - 3 + i) = step_sign*step_amplitude; 
                    time_fraction = 1;
                end
        end
    end
    if (rand_target && follow_target)
        rand_xPos = 2*rand_target_amplitude(1)*rand-rand_target_amplitude(1);
        rand_yPos = 2*rand_target_amplitude(2)*rand-rand_target_amplitude(1);
        rand_zPos = rand_target_amplitude(3)*rand + 1;
        %green ball move command in v-rep
        vrep.simxSetObjectPosition(clientID,quad_target,-1,[rand_xPos rand_yPos rand_zPos],vrep.simx_opmode_oneshot);
    end
end

% Smooth moving target
if (smooth_moving_target && follow_target)
    
    smooth_xPos = 2*rand_target_amplitude(1)*abs(sin(loop_counter/175))^2*abs(cos(loop_counter/450))-rand_target_amplitude(1);
    smooth_yPos = 2*rand_target_amplitude(2)*abs(sin(loop_counter/250))*abs(cos(loop_counter/333))^3-rand_target_amplitude(1);
    smooth_zPos = rand_target_amplitude(3)*abs(cos(loop_counter/1000)) + 1;
    vrep.simxSetObjectPosition(clientID,quad_target,-1,[smooth_xPos smooth_yPos smooth_zPos],vrep.simx_opmode_oneshot);
end

if ~use_PIDC_V2
    pid_data(pd_index.g_roll).e     = set_points(pd_index.g_roll)       -   states(pd_index.g_roll);
    pid_data(pd_index.g_pitch).e    = set_points(pd_index.g_pitch)      -   states(pd_index.g_pitch);
    pid_data(pd_index.g_yaw).e      = set_points(pd_index.g_yaw)        -   states(pd_index.g_yaw);
else
    pid_data_V2(1).e     = set_points(pd_index.g_roll)       -   states(pd_index.g_roll);
    pid_data_V2(2).e     = set_points(pd_index.g_pitch)      -   states(pd_index.g_pitch);
    pid_data_V2(3).e     = set_points(pd_index.g_yaw)        -   states(pd_index.g_yaw);
    
end


% Control for gyro
if ~use_PIDC_V2
    outputs(pd_index.g_roll)  = PIDC_V1(pd_index.g_roll);
    outputs(pd_index.g_pitch) = PIDC_V1(pd_index.g_pitch);
    outputs(pd_index.g_yaw)   = PIDC_V1(pd_index.g_yaw);
else
    [outputs(pd_index.g_roll),  pid_data_V2(1)] = PIDC_V2(pid_data_V2(1));
    [outputs(pd_index.g_pitch), pid_data_V2(2)] = PIDC_V2(pid_data_V2(2));
    [outputs(pd_index.g_yaw),   pid_data_V2(3)] = PIDC_V2(pid_data_V2(3));
end

if impulse_enabled(1) || impulse_enabled(2) || impulse_enabled(3)
    outputs(pd_index.g_roll:pd_index.g_yaw) = [0 0 0];
end
for i = 1:3
    if freq_resp_test(i)
        outputs(pd_index.g_roll -1 +i) = sin_generator(freq_resp_params(1),freq_resp_params(2),loop_counter,dt);
    end
    if impulse_enabled(i) && loop_counter == impulse_enabled_count
        outputs(pd_index.g_roll -1 +i) = impulse_amplitude;
    end
    if U_rescale_axis(i)
        if ~use_PIDC_V2
            %outputs(pd_index.g_roll -1 +i) = outputs(pd_index.g_roll -1 +i)*U_rescale;
            outputs(pd_index.g_roll -1 +i) = U_rescale*outputs(pd_index.g_roll -1 +i);
        else
            outputs(pd_index.g_roll -1 +i) = U_rescale*outputs(pd_index.g_roll -1 +i);
        end
    end
end

 %outputs(pd_index.g_roll:pd_index.g_yaw) = [0 0 0];
 
 
