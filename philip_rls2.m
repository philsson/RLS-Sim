function [ rls_data ] = philip_rls2( y_measured, u, rls_data )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here

    % shifting the data one step away to add the new input
    rls_data.u_history = circshift(rls_data.u_history,1);
    rls_data.u_history(1) = u;

    phi = rls_data.u_history' * rls_data.P;

    K = phi'/(rls_data.lamda + phi*rls_data.u_history);

    % Finding y estimate based on weights and control signal
    y_estimate = rls_data.weights' * rls_data.u_history;

    % Estimating error
    e = y_estimate - y_measured;

    % Updating the weights
    rls_data.weights = rls_data.weights + K*e;

    % Updating the value of P
    rls_data.P = (rls_data.P - K*phi) / rls_data.lamda;

    if (rls_data.weights(1) >= 1)
        rls_data.weights(1) = 0.9999;
    end
    
    if (rls_data.weights(2) <= 0)
        rls_data.weights(1) = 0.00019;
    end
    
    % I read in some article that these values should not be outside of
    % (0,1) /P
    %rls_data.weights(1) = constrain(rls_data.weights(1),1);
    %rls_data.weights(2) = constrain(rls_data.weights(1),2);
    
    rls_data.RlsOut = phi*rls_data.weights;

end


