% Here we retrieve all sensor data from the simulation

global dt;
global stop_sim;

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
% For some reaso the pich and roll dont follow the quad rotation so we
% correct the data
yaw = -(quad_angles(3)/180*pi);
roll = quad_angles(1)*cos(yaw) - quad_angles(2)*sin(yaw);
pitch = quad_angles(1)*sin(yaw) + quad_angles(2)*cos(yaw);
quad_angles(1) = roll;
quad_angles(2) = pitch;

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

if ~(exist('old_pos','var'))
    old_pos = [0 0];
elseif isnan(old_pos)
    old_pos = [0 0];
end

if ~(exist('old_gyro_data','var'))
    old_gyro_data = [0 0 0];
elseif isnan(old_pos)
    old_gyro_data = [0 0 0];
end

% Import to "states"
states(pd_index.height)  = quad_pos(3);
states(pd_index.p_x)     = quad_pos(1);
states(pd_index.p_y)     = quad_pos(2);
states(pd_index.v_x)     = (quad_pos(1) - old_pos(1)) / dt;
states(pd_index.v_x)     = (quad_pos(2) - old_pos(2)) / dt;
states(pd_index.a_roll)  = quad_angles(1);
states(pd_index.a_pitch) = quad_angles(2);
states(pd_index.compass) = quad_angles(3);
states(pd_index.g_roll)  = quad_gyro_data(1);
states(pd_index.g_pitch) = quad_gyro_data(2);
states(pd_index.g_yaw)   = quad_gyro_data(3);

if sum(isnan(states)) > 0
    disp('some states are NaN!. Maybe quad out of range in simulation')
    stop_sim = true;
end

% log old position for velocities
old_pos = [quad_pos(1), quad_pos(2)];



%Joystick
if use_joystick
    RC.roll     = map(axis(joy,1),1,joy_rate);
    RC.pitch    = map(axis(joy,2),1,joy_rate);
    RC.yaw      = map(axis(joy,3),1,joy_rate)*(-1);
    RC.throttle = map(axis(joy,4),1,throttle_rate);
    RC.aux1     = axis(joy,5);
    
    if (RC.aux1 > 0.1)
        RC.aux1 = 1;
    elseif (RC.aux1 < -0.1)
        RC.aux1 = -1;
    else
        RC.aux1 = 0;
    end
end
%[RC.roll RC.pitch RC.yaw] %DEBUG


