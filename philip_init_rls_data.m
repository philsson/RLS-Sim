function [ rls_data ] = philip_init_rls_data( sysorder )
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here

    rls_data.complexity = sysorder;

    delta  = 1e10;  %Just for creation of initial P matrix

    rls_data.lamda = 0.999 %0.995; %Forgetting factor

    rls_data.P = delta * eye(sysorder); % Unit matrix times delta


    % Now we fill in all other empty fields
    rls_data.weights = zeros(sysorder,1); % weights are initialized to zeros

    rls_data.u_history = zeros(sysorder,1); % Store the amount of system control signals as sysorder

end

