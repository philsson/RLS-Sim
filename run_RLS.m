global dt;
global stop_sim;

for i=1:3
    if (adapt_enabled(i))
        rls_data(i) = RLS_FUNC(states(pd_index.compass + i), outputs(pd_index.compass + i), rls_data(i));
        FOPDT_Data(i,1:2) = Get_FOPDT_Data( rls_data(i).weights, dt );
        PID_Values = Get_Tuning_Parameters( FOPDT_Data(i,1:2), dt/2 );
            
        % TODO: Why do we get imaginary part?
        if (~isreal(PID_Values))
            disp('PID Data not real numbers!!!')
            
            if stop_on_imaginary_numbers
                stop_sim = true;
            end
        end

        if apply_evo(i)
            % TODO: This is just a quickfix. These numbers should NOT be
            % imaginary
            PID_Values = real(PID_Values);
            
            pid_data(pd_index.compass + i).Kp = PID_Values(1);
            pid_data(pd_index.compass + i).Ki = PID_Values(2);
            pid_data(pd_index.compass + i).Kd = PID_Values(3);
        end
    end
end