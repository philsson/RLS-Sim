


%-------------- Z axiz -------------------------------------------------------%

if logs_enabled(3) == true
      
    %-------------- Z axiz, PID values / FOPDT data K and T --------------%
      
    figure(); clf;
    subplot(211); hold all; grid on;
   
    stairs(1:length(kp_data_z_axis), kp_data_z_axis);
    stairs(1:length(ki_data_z_axis), ki_data_z_axis);
    stairs(1:length(kd_data_z_axis), kd_data_z_axis);
    
    axis([0 loop_counter -(min(kp_data_z_axis)*1.1) (max(kp_data_z_axis)+max(kp_data_z_axis)*1.1)]);
    ylabel('Pid values');
    legend('Kp', 'Ki', 'Kd')
    title('Z axis - PID values and FOPDT');
    
    subplot(212); hold all; grid on;
   
    stairs(1:length(fopdt_data_z_axis(1,:)), fopdt_data_z_axis(1,:));
    stairs(1:length(fopdt_data_z_axis(2,:)), fopdt_data_z_axis(2,:));
    
    axis([0 loop_counter -(max(fopdt_data_z_axis(2,:))) (max(fopdt_data_z_axis(2,:))+max(fopdt_data_z_axis(2,:)*0.1))]);
    ylabel('FOPDT values');
    legend('T', 'K')
    
    %-------------- Z axiz, outputs / inputs / weights -----------------------%
    
    figure(); clf;
    subplot(311); hold all; grid on;
   
    stairs(1:length(y_data_z_axis), y_data_z_axis);
    stairs(1:length(rlsout_data_z_axis), rlsout_data_z_axis);
    stairs(1:length(r_data_z_axis), r_data_z_axis);
    
    axis([0 loop_counter min(y_data_z_axis(loop_counter*0.01:end)) max(y_data_z_axis(loop_counter*0.01:end))]);
    ylabel('Process output Y');
    legend('y', 'y rls', 'r')
    title('Z axis out');
    
    subplot(312); hold all; grid on;
    stairs(1:length(u_data_z_axis), u_data_z_axis);
    
    axis([0 loop_counter min(u_data_z_axis(loop_counter*0.05:end)) max(u_data_z_axis(loop_counter*0.05:end))]);
    ylabel('Process input u');
    legend('u')
    
    subplot(313); hold all; grid on;
    stairs(1:loop_counter-1, weights_data_z_axis(1,:));
    stairs(1:loop_counter-1, weights_data_z_axis(2,:));
    
    axis([0 loop_counter (min(weights_data_z_axis(1,loop_counter*0.01:end))+0.1) max(weights_data_z_axis(2,loop_counter*0.01:end))*1.1]);

    ylabel('Weights output');
    legend('a1', 'b1');
           
end