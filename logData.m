global stop_sim;

%global loop_counter;

%global ISE_samples


%global logs_enabled;
% Enable log for: X(roll)   Y(pitch)    Z(yaw)
%log_enabled =  [  true      false       false];

if (calcISE && loop_counter <= ISE_samples && loop_counter ~= 0 && ~stop_sim)
    if logs_enabled(1)
        xLOG(1:3,loop_counter) = [set_points(pd_index.g_roll) states(pd_index.g_roll) pid_data(pd_index.g_roll).e];
        MISEx = MISE(set_points(pd_index.g_roll),states(pd_index.g_roll),MISEx,loop_counter);
    end
    if logs_enabled(2)
        yLOG(1:3,loop_counter) = [set_points(pd_index.g_pitch) states(pd_index.g_pitch) pid_data(pd_index.g_pitch).e];
        MISEy = MISE(set_points(pd_index.g_pitch),states(pd_index.g_pitch),MISEy,loop_counter);
    end
    if logs_enabled(3)
        zLOG(1:3,loop_counter) = [set_points(pd_index.g_yaw) states(pd_index.g_yaw) pid_data(pd_index.g_yaw).e];
        MISEz = MISE(set_points(pd_index.g_yaw),states(pd_index.g_yaw),MISEz,loop_counter);
    end
elseif ((calcISE && loop_counter > ISE_samples) || stop_sim)
    stop_sim = true;
    if logs_enabled(1)
        figure;
        plot(xLOG(1:2,1:loop_counter-1)');
        title('xLOG')
    end
    if logs_enabled(2)
        figure;
        plot(yLOG(1:2,1:loop_counter-1)');
        title('yLOG')
    end
    if logs_enabled(3)
        figure;
        plot(zLOG(1:2,1:loop_counter-1)');
        title('zLOG')
    end
end

% PID logs
if (log_PID_evo(3) && loop_counter <= ISE_samples && loop_counter ~= 0 && ~stop_sim)
    zPIDlog(1,loop_counter) = pid_data(pd_index.g_yaw).Kp;
    zPIDlog(2,loop_counter) = pid_data(pd_index.g_yaw).Ki;
    zPIDlog(3,loop_counter) = pid_data(pd_index.g_yaw).Kd;
    
    % for now when they are not used
    zPIDlog(1,loop_counter) = PID_Values(1);
    zPIDlog(2,loop_counter) = PID_Values(2);
    zPIDlog(3,loop_counter) = PID_Values(3);
elseif ((log_PID_evo(3) && loop_counter > ISE_samples) || stop_sim)
    figure;
    plot(zPIDlog(1:3,1:loop_counter-1)');
    title('PID Z')
    legend('P','I','D')
end

%%%%%% TEMP FOR DEBUG %%%%%%%
if (loop_counter ~= 0)
    logFOPDT(1:2,loop_counter) =  FOPDT_Data(3,1:2);
    
    rls.weights(1:2,loop_counter) = rls_data(3).weights;
    rls.V(1:4,loop_counter) = [rls_data(3).V(1), rls_data(3).V(2), rls_data(3).V(3), rls_data(3).V(4)];
    rls.fi(1:2,loop_counter) = rls_data(3).fi;
    rls.K(1:2,loop_counter) = rls_data(3).K;
    rls.error(loop_counter) = rls_data(3).error;

end
if stop_sim
    figure
    plot(logFOPDT(1:2,1:loop_counter-1)');
    title('FOPDT')
    
    figure
    hold on
    plot(rls.weights(1:2,1:loop_counter-1)');
    plot(rls.V(1:4,1:loop_counter-1)');
    plot(rls.fi(1:2,1:loop_counter-1)');
    plot(rls.K(1:2,1:loop_counter-1)');
    plot(rls.error(1:loop_counter-1)');
    title('RLS data')
    legend('w1','w2','V1','V2','V3','V4','fi1','fi2','k1','k2','e');
    hold off
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%