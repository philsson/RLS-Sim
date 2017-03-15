global dt;
global stop_sim;

for i=1:3
    if (adapt_enabled(i))
        if use_philips_rls
            rls_data(i) = philip_rls2(states(pd_index.compass + i), outputs(pd_index.compass + i), rls_data(i));
        else
            rls_data(i) = RLS_FUNC(states(pd_index.compass + i), outputs(pd_index.compass + i), rls_data(i));
            
            
            % Derivative
            %rls_data(i) = RLS_FUNC(gyro_derivatives(i), outputs(pd_index.compass + i), rls_data(i));
            
            % Integral
            %rls_data(i) = RLS_FUNC(states(pd_index.compass + i), u_integral(i), rls_data(i));
            
            
            rls_data_simple(i) = RLS_FUNC_Simple(states(pd_index.compass + i), outputs(pd_index.compass + i),rls_data_simple(i));
            %rls_data_simple(i) = RLS_FUNC_Simple(gyro_derivatives(i), outputs(pd_index.compass + i),rls_data_simple(i));
            %rls_data(i) = old_RLS_FUNC(states(pd_index.compass + i), outputs(pd_index.compass + i), rls_data(i));
        end
        
        if use_rls_data_simple == true
            
            FOPDT_Data(i,2) = rls_data_simple(i).weights;
            FOPDT_Data(i,1) = 1;%dt;
        
            
        else
        
            FOPDT_Data(i,1:2) = Get_FOPDT_Data( rls_data(i).weights, dt );
            
        
        end
            PID_Values = Get_Tuning_Parameters( FOPDT_Data(i,1:2), dt/2 );
            %PID_Values = Get_Tuning_Parameters( FOPDT_Data(i,1:2), 0.8 );
       
        if (~isreal(PID_Values))
            disp('PID Data not real numbers!!!')
            
            if stop_on_imaginary_numbers
                stop_sim = true;
            end
        end

        if (apply_evo(i) && (mod(loop_counter,apply_evo_freq) == 0) && (apply_evo_first_offset <= loop_counter))
            % TODO: This is just a quickfix. These numbers should NOT be
            % imaginary
            if (apply_evo_first_offset == loop_counter)
                disp('Started to apply EVO');
            end
            PID_Values = real(PID_Values);
            if PID_Values(PID_Values<0)
                disp('Negative PIDS')
            end

            
            if U_rescale_axis(i)
                pid_data(pd_index.compass + i).Kp = abs(PID_Values(1)*U_rescale);
                pid_data(pd_index.compass + i).Ki = abs(PID_Values(2)*U_rescale);
                pid_data(pd_index.compass + i).Kd = abs(PID_Values(3)*U_rescale);
            else
                pid_data(pd_index.compass + i).Kp = abs(PID_Values(1));
                pid_data(pd_index.compass + i).Ki = abs(PID_Values(2));
                pid_data(pd_index.compass + i).Kd = abs(PID_Values(3));
            end
        end
    end
end

%rls_data(3).weights
%rls_data(3).fi