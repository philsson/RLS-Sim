% This file is built on the "simpleSynchronousTest.m"
clc;
clear;

%function MainMatlab()
    disp('Program started');
    % vrep=remApi('remoteApi','extApi.h'); % using the header (requires a compiler)
    %vrep=remApi('remoteApi'); % using the prototype file (remoteApiProto.m)
    global vrep;
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
        
        % Init variables
        init_variables;

        %retrieve sensor data. Does not give right values first time so
        %better call it once before
        getSensors;
        
        % Now step a few times:
        for i=0:100
        
            %disp('Press a key to step the simulation!');
            %pause;
            getSensors;
           
            %set_points
            %states
           
            % Calculate all PID loop outputs
            run_control;
            
            % Motormixer
            mixedMotors = motormixer(...
                outputs(pd_index.g_roll),...
                outputs(pd_index.g_pitch),...
                outputs(pd_index.g_yaw),...
                outputs(pd_index.height) + 1);

            
            % Send actuation
            setMotors(clientID, mixedMotors);
            
            
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
