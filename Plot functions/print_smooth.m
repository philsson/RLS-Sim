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

x=-4:.1:4;
[X,Y] = meshgrid(x);
Z= (X*Y) - 500 + 58.1; %meshgrid(0:0.1:1);

hold on
grid on
plot3(path(1,1:step:end),path(2,1:step:end),path(3,1:step:end),'LineWidth',4)
plot3(path(1,1:step:end/4),path(2,1:step:end/4),path(3,1:step:end/4),'LineWidth',0.6, 'Color', 'y')
plot3(path(1,end/4:step:end/2),path(2,end/4:step:end/2),path(3,end/4:step:end/2),'LineWidth',0.6, 'Color', 'g')
plot3(path(1,end/2:step:end/1),path(2,end/2:step:end/1),path(3,end/2:step:end/1),'LineWidth',0.6, 'Color', 'g')
% stem3(path(1,1:step:end),path(2,1:step:end),path(3,1:step:end)','Color', 'y')
% plot3(path(1,1:step:end),path(2,1:step:end),path(3,1:step:end),'o', 'Color', 'r')

le = 1.5;
la = 1.4

le2 = 2.1;
la2 = 1.8;

le3 = 22
la3 = 13;

le4 = 3.5
la4 = 3.4;


%plot3(path(1,end/6:step:end),path(2,end/6:step:end),path(3,end/6:step:end),'LineWidth',3)
stem3(path(1,end/le:step:end/la),path(2,end/le:step:end/la),path(3,end/le:step:end/la)','Color', 'r')
stem3(path(1,end/le2:step:end/la2),path(2,end/le2:step:end/la2),path(3,end/le2:step:end/la2)','Color', 'r')
stem3(path(1,end/le3:step:end/la3),path(2,end/le3:step:end/la3),path(3,end/le3:step:end/la3)','Color', 'k')
stem3(path(1,end/le4:step:end/la4),path(2,end/le4:step:end/la4),path(3,end/le4:step:end/la4)','Color', 'm')
%plot3(path(1,end/6:step:end),path(2,end/6:step:end),path(3,end/6:step:end),'o', 'Color', 'r')

%plot3(path(1,1:step:end),path(2,1:step:end),path(3,1:step:end),'LineWidth',3 ,'Color', 'r')
%stem3(path(1,1:step:end),path(2,1:step:end),path(3,1:step:end)','Color', 'y')

%surf(X,Y,Z)
colormap([1, 0, 0
    1, 0, 0
    1, 0, 0
    1, 0, 0
    1, 0, 0])

xlabel('x-pos'); ylabel('y-pos'); zlabel('elevation');
view([240 23])
subplot(2,2,[3 4]) 

hold on
grid on
plot(time, path(1,:),time, path(2,:), time, path(3,:))
legend('x','y','z');
xlabel('time'); ylabel('amplitude');
