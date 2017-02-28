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
        if loop_counter > 1
            MISEz(loop_counter) = MISE(set_points(pd_index.g_yaw),states(pd_index.g_yaw),MISEz(loop_counter-1),loop_counter);
        end
    end
    
elseif ((calcISE && loop_counter > ISE_samples) || stop_sim)
    stop_sim = true;
    
    if logs_enabled(1)
        fig_xLOG = figure;
        figure(fig_xLOG);
        plot(xLOG(1:2,1:loop_counter-1)');
        title('xLOG')
    end
    if logs_enabled(2)
        fig_yLOG = figure;
        figure(fig_yLOG);
        plot(yLOG(1:2,1:loop_counter-1)');
        title('yLOG')
    end
    if logs_enabled(3)
        fig_zLOG = figure;
        figure(fig_zLOG);
        plot(zLOG(1:2,1:loop_counter-1)');
        title('zLOG')
    end
    if plot_MISE
        fig_MISE = figure;
        figure(fig_MISE);
        plot(MISEz(1:loop_counter-1)');
        title('MISE');
    end    
end

% PID logs
if (log_PID_evo(3) && loop_counter <= ISE_samples && loop_counter ~= 0 && ~stop_sim)
    zPIDlog(1,loop_counter) = pid_data(pd_index.g_yaw).Kp;
    zPIDlog(2,loop_counter) = pid_data(pd_index.g_yaw).Ki;
    zPIDlog(3,loop_counter) = pid_data(pd_index.g_yaw).Kd;
    
    % for now when they are not used
    zPIDlog(1,loop_counter) = real(PID_Values(1));
    zPIDlog(2,loop_counter) = real(PID_Values(2));
    zPIDlog(3,loop_counter) = real(PID_Values(3));
elseif ((log_PID_evo(3) && loop_counter > ISE_samples) || stop_sim)
    fig_PID = figure;
    figure(fig_PID);
    grid on
    plot(zPIDlog(1:3,1:loop_counter-1)');
    title('PID Z')
    legend('P','I','D')
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
    legend('r','y','y_bis')
    hold off
  end
    
  if logs_enabled(2) %&& plot_RLS  
    figure(fig_yLOG)
    hold on
    grid on
    plot(rls(3).out(1:loop_counter-1)');
    legend('r','y','y_bis')
    hold off
  end
    
  if logs_enabled(3) %&& plot_RLS  
    % Go back to zLOG and plot the RLS expected output
    figure(fig_zLOG)
    hold on
    grid on
    plot(rls(3).out(1:loop_counter-1)');
    legend('r','y','y_bis')
    hold off
  end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%