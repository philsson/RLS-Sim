defaultPIDs;

disp('Converting manual tune to RLS weights...')
for i=1:3
    rls_data(i) = johan_reversePIDs(pid_data(pd_index.g_roll -1 +i).Kp,pid_data(pd_index.g_roll -1 +i).Ki,pid_data(pd_index.g_roll -1 +i).Kd,dt/2);
end

%% Changing the manual PID scale
Manual_PID_Scale = 1.5;
for i= 3:3
    pid_data(pd_index.g_roll -1 +i).Kp = pid_data(pd_index.g_roll -1 +i).Kp*Manual_PID_Scale;
    pid_data(pd_index.g_roll -1 +i).Ki = pid_data(pd_index.g_roll -1 +i).Ki*Manual_PID_Scale;
    pid_data(pd_index.g_roll -1 +i).Kd = pid_data(pd_index.g_roll -1 +i).Kd*Manual_PID_Scale;
end



%% This is for changing the RLS reversed PIDs
RLS_PID_Scale = 1.5;

for i=1:3
    rls_data(i) = johan_reversePIDs(...
        pid_data(pd_index.g_roll -1 +i).Kp*RLS_PID_Scale,...
        pid_data(pd_index.g_roll -1 +i).Ki*RLS_PID_Scale,...
        pid_data(pd_index.g_roll -1 +i).Kd*RLS_PID_Scale,...
        dt/2);
end
saveRLSdata;