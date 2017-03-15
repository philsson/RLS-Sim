% Init adaptive tuning paramaters
% This has been added to a function instead "init_rand_rls_data"


rls_data_roll.complexity = 2;
rls_data_roll.weights = rand(1,rls_data_roll.complexity)';
rls_data_roll.V = rand(rls_data_roll.complexity,rls_data_roll.complexity);
rls_data_roll.fi = rand(1,rls_data_roll.complexity)';     
rls_data_roll.K = rand(1,rls_data_roll.complexity)';  
rls_data_roll.error = 0; 