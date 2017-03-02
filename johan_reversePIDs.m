function [ rls_data ] = johan_reversePIDs( Kp, Ki, Kd, L )
%This function will give the RLS data based on current PIDs. L is not used
%now
% For example:
% reversePIDs(pid_data(pd_index.g_yaw).Kp,pid_data(pd_index.g_yaw).Kd...
%   L id the deadtime. For us normally dt/2 or less

%------------------ Step 1: Recognition of T and K -----------------------%
global dt;
%use_const_index = 1;

Ti = Kp/Ki;
Td = Kd/Kp;


% tau <= 1 gives first index else second
% ex. constants.a1(1) else constants.a1(2)
constants = struct(...
    'a1', {1.048, 1.154},...
    'a2', {1.195, 1.047},...
    'a3', {0.489, 0.490},...
    'b1', {-0.897, -0.567},...
    'b2', {-0.368, -0.220},...
    'b3', {0.888, 0.708});


% T according to equation Ti

T(1) = (Ti*constants(1).a2/2) + sqrt(((Ti*constants(1).a2/2)^2) + Ti*constants(1).b2*L);
T(2) = (Ti*constants(1).a2/2) - sqrt(((Ti*constants(1).a2/2)^2) + Ti*constants(1).b2*L);

T(3) = (Ti*constants(2).a2/2) + sqrt(((Ti*constants(2).a2/2)^2) + Ti*constants(2).b2*L);
T(4) = (Ti*constants(2).a2/2) - sqrt(((Ti*constants(2).a2/2)^2) + Ti*constants(2).b2*L);


% -----------------------------------------------------------------------------

Td_find(1) = constants(1).a3*T(1)*((L/T((1)))^constants(1).b3);
Td_find(2) = constants(1).a3*T(2)*((L/T(2))^constants(1).b3);


Td_find(3) = constants(2).a3*T(3)*((L/T(3))^constants(2).b3);
Td_find(4) = constants(2).a3*T(4)*((L/T(4))^constants(2).b3);


Old_Td = Td_find(1);
index = 1;

for i = 1:4
    
New_Td = abs(Td_find(i) - Td);

    if (New_Td <= Old_Td)
        
        Old_Td = New_Td;
        index = i;
    end
     
end


table_index = 2;

if ((L/T(index)) <= 1)
    table_index = 1;
end

K = (constants(table_index).a1/Kp)*((L/(T(index)))^constants(table_index).b1);
if ~isreal(K)
    disp('K is imaginary because of root of  negative T')
end


%------------------ Step 2: Backtrace RLS weights  -----------------------%
% FOPDT_Data = [T K]
w = [0;0];

w(1) = (T(index) - dt)/T(index);
w(2) = dt*K / T(index);

%------------------ Step 3: Find the RLS data ----------------------------%

% Creating the empty struct
rls_data = struct(...
    'complexity',   2,...           % Don't change
    'weights',      [w(1); w(2)],...      % 
    'V',            [0 0; 0 0],...  %
    'fi',           [0; 0],...      % Can leave empty 
    'K',            [0; 0],...      % 
    'error',        0,...           % 
    'RlsOut',       0);             % 


if (rls_data.weights(1) >= 1)
    rls_data.weights(1) = 0.9999;
    disp('rls weights(1) was above 1 at initialization!')
end
if (rls_data.weights(2) <= 0)
    rls_data.weights(2) = 0.0001;
end


end

