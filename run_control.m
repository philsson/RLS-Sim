

control_loops = fieldnames(pd_index);


% Loop through all control loops. ex 1..7
for i = 1:numel(control_loops)  
    % Calculating errors
    pid_data(i).e = set_points(i) - states(i); % TODO: Kolla varför matlab klagar. Ser helt okej ut enligt mig
    
    % Running control loops
    % TODO: Though these might need to run in a specific order
    outputs(i) = PID_CONTROLLER(i);
end    
    
% Loop through all content of control_loops
for i = control_loops'
    i;
    %pd_index.(control_loops{i})
    
    %pid_data.(i{1}).Kp
    %control_loops.(i{1})
    
end


