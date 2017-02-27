% This file is built on the "simpleSynchronousTest.m"
clear all
close all
hold off
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
    
    %global loop_counter;
    loop_counter = 0;
    global stop_sim;
    stop_sim = false;
    
    global outputs;
    
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
        
        if (~logs_enabled)
            vrep.simxSetObjectPosition(clientID,quad_target,-1,[-1 -1 1],vrep.simx_opmode_oneshot);
        end
        
        % Now step a few times:
        %for i=0:300
        while (1)
        
            %disp('Press a key to step the simulation!');
            %pause;
            
            
            
            getSensors;
           
            % Now we see the result of previouse actuation
            logData;
            
            %set_points
            %states
            %outputs
           
            % Calculate all PID loop outputs
            run_control;
            
            
            % Motormixer
            mixedMotors = motormixer(...
                outputs(pd_index.g_roll),...
                outputs(pd_index.g_pitch),...
                outputs(pd_index.g_yaw),...
                outputs(pd_index.height) + 1);

            % RLS uses information from motormixer
            run_RLS;
            
            % Send actuation
            setMotors(clientID, mixedMotors);
            
            % Bring quad back to position
            %vrep.simxSetObjectPosition(clientID,quad_target,-1,[1 0 0.5],vrep.simx_opmode_oneshot);
            
            vrep.simxSynchronousTrigger(clientID);
           
            loop_counter = loop_counter + 1;
            if stop_sim % Set in "logData" after the amount of samples is reached
                break;
            end
        end
        
        if (loop_counter < ISE_samples)
            logData % This last time to plot only
        end
        
        % stop the simulation:
        vrep.simxStopSimulation(clientID,vrep.simx_opmode_blocking);

        % Now close the connection to V-REP:    
        vrep.simxFinish(clientID);
        
        % Saving RLS data to file
        disp('run "saveRLSdata" to save RLS data if it was pleasant');
        %saveRLSdata; % We might not always want to run this
    
    else
        disp('Failed connecting to remote API server');
    end
    vrep.delete(); % call the destructor!
    
    disp('Program ended');
    loop_counter % prints its value
%end %End of function
