function [ rls_data ] = init_rls_data(complexity)
%Initialize a random dataset for RLS data
%   Detailed explanation goes here

global dt;
% TODO: Where is the forgetting factor. Should this not be ~0.99?

rls_data.complexity = complexity;

    
    rls_data.weights = zeros(1,rls_data.complexity)';
    rls_data.V = eye(rls_data.complexity,rls_data.complexity)*5;
    
    if complexity == 3
        rls_data.fi = zeros(1,4)'; 
    else
        rls_data.fi = zeros(1,rls_data.complexity)'; 
    end
    
    rls_data.error = 0; 

    % Denna fanns inte med i Johans init
    rls_data.RlsOut = 0;
    
    
end


   
