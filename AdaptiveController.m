%Adaptive Controller

dt = 1; %sampeling time

rls_data_roll = RLS_FUNC(2, 1, rls_data_roll);
FOPDT_Data_roll = Get_FOPDT_Data( rls_data_roll.weights, dt );
[ PID_Values ] = Get_Tuning_Parameters( FOPDT_Data_roll, dt/2 );