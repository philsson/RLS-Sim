% This file is built on the "simpleSynchronousTest.m"

%function MainMatlab()
    disp('Program started');
    % vrep=remApi('remoteApi','extApi.h'); % using the header (requires a compiler)
    vrep=remApi('remoteApi'); % using the prototype file (remoteApiProto.m)
    vrep.simxFinish(-1); % just in case, close all opened connections
    clientID=vrep.simxStart('127.0.0.1',19997,true,true,5000,5);
    
    if (clientID>-1)
        disp('Connected to remote API server');

        % enable the synchronous mode on the client:
        vrep.simxSynchronous(clientID,true);

        % get all the handlers
        getHandlers;
        
        % start the simulation:
        vrep.simxStartSimulation(clientID,vrep.simx_opmode_blocking);

        % Now step a few times:
        for i=0:10
            disp('Press a key to step the simulation!');
            pause;
            getSensors;
            
            if (1) %print sensors (for test)
            {    
                quad_gyro_data
                quad_pos
                quad_target_pos
                quad_angles
            }
           
            
            % Motormixer
            % mixedMotors = motormixer(R, P, Y, T)
            
            % Send actuation
            setMotors(clientID, mixedMotors)
            
            
            vrep.simxSynchronousTrigger(clientID);
        end

        % stop the simulation:
        vrep.simxStopSimulation(clientID,vrep.simx_opmode_blocking);

        % Now close the connection to V-REP:    
        vrep.simxFinish(clientID);
    else
        disp('Failed connecting to remote API server');
    end
    vrep.delete(); % call the destructor!
    
    disp('Program ended');
%end %End of function
