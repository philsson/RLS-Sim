% Quad handler
[returnCode, quad] = vrep.simxGetObjectHandle(clientID,'Quadricopter',vrep.simx_opmode_blocking);

% Quad base handler
[returnCode, quad_base] = vrep.simxGetObjectHandle(clientID,'Quadricopter_base',vrep.simx_opmode_blocking);

% Target handler
[returnCode, quad_target] = vrep.simxGetObjectHandle(clientID,'Quadricopter_target',vrep.simx_opmode_blocking);

