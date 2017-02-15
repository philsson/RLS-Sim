function [ motors ] = motormixer( R,P,Y,T )
    %MOTORMIXER Summary of this function goes here
    %   Detailed explanation goes here

    % Upper motor limit
    motors_max = 2;

    mixer = [
    %    R  P  Y T
         1 -1 -1  1; %M1
         1  1  1  1; %M2
        -1  1 -1  1; %M3
        -1 -1  1  1  %M4
    ]';

    % 
    motors = [R P Y T]*mixer;

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
    
end

% Some test notes

%Write to motors
% 1 1 0 0 gav 
% positiv rotationshastighet i roll
% positiv roll vinkel (-90 minskar, ex -100)

% 0 1 1 0 gav (lutar bakåt i bild)
% positiv rotationshastighet i pitch
% positiv lutning i pitch

% 1 0 1 0 gav
% negativ rotation i yaw
% negativ vridning i yaw

%efter fix
% 0 1 0 1 gav (vrider sig vänster)
% gyro postiv
% acc positiv (-350 som är +10)

% 0 0 1 1 (rollar höger i bild)
% gyro negativ
% ACC negativ

% 1 0 0 1 (pitchar neråt i bild)
% gyro negativ
% ACC negativ

%ACC viloläge -1.5708         0    3.1416 (-90, 0, 180)

%M1 = [1 -1 -1 1]
%M2 = [1 1  1 1]
%M3 = [-1 1 -1 1]
%M4 = [-1 -1  1 1]