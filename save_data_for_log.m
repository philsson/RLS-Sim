
%------------------- Z-axis data ------------------------------------------%

if logs_enabled(3) == true
  
    y_data_z_axis(loop_counter) = states(pd_index.g_yaw); % Sensor data y
    u_data_z_axis(loop_counter) = outputs(pd_index.g_yaw); % kontroll signal u
    r_data_z_axis(loop_counter) = set_points(pd_index.g_yaw);% setpoint eller referens signal r
    
    kp_data_z_axis(loop_counter) = pid_data(pd_index.g_yaw).Kp; % Pid data
    ki_data_z_axis(loop_counter) = pid_data(pd_index.g_yaw).Ki; % Pid data
    kd_data_z_axis(loop_counter) = pid_data(pd_index.g_yaw).Kd; % Pid data

    weights_data_z_axis(:,loop_counter) = rls_data(3).weights; % Weights
    rlsout_data_z_axis(loop_counter) = rls_data(3).RlsOut;   % rls out
    
    fopdt_data_z_axis(1,loop_counter) = FOPDT_Data(3,1); % Fopdt data
    fopdt_data_z_axis(2,loop_counter) = FOPDT_Data(3,2); % Fopdt data
       
end
