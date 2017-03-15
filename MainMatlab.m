% This file is built on the "simpleSynchronousTest.m"
clear all
close all
clc;
clear;

% Add functions from the current dir and sub dirs
addpath(genpath(pwd));

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
    sim_progress = 0;
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
        
        if (rand_target && follow_target)
            %vrep.simxSetObjectPosition(clientID,quad_target,-1,[-1 -1 1],vrep.simx_opmode_oneshot);
            vrep.simxSetObjectPosition(clientID,quad_target,-1,[2*rand-2 2*rand-2 rand+1],vrep.simx_opmode_oneshot);
        end
        
        
        setMassAndInertia(clientID, 1.0,[1.0 1.0 1.0]);
        h = waitbar(0,'Running Simulation...');
        while (1)
        
            if loop_counter == round( 0.3 *SIM_samples);
                %setMassAndInertia(clientID, 0.12,[8e-06 0.000904 0.003]);
                freq_resp_params = [ 0.2 0.2 ]
                disp(['Doubling inertia! Iteration: ' num2str(loop_counter)])
            end
            if loop_counter == round( 0.6 *SIM_samples);
                %setMassAndInertia(clientID, 0.12,[8e-06 0.000904 0.012]);
                freq_resp_params = [ 0.35 0.5 ]
                disp(['Doubling inertia! Iteration: ' num2str(loop_counter)])
            end
          
            waitbar(loop_counter/SIM_samples)
            
            %disp('Press a key to step the simulation!');
            %pause;
            
            % If we want to read the inertia from simulation (Requires the
            % correct ttt file in V-rep)
            %getInertia;
            
            getSensors;
           
            % RLS uses information from motormixer
            % OBS: Unsure of where this should be
            if use_PIDC_V2
                run_rls_gainPID;
            else
                run_RLS;
            end
            
            % Now we see the result of previouse actuation
           
           
            % Calculate all PID loop outputs
            run_control;
            
            logData;

            %save_data_for_log;
              
            % Motormixer
            mixedMotors = motormixer(...
                outputs(pd_index.g_roll),...
                outputs(pd_index.g_pitch),...
                outputs(pd_index.g_yaw),...
                outputs(pd_index.height) + 1);

            % RLS uses information from motormixer
            %run_RLS; % Moved to just before get sensors
            
            % Send actuation
            setMotors(clientID, mixedMotors);
            
            % Bring quad back to position (DOES NOT WORK)
            %vrep.simxSetObjectPosition(clientID,quad_target,-1,[1 0 0.5],vrep.simx_opmode_oneshot);
            
            vrep.simxSynchronousTrigger(clientID);
           
            loop_counter = loop_counter + 1;
            if stop_sim % Set in "logData" after the amount of samples is reached
                break;
            end

        end
       
        
        if (loop_counter < SIM_samples)
            logData % This last time to plot only
        end
        
        % stop the simulation:
        vrep.simxStopSimulation(clientID,vrep.simx_opmode_blocking);

        % Now close the connection to V-REP:    
        vrep.simxFinish(clientID);
        
        % Saving RLS data to file
        disp('run "saveRLSdata" to save RLS data if it was pleasant');
        %saveRLSdata; % We might not always want to run this
        close(h)

    else
        disp('Failed connecting to remote API server');
    end
    vrep.delete(); % call the destructor!


    disp('Program ended');
    loop_counter % prints its value
%end %End of function
