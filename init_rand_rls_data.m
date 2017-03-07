function [ rls_data, FOPDT_Data ] = init_rand_rls_data()
%Initialize a random dataset for RLS data
%   Detailed explanation goes here

global dt;
% TODO: Where is the forgetting factor. Should this not be ~0.99?

rls_data.complexity = 2;

if (0) % Johans approach

    rls_data.weights = rand(1,rls_data.complexity)';
    rls_data.V = rand(rls_data.complexity,rls_data.complexity);
    rls_data.fi = rand(1,rls_data.complexity)';     
    
    %temp
    %rls_data.K = rand(1,rls_data.complexity)';  

% Min test
else
    
    rls_data.weights = ones(1,rls_data.complexity)'*0.5;
    rls_data.V = ones(rls_data.complexity,rls_data.complexity)*1;%1e10;
    rls_data.fi = zeros(1,rls_data.complexity)';   
    
    % 
   % rls_data.K = -ones(1,rls_data.complexity)';  

    
end
    
    rls_data.error = 0; 

    % Denna fanns inte med i Johans init
    rls_data.RlsOut = 0;
    
    FOPDT_Data = Get_FOPDT_Data(rls_data_weights,dt);%[1 1];
end


   
