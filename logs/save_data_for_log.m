
%------------------- Z-axis data ------------------------------------------%

if logs_enabled(3) == true && loop_counter ~= 0
  
    y_data_z_axis(loop_counter) = states(pd_index.g_yaw); % Sensor data y
    u_data_z_axis(loop_counter) = outputs(pd_index.g_yaw); % kontroll signal u
    r_data_z_axis(loop_counter) = set_points(pd_index.g_yaw);% setpoint eller referens signal r
    
    if use_PIDC_V2
        kp_data_z_axis(loop_counter) = pid_data_V2(3).K;
        ki_data_z_axis(loop_counter) = pid_data_V2(3).Ti;
        kd_data_z_axis(loop_counter) = pid_data_V2(3).Td;
        
    else
        kp_data_z_axis(loop_counter) = pid_data(pd_index.g_yaw).Kp; % Pid data
        ki_data_z_axis(loop_counter) = pid_data(pd_index.g_yaw).Ki; % Pid data
        kd_data_z_axis(loop_counter) = pid_data(pd_index.g_yaw).Kd; % Pid data
    end
        
    if  (use_rls_data_simple == true || use_PIDC_V2)
        
        weights_data_z_axis(1,loop_counter) = 0; % Weights
        weights_data_z_axis(2,loop_counter) = rls_data_simple(3).weights; % Weights
        rlsout_data_z_axis(loop_counter) = rls_data_simple(3).RlsOut;   % rls out 
        
    else
        
        weights_data_z_axis(:,loop_counter) = rls_data(3).weights; % Weights
        rlsout_data_z_axis(loop_counter) = rls_data(3).RlsOut;   % rls out  
    
    end
    
    fopdt_data_z_axis(1,loop_counter) = FOPDT_Data(3,1); % Fopdt data
    fopdt_data_z_axis(2,loop_counter) = FOPDT_Data(3,2); % Fopdt data
       
end
