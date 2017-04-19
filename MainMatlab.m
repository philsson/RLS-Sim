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
        
        %setMassAndInertia(clientID, 1,[1 1 0.004]);
        setMassAndInertia(clientID, sim_inertias(1,1),sim_inertias(2:4,1)');
        while (1)
        
            if loop_counter == round( 0.33 *SIM_samples);
                % Suitable inertia X  = ?, Y = ?, Z = 12;
                if any(change_inertias == 1)
                    setMassAndInertia(clientID, sim_inertias(1,2),sim_inertias(2:4,2)');
                    disp(['Decreasing inertia! Iteration: ' num2str(loop_counter)])
                end
                %freq_resp_params = [ 0.2 0.2 ];
                
            end
            if loop_counter == round( 0.66 *SIM_samples);
                if any(change_inertias == 1)
                    setMassAndInertia(clientID, sim_inertias(1,3),sim_inertias(2:4,3)');
                    disp(['Increasing inertia! Iteration: ' num2str(loop_counter)])
                end
                %freq_resp_params = [ 0.35 0.5 ];
                
            end
            
            % reduces battery power by the hour
            %if use_battery_scaling
             %   battery_scaling = 1-((loop_counter/SIM_samples)*battery_reduction);
            %end
            
            if use_battery_scaling
                 %battery_scaling = ((1-(loop_counter/SIM_samples))^2)*battery_reduction;
                 battery_scaling = polyval(bat_polynome,(loop_counter/SIM_samples) * 1.03); % 1.03 ger 0.59 ggr spänningen vid full simulering
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
  
            run_RLS;
            
            
            % Now we see the result of previouse actuation
           
           
            % Calculate all PID loop outputs
            run_control;
            
            logData;

              
            % Motormixer
            mixedMotors = motormixer(...
                outputs(pd_index.g_roll),...
                outputs(pd_index.g_pitch),...
                outputs(pd_index.g_yaw),...
                outputs(pd_index.height) + 1);

            
            % Send actuation
            setMotors(clientID, mixedMotors);
            
            % Bring quad back to position (DOES NOT WORK)
            %vrep.simxSetObjectPosition(clientID,quad_target,-1,[1 0 0.5],vrep.simx_opmode_oneshot);
            
            vrep.simxSynchronousTrigger(clientID);
           
            loop_counter = loop_counter + 1;
            if stop_sim  % Set in "logData" after the amount of samples is reached
                break;
            end

        end
       
       
        
        % stop the simulation:
        vrep.simxStopSimulation(clientID,vrep.simx_opmode_blocking);

        % Now close the connection to V-REP:    
        vrep.simxFinish(clientID);
        
        savelog;
        
        % Saving RLS data to file
        disp('run "saveRLSdata" to save RLS data if it was pleasant');
        %saveRLSdata; % We might not always want to run this
        close(h)
        
        % Print MISE
        if smooth_moving_target
            disp(['MISE: Hight[ ' num2str(log(1).MISE(end)) ' ] X_pos[ '  num2str(log(2).MISE(end)) ' ] Y_pos[ '  num2str(log(3).MISE(end)) ' ]' ]);
            disp(['MAE: Hight[ ' num2str(log(1).MAE(end)) ' ] X_pos[ '  num2str(log(2).MAE(end)) ' ] Y_pos[ '  num2str(log(3).MAE(end)) ' ]' ]);
        else
            disp(['MISE: Roll[ ' num2str(log(1).MISE(end)) ' ] Pitch[ '  num2str(log(2).MISE(end)) ' ] Yaw[ '  num2str(log(3).MISE(end)) ' ]' ]);
            disp(['MAE: Roll[ ' num2str(log(1).MAE(end)) ' ] Pitch[ '  num2str(log(2).MAE(end)) ' ] Yaw[ '  num2str(log(3).MAE(end)) ' ]' ]);
        end
    else
        disp('Failed connecting to remote API server');
    end
    vrep.delete(); % call the destructor!


    disp('Program ended');
    loop_counter % prints its value
%end %End of function
