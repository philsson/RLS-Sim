global dt;
global dead_time_L;
global stop_sim;

for i=1:3
    if (adapt_enabled(i))

            rls_data(i) = RLS_FUNC(states(pd_index.compass + i), outputs(pd_index.compass + i), rls_data(i));
            %rls_data_simple(i) = RLS_FUNC(states(pd_index.compass + i), outputs(pd_index.compass + i),rls_data_simple(i));
            
        if length(rls_data(i).weights) < 2 
            FOPDT_Data(i,3) = dead_time_L;                  %L
            FOPDT_Data(i,2) = rls_data(i).weights(1);          %K
            FOPDT_Data(i,1) = 0;                            %T
        else      
            FOPDT_Data(i,1:2) = Get_FOPDT_Data( rls_data(i).weights, dt );
            FOPDT_Data(i,3) = dead_time_L;
        end  
        
        if apply_gain_tuning(i) == true
            PID_Values(i,1) = PID_Gain_my/FOPDT_Data(i,2); %Kp
        else
            PID_Values(i,:) = Get_Tuning_Parameters( FOPDT_Data(i,1:2), dead_time_L );
        end
                  
        if (~isreal(PID_Values))
            disp('PID Data not real numbers!!!')            
            if stop_on_imaginary_numbers
                stop_sim = true;
            end
        end

        if (apply_evo(i) && ((mod(loop_counter,apply_evo_freq) == 0) || apply_evo_first_offset == loop_counter) && (apply_evo_first_offset <= loop_counter))
           
            if (apply_evo_first_offset == loop_counter)
                disp('Started to apply EVO')
            end
            
            PID_Values(i,:) = real(PID_Values(i,:));     % removes imaginary part
            if PID_Values(PID_Values<0)
                disp('Negative PIDS')
            end
            
            if use_PIDC_V2 == true
                if apply_gain_tuning(i) == true
                    pid_data_V2(i).K = PID_Values(i,1);
                else
                    pid_data_V2(i).K = PID_Values(i,1);
                    pid_data_V2(i).Ti = PID_Values(i,2);
                    pid_data_V2(i).Td = PID_Values(i,3);
                end                    
            else
                if apply_gain_tuning(i) == true
                     pid_data_V2(i).K = PID_Values(1);               
                else % gamla adaptiva med tuning rules
                    pid_data(pd_index.compass + i).Kp = PID_Values(i,1);
                    pid_data(pd_index.compass + i).Ki = PID_Values(i,2)*(1/PID_Values(i,2));
                    pid_data(pd_index.compass + i).Kd = PID_Values(i,3)*PID_Values(i,1);
                end                            
            end            
        end
    end
end

%rls_data(3).weights
%rls_data(3).fi