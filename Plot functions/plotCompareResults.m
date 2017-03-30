function [ ] = plotCompareResults( log1 , log2, plot_name, inertia)

log(1) = load(log1);
log(2) = load(log2);

disp('Log file loaded to "log"')
init1 = length(log(1).y)*0.33;
init2 = length(log(1).y)*0.66;

%% ------- Outputs, PID and Errors ----------------------------------------

figure('Name', plot_name) %, 'Position', [110, 800, 1290,320]); clf;
subplot(4,1,1); hold all; grid on;
plot(1:length(log(1).r),log(1).r);
plot(1:length(log(1).y),log(1).y);
plot(1:length(log(2).y),log(2).y);
if inertia
plot([init1 init1],[min(log(1).y) max(log(1).y)], 'Color', 'b');
text(init1, min(log(1).y), ' Changed inertia', 'Color', 'b', 'fontsize',8);
plot([init2 init2],[min(log(1).y) max(log(1).y)], 'Color', 'b');
text(init2, min(log(1).y), ' Changed inertia', 'Color', 'b', 'fontsize',8);
end
title(plot_name);
legend('r', 'y1', 'y2');
ylabel('Process Outputs');

subplot(4,1,2); hold all; grid on;
plot(1:length(log(1).Kp),log(1).Kp);
plot(1:length(log(2).Kp),log(2).Kp);
legend('Kp1', 'Kp2');
ylabel('PID values');

subplot(4,1,3); hold all; grid on;
plot(1:length(log(1).MISE),log(1).MISE);
plot(1:length(log(2).MISE),log(2).MISE);
legend('MISE1', 'MISE2');
ylabel('MISE');

subplot(4,1,4); hold all; grid on;
plot(1:length(log(1).MISE_blocks),log(1).MISE_blocks);
plot(1:length(log(2).MISE_blocks),log(2).MISE_blocks);
legend('MISE/setpoint 1', 'MISE/setpoint 2');
ylabel('MISE/setpoint');



%% ------- Outputs ----------------------------------------

figure('Name', plot_name) %, 'Position', [110, 800, 1290,320]); clf;
hold all; grid on;
plot(1:length(log(1).r),log(1).r);
plot(1:length(log(1).y),log(1).y);
plot(1:length(log(2).y),log(2).y);
if inertia
plot([init1 init1],[min(log(1).y) max(log(1).y)], 'Color', 'b');
text(init1, min(log(1).y), ' Changed inertia', 'Color', 'b', 'fontsize',8);
plot([init2 init2],[min(log(1).y) max(log(1).y)], 'Color', 'b');
text(init2, min(log(1).y), ' Changed inertia', 'Color', 'b', 'fontsize',8);
end
title(plot_name);
legend('r', 'y1', 'y2');
ylabel('Process Outputs');


end
