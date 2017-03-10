global dt;
global stop_sim;

for i=1:3
    if (adapt_enabled(i))
        if use_philips_rls
            rls_data(i) = philip_rls2(states(pd_index.compass + i), outputs(pd_index.compass + i), rls_data(i));
        else
            rls_data(i) = RLS_FUNC(states(pd_index.compass + i), outputs(pd_index.compass + i), rls_data(i));
            %rls_data(i) = old_RLS_FUNC(states(pd_index.compass + i), outputs(pd_index.compass + i), rls_data(i));
        end
        FOPDT_Data(i,1:2) = Get_FOPDT_Data( rls_data(i).weights, dt );
        PID_Values = Get_Tuning_Parameters( FOPDT_Data(i,1:2), dt/2 );
            
       
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

            by10 = false;
            if by10
                pid_data(pd_index.compass + i).Kp = keepPositive(PID_Values(1))/10;
                pid_data(pd_index.compass + i).Ki = keepPositive(PID_Values(2))/10;
                pid_data(pd_index.compass + i).Kd = keepPositive(PID_Values(3))/10;
            else
                pid_data(pd_index.compass + i).Kp = PID_Values(1)*sign(U_rescale); %/10;
                pid_data(pd_index.compass + i).Ki = PID_Values(2)*sign(U_rescale); %/10;
                pid_data(pd_index.compass + i).Kd = PID_Values(3)*sign(U_rescale); %/10;
            end
        end
    end
end

%rls_data(3).weights
%rls_data(3).fi