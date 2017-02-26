function [ rls_data, FOPDT_Data ] = init_rand_rls_data()
%Initialize a random dataset for RLS data
%   Detailed explanation goes here


% TODO: Where is the forgetting factor. Should this not be ~0.99?

    rls_data.complexity = 2;
    rls_data.weights = rand(1,rls_data.complexity)';
    rls_data.V = rand(rls_data.complexity,rls_data.complexity);
    rls_data.fi = rand(1,rls_data.complexity)';     
    rls_data.K = rand(1,rls_data.complexity)';  
    rls_data.error = 0; 

    % Denna fanns inte med i Johans init
    rls_data.RlsOut = 0;
    
    FOPDT_Data = [1 1];
end


   
