%global loop_counter;

%global ISE_samples


%global logs_enabled;
% Enable log for: X(roll)   Y(pitch)    Z(yaw)
%log_enabled =  [  true      false       false];

if (calcISE && loop_counter <= ISE_samples && loop_counter ~= 0)
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
elseif (calcISE && loop_counter > ISE_samples)
    stop_sim = true;
    if logs_enabled(1)
        figure;
        plot(xLOG(1:2,1:ISE_samples)');
    end
    if logs_enabled(2)
        figure;
        plot(yLOG(1:2,1:ISE_samples)');
    end
    if logs_enabled(3)
        figure;
        plot(zLOG(1:2,1:ISE_samples)');
    end
end

% plot(xLOG(1:2,1:200)')