function [ returnCode ] = setMotors( clientID, motors )
%SETMOTORS Summary of this function goes here
%   Detailed explanation goes here
    vrep=remApi('remoteApi'); % using the prototype file (remoteApiProto.m)

    motors_single = single(motors);
    motorsPacked = vrep.simxPackFloats(motors_single);
    returnCode = vrep.simxSetStringSignal(clientID,'motors',motorsPacked,8*4);

end

