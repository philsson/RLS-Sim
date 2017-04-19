global stop_sim;

% For as long as the simulation is running we log
if (logSim && loop_counter <= SIM_samples && loop_counter ~= 0 && ~stop_sim)
%%

    % loop through all axis
    for i=1:3
        if (logs_enabled(i))
            %if (smooth_moving_target)
            %    log(i).r(loop_counter) = set_points(i);
            %    log(i).u(loop_counter) = outputs(i);
            %    log(i).y(loop_counter) = states(i);
            %else
                log(i).r(loop_counter) = set_points(pd_index.g_roll - 1 + i);
                log(i).u(loop_counter) = outputs(pd_index.g_roll - 1 + i);
                log(i).y(loop_counter) = states(pd_index.g_roll - 1 + i);
            %end
            
            log(i).y_rls(loop_counter) = rls_data(i).RlsOut;
            log(i).rls_w1(loop_counter) = rls_data(i).weights(1);
            switch rls_complexity
                case 2
                    log(i).rls_w2(loop_counter) = rls_data(i).weights(2);
                case 3
                    log(i).rls_w2(loop_counter) = rls_data(i).weights(2);
                    log(i).rls_w3(loop_counter) = rls_data(i).weights(3);
            end


            log(i).L(loop_counter) = FOPDT_Data(i,3);
            log(i).K(loop_counter) = FOPDT_Data(i,2);
            log(i).T(loop_counter) = FOPDT_Data(i,1);

            log(i).Kp_evo(loop_counter) = PID_Values(i,1);

            if use_PIDC_V2 == true
                log(i).Kp(loop_counter) = pid_data_V2(i).K;
                log(i).Ti(loop_counter) = pid_data_V2(i).Ti;
                log(i).Td(loop_counter) = pid_data_V2(i).Td;

                log(i).P(loop_counter) = pid_data_V2(i).P;
                log(i).I(loop_counter) = pid_data_V2(i).I;
                log(i).D(loop_counter) = pid_data_V2(i).D;

                log(i).Ki(loop_counter) = 0;
                log(i).Kd(loop_counter) = 0;
            else
                log(i).Kp(loop_counter) = pid_data(pd_index.g_roll -1 +i).Kp;
                log(i).Ki(loop_counter) = pid_data(pd_index.g_roll -1 +i).Ki;
                log(i).Kd(loop_counter) = pid_data(pd_index.g_roll -1 +i).Kd;

                log(i).Ti(loop_counter) = 0;
                log(i).Td(loop_counter) = 0;
            end


            if  loop_counter > 1
                if step_enabled(i)
                   log(i).MISE_blocks(loop_counter) = MISE(set_points(pd_index.g_roll -1 +i),states(pd_index.g_roll -1 +i),log(i).MISE_blocks(loop_counter-1),time_since_last_step+1);
                   log(i).MAE_blocks(loop_counter) = MAE(set_points(pd_index.g_roll -1 +i),states(pd_index.g_roll -1 +i),log(i).MAE_blocks(loop_counter-1),time_since_last_step+1);
                end
                
            end
           
        end
         if  loop_counter > 1
            % Always log tot MISE
            log(i).MISE(loop_counter) = MISE(set_points(pd_index.g_roll -1 +i),states(pd_index.g_roll -1 +i), log(i).MISE(loop_counter-1),loop_counter-1);
            log(i).MAE(loop_counter) = MAE(set_points(pd_index.g_roll -1 +i),states(pd_index.g_roll -1 +i), log(i).MAE(loop_counter-1),loop_counter-1);
         end
    end





elseif ((logSim && loop_counter > SIM_samples) || stop_sim)
%%
    step_size = step_interval_ms/(1000*dt);
    
    

%----- Name to figure plots ----------------------------------------------------
    axis_name(1).figure1 = 'X-axis Outputs';
    axis_name(1).figure2 = 'X-axis Errors';
    axis_name(1).figure3 = 'X-axis PID parameters and FOPDT data';
    axis_name(2).figure1 = 'Y-axis Outputs';
    axis_name(2).figure2 = 'Y-axis Errors';
    axis_name(2).figure3 = 'Y-axis PID parameters and FOPDT data';
    axis_name(3).figure1 = 'Z-axis Outputs';
    axis_name(3).figure2 = 'Z-axis Errors';
    axis_name(3).figure3 = 'Z-axis PID parameters and FOPDT data';


%% ------------- Plots ----------------------------------------------------
    close all;
    for i = 1:3

         log(i).MISE_blocks = log(i).MISE_blocks(step_size-1:step_size:length(log(i).MISE_blocks));
         log(i).MAE_blocks =  log(i).MAE_blocks(step_size-1:step_size:length(log(i).MAE_blocks));
        
        
     if (logs_enabled(i))
         %-------------Process outputs, control signal and weights---------
         if plot_RLS_Data == true
             figure('Name', axis_name(i).figure1, 'Position', [110, 800, 1290,320]); clf;
             subplot(4,1,1); hold all; grid on;
             plot(1:length(log(i).r),log(i).r);
             plot(1:length(log(i).y),log(i).y);
             plot(1:length(log(i).y_rls),log(i).y_rls);
             title(axis_name(i).figure1);
             legend('r', 'y', 'y RLS');
             ylabel('Process Outputs');

             subplot(4,1,2); hold all; grid on;
             plot(1:length(log(i).u),log(i).u);
             legend('u');
             ylabel('Control signal u');

             subplot(4,1,3); hold all; grid on;
             plot(1:length(log(i).rls_w1),log(i).rls_w1);
             if rls_complexity == 2
                plot(1:length(log(i).rls_w2),log(i).rls_w2);
             elseif rls_complexity == 3
                 plot(1:length(log(i).rls_w2),log(i).rls_w2);
                 plot(1:length(log(i).rls_w3),log(i).rls_w3);
             end
             legend('w1', 'w2', 'w3');
             ylabel('RLS Weights');
             
             subplot(4,1,4); hold all; grid on;
             plot(1:length(log(i).Kp),log(i).Kp);
             plot(1:length(log(i).Kp_evo),log(i).Kp_evo);
             %axis([0 length(log(i).Kp_evo) min(log(i).Kp_evo(10:end)) max(log(i).Kp_evo(10:end))]);
             legend('Kp', 'Kp EVO');
             ylabel('PID outputs');
             
             
         else
             figure('Name', axis_name(i).figure1, 'Position', [110, 800, 1290,320]); clf;
             subplot(2,1,1); hold all; grid on;
             plot(1:length(log(i).r),log(i).r);
             plot(1:length(log(i).y),log(i).y);
             title(axis_name(i).figure1);
             legend('r', 'y');
             ylabel('Process Outputs');

             subplot(2,1,2); hold all; grid on;
             plot(1:length(log(i).u),log(i).u);
             legend('u');
             ylabel('Control signal u');

         end
         
         figure('Name', axis_name(i).figure1, 'Position', [110, 800, 1290,320]); clf;
         hold all; grid on;
         plot(1:length(log(i).r),log(i).r);
         plot(1:length(log(i).y),log(i).y);
         title(axis_name(i).figure1);
         legend('r', 'y');
         ylabel('Process Outputs');


         %---------------Different Errors of output signals---------------
         if plot_Error_Data == true
             figure('Name',axis_name(i).figure2, 'Position', [780, 100, 620,300]); clf;
             subplot(4,1,1); hold all; grid on;
             plot(1:length(log(i).MISE),log(i).MISE);
             title(axis_name(i).figure2);
             legend('MISE');
             ylabel('MISE');

             subplot(4,1,2); hold all; grid on;
             %plot(1:length(log(i).MISE_blocks(step_size-1:step_size:length(log(i).MISE_blocks))),log(i).MISE_blocks(step_size-1:step_size:length(log(i).MISE_blocks)));
             plot(2:length(log(i).MISE_blocks),log(i).MISE_blocks(2:end)); 
             legend('MISE/setpoint');
             ylabel('MISE / new setpoint');

             subplot(4,1,3); hold all; grid on;
             plot(1:length(log(i).MAE),log(i).MAE);
             legend('MAE');
             ylabel('MAE');

             subplot(4,1,4); hold all; grid on;
             %plot(1:length(log(i).MAE_blocks(step_size-1:step_size:length(log(i).MAE_blocks))),log(i).MAE_blocks(step_size-1:step_size:length(log(i).MAE_blocks)));
             plot(2:length(log(i).MAE_blocks),log(i).MAE_blocks(2:end)); 
             legend('MAE /setpoint');
             ylabel('MAE/ new setpoint');

             figure('Name',axis_name(i).figure2, 'Position', [800, 200, 620,300]); clf;      
             plot(1:length(log(i).MISE_blocks(step_size-1:step_size:length(log(i).MISE_blocks))),log(i).MISE_blocks(step_size-1:step_size:length(log(i).MISE_blocks)));
             legend('MISE/setpoint');
             ylabel('MISE / New setpoint');
             grid on;
             
         end

         %------------Pid values and FOPDT Data----------------------------
         if plot_FOPDT_Data == true
             figure('Name',axis_name(i).figure3, 'Position', [110, 100, 620,300]); clf;
             subplot(2,1,1); hold all; grid on;
             plot(1:length(log(i).K),log(i).K);
             plot(1:length(log(i).T),log(i).T);
             plot(1:length(log(i).L),log(i).L);
             title(axis_name(i).figure3);
             legend('K', 'T', 'L');
             ylabel('FOPDT Data');

             if use_PIDC_V2 == true
                 subplot(2,1,2); hold all; grid on;
                 plot(1:length(log(i).Kp),log(i).Kp);
                 plot(1:length(log(i).Kp_evo),log(i).Kp_evo);
                 plot(1:length(log(i).Ti),log(i).Ti);
                 plot(1:length(log(i).Td),log(i).Td);
                 legend('Kp','Kp evo', 'Ti', 'Td');
                 ylabel('PID values');
             else
                 subplot(2,1,2); hold all; grid on;
                 plot(1:length(log(i).Kp),log(i).Kp);
                 plot(1:length(log(i).Ki),log(i).Ki);
                 plot(1:length(log(i).Kd),log(i).Kd);
                 legend('Kp', 'Ki', 'Kd');
                 ylabel('PID values');
             end
         end

        %--------------- P - I - D --------------------%
        if plot_PID_Data
                PID_plot = figure();
                hold on; grid on;
                plot(1:length(log(i).P),log(i).P);
                plot(1:length(log(i).I),log(i).I);
                plot(1:length(log(i).D),log(i).D);
                ylabel('U_component');
                legend('P','I','D');
        end
     end
end

%             figure(fig_MISEy);
%             plot(MISEy(step_size:step_size+1:loop_counter-1)');
%             figure(fig_IAEy);
%             plot(IAEy(step_size:step_size+1:loop_counter-1)');

    stop_sim = true;
end
