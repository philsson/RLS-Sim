close all;
clc;

% Settings from init_variables
SIM_samples = 3000;  
rand_target_amplitude = [3 3 1];
dt = 0.025;

% Store path
path = zeros(3,SIM_samples);

time = linspace(1,SIM_samples,SIM_samples)*dt;
step = 10;

for loop_counter = 1:SIM_samples
    path(1,loop_counter) = 2*rand_target_amplitude(1)*abs(sin(loop_counter/175))^2*abs(cos(loop_counter/450))-rand_target_amplitude(1);
    path(2,loop_counter) = 2*rand_target_amplitude(2)*abs(sin(loop_counter/250))*abs(cos(loop_counter/333))^3-rand_target_amplitude(1);
    path(3,loop_counter) = rand_target_amplitude(3)*abs(cos(loop_counter/1000)) + 1;
    %vrep.simxSetObjectPosition(clientID,quad_target,-1,[smooth_xPos smooth_yPos smooth_zPos],vrep.simx_opmode_oneshot);
end

figure;
subplot(2,2,1)
hold on
grid on
plot(path(1,:),path(2,:))
xlabel('x-pos'); ylabel('y-pos');
subplot(2,2,2)
hold on
grid on
plot3(path(1,1:step:end),path(2,1:step:end),path(3,1:step:end),'k')
stem3(path(1,1:step:end),path(2,1:step:end),path(3,1:step:end)')
xlabel('x-pos'); ylabel('y-pos'); zlabel('elevation');
view([240 23])
subplot(2,2,[3 4]) 
hold on
grid on
plot(time, path(1,:),time, path(2,:), time, path(3,:))
legend('x','y','z');
xlabel('time'); ylabel('amplitude');
