global stop_sim;

% For as long as the simulation is running we log
if (logSim && loop_counter <= SIM_samples && loop_counter ~= 0 && ~stop_sim)
    % loop through all axis
    for i=1:3
        log(i).r(loop_counter) = set_points(pd_index.g_roll - 1 + i);
        log(i).u(loop_counter) = outputs(pd_index.g_roll - 1 + i);
        log(i).y(loop_counter) = states(pd_index.g_roll - 1 + i);
        
        if  loop_counter > 1
            if step_enabled(1)
               log(i).MISE_blocks(loop_counter) = MISE(set_points(pd_index.g_roll -1 +i),states(pd_index.g_roll -1 +i),log(i).MISE_blocks(loop_counter-1),time_since_last_step+1);
               log(i).MAE_blocks(loop_counter) = MAE(set_points(pd_index.g_roll -1 +i),states(pd_index.g_roll -1 +i),log(i).MAE_blocks(loop_counter-1),time_since_last_step+1);
            end
            log(i).MISE_blocks(loop_counter) = MISE(set_points(pd_index.g_roll),states(pd_index.g_roll), log(i).MISE_blocks(loop_counter-1),loop_counter-1);
            log(i).MAE_blocks(loop_counter) = MAE(set_points(pd_index.g_roll),states(pd_index.g_roll), log(i).MAE_blocks(loop_counter-1),loop_counter-1);
        end
    end
    
    
    

    
elseif ((logSim && loop_counter > SIM_samples) || stop_sim)
    stop_sim = true;
    step_size = step_interval_ms/(1000*dt);
    
    if logs_enabled(2)
        fig_yLOG = figure;
        figure(fig_yLOG);
        hold on
        plot(yLOG(1:2,1:loop_counter-1)');

        hold off
        title('yLOG')
         
        if plot_MISE %&& step_enabled(2)
            fig_MISEy = figure;
            figure(fig_MISEy);
            plot(MISEy(step_size:step_size+1:loop_counter-1)');
              if step_enabled(2)
                title('MISEy - Step');
            else
                title('MISEy');
              end
                 fig_IAEy = figure
            figure(fig_IAEy);
            plot(IAEy(step_size:step_size+1:loop_counter-1)');
            if step_enabled(1)
                title('IAEy - Step');
            else
                title('IAEy');
            end
        end
    end
end
