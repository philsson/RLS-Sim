global dt;
global dead_time_L;
global stop_sim;

for i=1:3
    if (adapt_enabled(i))

            rls_data(i) = RLS_FUNC(states(pd_index.compass + i), outputs(pd_index.compass + i), rls_data(i));
            rls_data_simple(i) = RLS_FUNC_Simple(states(pd_index.compass + i), outputs(pd_index.compass + i),rls_data_simple(i));
            
            % Derivative
            %rls_data(i) = RLS_FUNC(gyro_derivatives(i), outputs(pd_index.compass + i), rls_data(i));
            
            % Integral
            %rls_data(i) = RLS_FUNC(states(pd_index.compass + i), u_integral(i), rls_data(i));
                   
        if use_rls_data_simple == true 
            FOPDT_Data(i,3) = dead_time_L;                  %L
            FOPDT_Data(i,2) = rls_data_simple(i).weights;   %K
            FOPDT_Data(i,1) = 0;                            %T      
        else      
            FOPDT_Data(i,1:2) = Get_FOPDT_Data( rls_data(i).weights, dt );
            FOPDT_Data(i,3) = dead_time_L;
        end  
        
        if apply_gain_tuning(i) == true
            PID_Values(1) = PID_Gain_my/FOPDT_Data(i,2); %Kp
        else
            PID_Values = Get_Tuning_Parameters( FOPDT_Data(i,1:2), dead_time_L );
        end
                  
        if (~isreal(PID_Values))
            disp('PID Data not real numbers!!!')            
            if stop_on_imaginary_numbers
                stop_sim = true;
            end
        end

        if (apply_evo(i) && (mod(loop_counter,apply_evo_freq) == 0) && (apply_evo_first_offset <= loop_counter))
           
            if (apply_evo_first_offset == loop_counter)
                disp('Started to apply EVO');
            end
            
            PID_Values = real(PID_Values);
            if PID_Values(PID_Values<0)
                disp('Negative PIDS')
            end
            
            if use_PIDC_V2 == true
                if apply_gain_tuning(i) == true
                    pid_data_V2(i).K = PID_Values(1);
                else
                    pid_data_V2(i).K = PID_Values(1);
                    pid_data_V2(i).Ti = PID_Values(2);
                    pid_data_V2(i).Td = PID_Values(3);
                end                    
            else
                if apply_gain_tuning(i) == true
                     pid_data_V2(i).K = PID_Values(1);               
                else
                    if U_rescale_axis(i)
                        pid_data(pd_index.compass + i).Kp = PID_Values(1)*U_rescale;
                        pid_data(pd_index.compass + i).Ki = PID_Values(2)*U_rescale*(1/PID_Values(2));
                        pid_data(pd_index.compass + i).Kd = PID_Values(3)*U_rescale*PID_Values(1);
                    else
                        pid_data(pd_index.compass + i).Kp = PID_Values(1);
                        pid_data(pd_index.compass + i).Ki = PID_Values(2)*(1/PID_Values(2));
                        pid_data(pd_index.compass + i).Kd = PID_Values(3)*PID_Values(1);
                    end
                end                            
            end            
        end
    end
end

%rls_data(3).weights
%rls_data(3).fi