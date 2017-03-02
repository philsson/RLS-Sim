function [ motors ] = motormixer( R,P,Y,T )
    %MOTORMIXER Summary of this function goes here
    %   Detailed explanation goes here

    % These two are used for RLS training
    global pd_index;
    global outputs;
        
    % Upper motor limit
    motors_max = 3;
    % Check how much the combined output wants to be
    

    mixer = [
    %    R  P  Y T
         1 -1 -1  1; %M1
         1  1  1  1; %M2
        -1  1 -1  1; %M3
        -1 -1  1  1  %M4
    ]';

    % 
    motors = [R P Y T]*mixer;

    % Test as if we had battery sag
    %motors = [R*5 P Y T]*mixer;
    
    global motorLimitReached;
    floor = false;
    roof = false;

    % Constrain motor output
    for i=1:4
       if (motors(i) <= 0) 

           motors(i) = 0;
           floor = true;

       end
       if (motors(i) >= motors_max)

           motors(i) = motors_max;
           roof = true;
       end
    end

    % First approach here is not used as we don't adjust the interval
    %motorLimitReached = (floor && roof);
    motorLimitReached = roof;
    
    % Simple scaling for RLS to get correct training data
    if roof

        combined_output = abs(R) + abs(P) + abs(Y) + T;
        
        outputs(pd_index.g_roll) = R * (motors_max / combined_output);
        outputs(pd_index.g_pitch) = P * (motors_max / combined_output);
        outputs(pd_index.g_yaw) = Y * (motors_max / combined_output);
    end  

    
end

% Some test notes

%Write to motors
% 1 1 0 0 gav 
% positiv rotationshastighet i roll
% positiv roll vinkel (-90 minskar, ex -100)

% 0 1 1 0 gav (lutar bak??t i bild)
% positiv rotationshastighet i pitch
% positiv lutning i pitch

% 1 0 1 0 gav
% negativ rotation i yaw
% negativ vridning i yaw

%efter fix
% 0 1 0 1 gav (vrider sig v??nster)
% gyro postiv
% acc positiv (-350 som ??r +10)

% 0 0 1 1 (rollar h??ger i bild)
% gyro negativ
% ACC negativ

% 1 0 0 1 (pitchar ner??t i bild)
% gyro negativ
% ACC negativ

%ACC vilol??ge -1.5708         0    3.1416 (-90, 0, 180)

%M1 = [1 -1 -1 1]
%M2 = [1 1  1 1]
%M3 = [-1 1 -1 1]
%M4 = [-1 -1  1 1]