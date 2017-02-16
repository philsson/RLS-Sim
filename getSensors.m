% Here we retrieve all sensor data from the simulation

% "Get time step". This gets us the delta time between iterations. Can
% differ between iterations depending on the sim setup
%dT = vrep.simxGetSimulationTimeStep(clientID)
[returnCode, dtPacked] = vrep.simxGetStringSignal(clientID,'dt',8);
%dt = vrep.simxUnpackFloats(dtPacked);

% get ACC data
[returCode, quad_angles] = vrep.simxGetObjectOrientation(clientID,quad_base,6,vrep.simx_opmode_oneshot);
% correct the offsets and translate to degrees
quad_angles = [-(quad_angles(1)+pi/2), -quad_angles(2), quad_angles(3)-pi]/pi*180;
quad_angles = wrap180(quad_angles);

% get gyro data
[returnCode, quad_gyro_data_packed] = vrep.simxGetStringSignal(clientID,'gyro_data',8*3);
quad_gyro_data = vrep.simxUnpackFloats(quad_gyro_data_packed);
% translate to degrees
quad_gyro_data = quad_gyro_data/pi*180;
if (size(quad_gyro_data,2) < 3)
    quad_gyro_data = [0 0 0];
end

% get quad position
[returnCode, quad_pos] = vrep.simxGetObjectPosition(clientID,quad_base,-1,vrep.simx_opmode_oneshot);
[returnCode, quad_target_pos] = vrep.simxGetObjectPosition(clientID,quad_target,-1,vrep.simx_opmode_oneshot);


% Import to "states"
states(pd_index.height)  = quad_pos(3);
states(pd_index.p_x)     = quad_pos(1);
states(pd_index.p_y)     = quad_pos(2);
states(pd_index.a_roll)  = quad_angles(1);
states(pd_index.a_pitch) = quad_angles(2);
states(pd_index.compass) = quad_angles(3);
states(pd_index.g_roll)  = quad_gyro_data(1);
states(pd_index.g_pitch) = quad_gyro_data(2);
states(pd_index.g_yaw)   = quad_gyro_data(3);
