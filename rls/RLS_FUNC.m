function [ rls_data] = RLS_FUNC(y, u, rls_data)

    %-- rls_data. --

    %complexity = Matrix dimensions, should be even numbers. Always start with 2
    %RlsOut     = output value of rls approximation funciton
    %weights    = vector, deriving tuning rules
    %fi         = vector with previous in and outputs [y(k-1 u(k-1)]'
    %error      = output error of RLS
    %V          = matrix
    %K          = matrix

    run_approximation = false; % Test if the learnt RLS is good
    % -- RLS  --- 

   

    % Forgetting factor
    my = 0.998;
    %my = 1;
    
    if (rls_data.complexity == 3)
        fi = [rls_data.fi(1) rls_data.fi(2) rls_data.fi(4)]';
    else
        fi = rls_data.fi;      
    end
    
    rls_data.RlsOut = fi'*rls_data.weights;

    rls_data.error = y - fi'*rls_data.weights;

    b = my + fi'*rls_data.V*fi;

    % TODO: inv(b) can just be 1/b. Less computational heavy. As it is a scalar
    rls_data.V = (1/my)*rls_data.V - inv(b)*rls_data.V*fi*fi'*rls_data.V;

    %rls_data.K = rls_data.V*rls_data.fi;
    K = rls_data.V*fi;

    if ~run_approximation
        rls_data.weights = rls_data.weights + K*rls_data.error;
    end


    %-- Update fi values ---
    switch rls_data.complexity
        case 1
             rls_data.fi = u;
            
        case 3
            if run_approximation
                rls_data.fi = [fi'*rls_data.weights fi(1) u rls_data.fi(3)]';
            else
                rls_data.fi = [y fi(1) u rls_data.fi(3)]';
            end
            
        otherwise
            y_in = circshift(rls_data.fi(1:(length(rls_data.fi))/2),1)';
            u_in = circshift(rls_data.fi(((length(rls_data.fi))/2) + 1:end),1)';

            y_in(1) = y;
            u_in(1) = u;

            if run_approximation
                rls_data.fi = [rls_data.fi'*rls_data.weights u_in]';
            else
                rls_data.fi = [y_in u_in]';
            end

            % Just for tuning rules. Not a good thing
            if (rls_data.weights(1) >= 1)
                rls_data.weights(1) = 0.9999;
            end
        
    end

    % Constrain weights
    if rls_data.complexity ~= 3
        for i=1:length(rls_data.weights)
            if rls_data.weights(i) == 0
                rls_data.weights(i) = 1e-10;
            end
        end

        if rls_data.weights(1) <= 0
            %rls_data.weights(1) = 1e-4;
        end
    else
        if rls_data.weights(3) <= 0
            rls_data.weights(3) = 0.01;
        end
    end
end

