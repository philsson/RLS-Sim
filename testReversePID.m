% This file is not part of the simulation. Its only purpose was/is to
% evaluate the reversePID function and to be ran manually

global dt;

Kp = 0.05;
Ki = 0.004;
Kd = 0.00051;

%%
rls_data_from_reversedPID = reversePIDs(Kp,Ki,Kd,0)

%%
FOPDT_ReversedData = Get_FOPDT_Data(rls_data_from_reversedPID.weights,dt)

%%
Get_Tuning_Parameters(FOPDT_ReversedData,dt/2)

%% to save these values to file
rls_data(3) = reversePIDs(Kp,Ki,Kd,0);
saveRLSdata;