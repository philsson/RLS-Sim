% Init adaptive tuning paramaters


rls_data_roll.complexity = 2;
rls_data_roll.weights = rand(1,rls_data_roll.complexity)';
rls_data_roll.V = rand(rls_data_roll.complexity,rls_data_roll.complexity);
rls_data_roll.fi = rand(1,rls_data_roll.complexity)';     
rls_data_roll.K = rand(1,rls_data_roll.complexity)';  
rls_data_roll.error = 0; 