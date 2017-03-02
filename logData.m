global stop_sim;

%global loop_counter;

%global ISE_samples


%global logs_enabled;
% Enable log for: X(roll)   Y(pitch)    Z(yaw)
%log_enabled =  [  true      false       false];
%disp(['time since last step: ', num2str(time_since_last_step)])
%disp(['loop counter: ', num2str(loop_counter)])
if (calcISE && loop_counter <= ISE_samples && loop_counter ~= 0 && ~stop_sim)
    if logs_enabled(1)
        xLOG(1:3,loop_counter) = [set_points(pd_index.g_roll) states(pd_index.g_roll) pid_data(pd_index.g_roll).e];
        if loop_counter > 1
            if step_enabled(1)
                MISEx(loop_counter) = MISE(set_points(pd_index.g_roll),states(pd_index.g_roll),MISEx(loop_counter-1),time_since_last_step+1);
            else
                MISEx(loop_counter) = MISE(set_points(pd_index.g_roll),states(pd_index.g_roll),MISEx(loop_counter-1),loop_counter-1);
            end
            TotMISEx =  MISE(set_points(pd_index.g_roll),states(pd_index.g_roll),TotMISEx,loop_counter);
        end
        %time_since_last_step
        %if step_enabled(1) && time_since_last_step == 0
        %    MISEx = 0;
        %end
    end
    if logs_enabled(2)
        yLOG(1:3,loop_counter) = [set_points(pd_index.g_pitch) states(pd_index.g_pitch) pid_data(pd_index.g_pitch).e];
        if loop_counter > 1
            if step_enabled(2)
                MISEy(loop_counter) = MISE(set_points(pd_index.g_pitch),states(pd_index.g_pitch),MISEy(loop_counter-1),time_since_last_step+1);
            else
                MISEy(loop_counter) = MISE(set_points(pd_index.g_pitch),states(pd_index.g_pitch),MISEy(loop_counter-1),loop_counter-1);
            end
            TotMISEy =  MISE(set_points(pd_index.g_pitch),states(pd_index.g_pitch),TotMISEy,loop_counter);
        end
        %if step_enabled(2) && time_since_last_step == 0
        %    MISEy = 0;
        %end
    end
    if logs_enabled(3)
        zLOG(1:3,loop_counter) = [set_points(pd_index.g_yaw) states(pd_index.g_yaw) pid_data(pd_index.g_yaw).e];
        if loop_counter > 1
            if step_enabled(3)
                MISEz(loop_counter) = MISE(set_points(pd_index.g_yaw),states(pd_index.g_yaw),MISEz(loop_counter-1),time_since_last_step+1);
            else
                MISEz(loop_counter) = MISE(set_points(pd_index.g_yaw),states(pd_index.g_yaw),MISEz(loop_counter-1),loop_counter-1);
            end
            TotMISEz =  MISE(set_points(pd_index.g_yaw),states(pd_index.g_yaw),TotMISEz,loop_counter);
        end
        %if step_enabled(3) && time_since_last_step == 0
        %    MISEz = 0;
        %end
    end
    
    % Log control signal
    for i=1:3
        U(i,loop_counter) = outputs(pd_index.g_roll -1 +i);
    end

    
elseif ((calcISE && loop_counter > ISE_samples) || stop_sim)
    stop_sim = true;
    step_size = step_interval_ms/(1000*dt);
    if logs_enabled(1)
        fig_xLOG = figure;
        figure(fig_xLOG);
        plot(xLOG(1:2,1:loop_counter-1)');
        title('xLOG')
        
        if plot_MISE %&& step_enabled(1)
            fig_MISEx = figure;
            figure(fig_MISEx);
            plot(MISEx(step_size:step_size+1:loop_counter-1)');
            title('MISEx');
        end  
    end
    if logs_enabled(2)
        fig_yLOG = figure;
        figure(fig_yLOG);
        plot(yLOG(1:2,1:loop_counter-1)');
        title('yLOG')
         
        if plot_MISE %&& step_enabled(2)
            fig_MISEy = figure;
            figure(fig_MISEy);
            plot(MISEy(step_size:step_size+1:loop_counter-1)');
            title('MISEy');
        end
    end
    if logs_enabled(3)
        fig_zLOG = figure;
        figure(fig_zLOG);
        plot(zLOG(1:2,1:loop_counter-1)');
        title('zLOG')
         
        if plot_MISE% && step_enabled(3)
            fig_MISEz = figure;
            figure(fig_MISEz);
            plot(MISEz(step_size:step_size+1:loop_counter-1)');
            title('MISEz');
        end
    end
  
    % Plot control signals
    figure
    hold on
    for i=1:3
        plot(U(i,1:loop_counter-1)');
    end
    hold off
    title('Control Signals')
    legend('u_x','u_y','u_z')
end

% PID logs
if (log_PID_evo(1) && logs_enabled(1) && loop_counter <= ISE_samples && loop_counter ~= 0 && ~stop_sim)
    xPIDlog(1,loop_counter) = pid_data(pd_index.g_roll).Kp;
    xPIDlog(2,loop_counter) = pid_data(pd_index.g_roll).Ki;
    xPIDlog(3,loop_counter) = pid_data(pd_index.g_roll).Kd;
elseif ((log_PID_evo(1) && loop_counter > ISE_samples) || stop_sim)
    if logs_enabled(1)
        fig_PIDx = figure;
        figure(fig_PIDx);
        grid on
        plot(xPIDlog(1:3,1:loop_counter-1)');
        title('PID X')
        legend('P','I','D')
    end
end

if (log_PID_evo(2) && logs_enabled(2) && loop_counter <= ISE_samples && loop_counter ~= 0 && ~stop_sim)
    yPIDlog(1,loop_counter) = pid_data(pd_index.g_pitch).Kp;
    yPIDlog(2,loop_counter) = pid_data(pd_index.g_pitch).Ki;
    yPIDlog(3,loop_counter) = pid_data(pd_index.g_pitch).Kd;
elseif ((log_PID_evo(2) && loop_counter > ISE_samples) || stop_sim)
    if logs_enabled(2)
        fig_PIDy = figure;
        figure(fig_PIDy);
        grid on
        plot(yPIDlog(1:3,1:loop_counter-1)');
        title('PID Y')
        legend('P','I','D')
    end
end

if (log_PID_evo(3) && logs_enabled(3) && loop_counter <= ISE_samples && loop_counter ~= 0 && ~stop_sim)
    zPIDlog(1,loop_counter) = pid_data(pd_index.g_yaw).Kp;
    zPIDlog(2,loop_counter) = pid_data(pd_index.g_yaw).Ki;
    zPIDlog(3,loop_counter) = pid_data(pd_index.g_yaw).Kd;
    
    % for now when they are not used
    zPIDlog(1,loop_counter) = real(PID_Values(1));
    zPIDlog(2,loop_counter) = real(PID_Values(2));
    zPIDlog(3,loop_counter) = real(PID_Values(3));
elseif ((log_PID_evo(3) && loop_counter > ISE_samples) || stop_sim)
    if logs_enabled(3)
        fig_PIDz = figure;
        figure(fig_PIDz);
        grid on
        plot(zPIDlog(1:3,1:loop_counter-1)');
        title('PID Z')
        legend('P','I','D')
    end
end

%%%%%% TEMP FOR DEBUG %%%%%%%
if (loop_counter ~= 0)
    
    if plot_FOPDT
        logFOPDT(1:2,loop_counter) =  FOPDT_Data(3,1:2);
    end

    
    % Om vi kör Johans RLS
    %if plot_RLS
    for i = 1:3
        if logs_enabled(i)
            %rls(i).weights(1:rls_data(i).complexity,loop_counter) = rls_data(i).weights;
            if ~use_philips_rls

                    %rls.V(1:rls_data(3).complexity,1:rls_data(3).complexity,loop_counter) = rls_data(3).V(1:rls_data(3).complexity,1:rls_data(3).complexity);%[rls_data(3).V(1), rls_data(3).V(2), rls_data(3).V(3), rls_data(3).V(4)];
                    %rls.fi(1:rls_data(3).complexity,loop_counter) = rls_data(3).fi;
                    %rls.K(1:rls_data(3).complexity,loop_counter) = rls_data(3).K;
                    %rls.error(loop_counter) = rls_data(3).error; 

                    rls(i).out(loop_counter) = rls_data(i).RlsOut;
            else
                    rls(i).out(loop_counter) = rls_data(i).out;
            end
        end
    end
    %end
    
end
if stop_sim
    if plot_FOPDT
        FOPDT = figure;
        figure(FOPDT);
        plot(logFOPDT(1:2,1:loop_counter)');
        title('FOPDT')
    end
        
    if plot_RLS
        figure
        hold on
        %plot(rls.weights(1:2,1:loop_counter-1)');

        % If using Johans RLS
        if ~use_philips_rls
            plot(rls.V(1:4,1:loop_counter-1)');
            plot(rls.fi(1:2,1:loop_counter-1)');
            plot(rls.K(1:2,1:loop_counter-1)');
            plot(rls.error(1:loop_counter-1)');
        else
            plot(rls.error(1:loop_counter-1)');
        end
        title('RLS data')
        legend('w1','w2','V1','V2','V3','V4','fi1','fi2','k1','k2','e');
        hold off
    end
    
  if logs_enabled(1) %&& plot_RLS  
    figure(fig_xLOG)
    hold on
    grid on
    plot(rls(1).out(1:loop_counter-1)');
    legend('r','y','y_{rls}')
    hold off
  end
    
  if logs_enabled(2) %&& plot_RLS  
    figure(fig_yLOG)
    hold on
    grid on
    plot(rls(2).out(1:loop_counter-1)');
    legend('r','y','y_{rls}')
    hold off
  end
    
  if logs_enabled(3) %&& plot_RLS  
    % Go back to zLOG and plot the RLS expected output
    figure(fig_zLOG)
    hold on
    grid on
    plot(rls(3).out(1:loop_counter-1)');
    legend('r','y','y_{rls}')
    hold off
  end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%