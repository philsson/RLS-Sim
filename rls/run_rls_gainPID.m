global dt;
global stop_sim;

for i=1:3
    if (adapt_enabled(i))
        
        % Lista ut gainen
        rls_data_simple(i) = RLS_FUNC_Simple(states(pd_index.compass + i), outputs(pd_index.compass + i),rls_data_simple(i));
        
        
        
        if (apply_evo(i) && (mod(loop_counter,apply_evo_freq) == 0) && (apply_evo_first_offset <= loop_counter))
           
            % hämta nya PID värden
            %[ pid_data_V2(i) ] = PID_ScaleOnGain( pid_data(pd_index.g_yaw -1 +i), pid_data_V2(i), rls_data_simple(i).weights, PID_Gain_my)
            pid_data_V2(i).K = PID_Gain_my / rls_data_simple(i).weights;
            % Köra PID controllen
             
            
            
            
            if (apply_evo_first_offset == loop_counter)
                disp('Started to apply EVO');
            end
        end
        PID_Values = [pid_data_V2(i).K pid_data_V2(i).Ti pid_data_V2(i).Td];
    end
end

