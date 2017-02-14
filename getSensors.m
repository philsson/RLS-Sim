% Here we retrieve all sensor data from the simulation

% "Get time step". This gets us the delta time between iterations. Can
% differ between iterations depending on the sim setup
%dT = vrep.simxGetSimulationTimeStep(clientID)
[returnCode, dtPacked] = vrep.simxGetStringSignal(clientID,'dt',8);
dt = vrep.simxUnpackFloats(dtPacked);

% get ACC data
[returCode, quad_angles] = vrep.simxGetObjectOrientation(clientID,quad_base,6,vrep.simx_opmode_oneshot);

% get gyro data
[returnCode, quad_gyro_data_packed] = vrep.simxGetStringSignal(clientID,'gyro_data',8*3);
quad_gyro_data = vrep.simxUnpackFloats(quad_gyro_data_packed);

% get quad position
[returnCode, quad_pos] = vrep.simxGetObjectPosition(clientID,quad_base,-1,vrep.simx_opmode_oneshot);
[returnCode, quad_target_pos] = vrep.simxGetObjectPosition(clientID,quad_target,-1,vrep.simx_opmode_oneshot);
