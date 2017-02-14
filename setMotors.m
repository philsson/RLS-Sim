function [ returnCode ] = setMotors( motors )
%SETMOTORS Summary of this function goes here
%   Detailed explanation goes here

    motorsPacked = vrep.simxPackFloats(motors);
    returnCode = vrep.simxSetStringSignal(clientID,'motors',motorsPacked,8*4);

end

