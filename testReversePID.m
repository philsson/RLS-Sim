% This file is not part of the simulation. Its only purpose was/is to
% evaluate the reversePID function and to be ran manually

global dt;

Kp = 0.05;
Ki = 0.004;
Kd = 0.00051;
%% From roll
Kp = pid_data(pd_index.g_roll).Kp
Ki = pid_data(pd_index.g_roll).Ki
Kd = pid_data(pd_index.g_roll).Kd
%%
Kp = pid_data(pd_index.g_pitch).Kp
Ki = pid_data(pd_index.g_pitch).Ki
Kd = pid_data(pd_index.g_pitch).Kd
%%
 Kp = pid_data(pd_index.g_yaw).Kp
Ki = pid_data(pd_index.g_yaw).Ki
Kd = pid_data(pd_index.g_yaw).Kd
%%
rls_data_from_reversedPID = reversePIDs(Kp,Ki,Kd,0)

%%
FOPDT_ReversedData = Get_FOPDT_Data(rls_data_from_reversedPID.weights,dt)

%%
Get_Tuning_Parameters(FOPDT_ReversedData,dt/2)

%% to save these values to file
rls_data(3).weights = rls_data_from_reversedPID.weights;


% Anteckningar
% Vikterna [ 0.9 1650 ] testades fram manuelt för roll och gav riktigt bra
% startvärden, snarlika de manuellt tunade PID'arna
% Get_Tuning_Parameters(Get_FOPDT_Data([0.9 1650],dt),dt/2)