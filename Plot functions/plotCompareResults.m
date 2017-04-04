function [ ] = plotCompareResults( log1 , log2, plot_name, inertia)

log(1) = load(log1);
log(2) = load(log2);

disp('Log file loaded to "log"')
init1 = length(log(1).y)*0.33;
init2 = length(log(1).y)*0.66;
init3 = length(log(1).y);

%% ------- Outputs, PID and Errors ----------------------------------------

figure('Name', plot_name) %, 'Position', [110, 800, 1290,320]); clf;
subplot(4,1,1); hold all; grid on;
plot(1:length(log(1).y),log(1).y,'--', 'LineWidth',1)%,'--', 'Color', 'r');
plot(1:length(log(2).y),log(2).y, '--', 'LineWidth',1)%,'--', 'Color', 'k');
plot(1:length(log(1).r),log(1).r,'LineWidth',0.1)%, 'LineWidth',0.1, 'Color', 'g');
if inertia
plot([init1 init1],[min(log(1).y) max(log(1).y)], 'Color', 'k');
text(init1, max(log(1).y)-1, ' Changed inertia', 'Color', 'k', 'fontsize',8);
plot([init2 init2],[min(log(1).y) max(log(1).y)], 'Color', 'k');
text(init2, max(log(1).y)-1, ' Changed inertia', 'Color', 'k', 'fontsize',8);
end
axis([1 length(log(1).y) min(log(1).y) max(log(1).y)])
title(plot_name);
h = legend('y Evo', 'y Manual tuning','r Reference signal');
h1 = ylabel('Process Outputs');
set(h,'FontSize',14);
set(h1,'FontSize',14);

subplot(4,1,2); hold all; grid on;
plot(1:length(log(1).Kp),log(1).Kp,'--');
plot(1:length(log(2).Kp),log(2).Kp, '--');
axis([1 length(log(1).Kp) min(log(2).Kp)-0.01 max(log(1).Kp)])
h = legend('Kp Evo', 'Kp Manual tuning');
h1 = ylabel('PID Values');
set(h,'FontSize',14);
set(h1,'FontSize',14);

subplot(4,1,3); hold all; grid on;
plot(2:length(log(1).MAE_blocks),log(1).MAE_blocks(2:end),'--');
plot(2:length(log(2).MAE_blocks),log(2).MAE_blocks(2:end), '--');
h = legend('MAE/setpoint Evo', 'MAE/setpoint Manual tuning');
h1 = ylabel('MAE/setpoint');
set(h,'FontSize',14);
set(h1,'FontSize',14);

subplot(4,1,4); hold all; grid on;
plot(2:length(log(1).MISE_blocks),log(1).MISE_blocks(2:end),'--');
plot(2:length(log(2).MISE_blocks),log(2).MISE_blocks(2:end), '--');
h = legend('MISE/setpoint Evo', 'MISE/setpoint Manual tuning');
h1 = ylabel('MISE/setpoint');
set(h,'FontSize',14);
set(h1,'FontSize',14);



%% ------- Outputs ----------------------------------------

figure('Name', plot_name) %, 'Position', [110, 800, 1290,320]); clf;
hold all; grid on;
subplot(3,1,1); hold all; grid on;
plot(1:init1, log(1).y(1:init1), '');
plot(1:init1,log(2).y(1:init1), '--');
plot(1:init1,log(1).r(1:init1));
axis([1 init1 min(log(2).y)-0.01 max(log(2).y)])
h = legend('y Evo', 'y Manual tuning','r Reference signal');
h1 = ylabel('Inertia 1');
set(h,'FontSize',14);
set(h1,'FontSize',14);

subplot(3,1,2); hold all; grid on;
plot(init1:init2, log(1).y(init1:init2));
plot(init1:init2,log(2).y(init1:init2), '--');
plot(init1:init2,log(1).r(init1:init2));
axis([init1 init2 min(log(1).y)-0.01 max(log(1).y)])
h1 = ylabel('Inertia 2');
set(h1,'FontSize',14);

subplot(3,1,3); hold all; grid on;
plot(init2:init3, log(1).y(init2:init3));
plot(init2:init3,log(2).y(init2:init3), '--');
plot(init2:init3,log(1).r(init2:init3));
axis([init2 init3 min(log(2).y)-0.01 max(log(2).y)])
h1 = ylabel('Inertia 3');
set(h1,'FontSize',14);

if inertia
plot([init1 init1],[min(log(1).y) max(log(1).y)], 'Color', 'b');
text(init1, min(log(1).y), ' Changed inertia', 'Color', 'b', 'fontsize',8);
plot([init2 init2],[min(log(1).y) max(log(1).y)], 'Color', 'b');
text(init2, min(log(1).y), ' Changed inertia', 'Color', 'b', 'fontsize',8);
end
%title(plot_name);
%h = legend('r', 'y1', 'y2');
%h1 = ylabel('Process Outputs');
%set(h,'FontSize',14);
%set(h1,'FontSize',14);


%% ------- Outputs 2 ----------------------------------------

figure('Name', plot_name) %, 'Position', [110, 800, 1290,320]); clf;
hold all; grid on;
subplot(1,2,1); hold all; grid on;
plot(200:400, log(1).y(200:400), '--');
plot(200:400,log(2).y(200:400), '--');
plot(200:400,log(1).r(200:400));
%axis([1 init1 min(log(2).y)-0.01 max(log(2).y)])
h1 = ylabel('Process Outputs');
set(h,'FontSize',14);
set(h1,'FontSize',14);

subplot(1,2,2); hold all; grid on;
plot(1800:2000, log(1).y(1800:2000), '--');
plot(1800:2000,log(2).y(1800:2000), '--');
plot(1800:2000,log(1).r(1800:2000));
h = legend('y Evo', 'y Manual tuning','r Reference signal');
set(h,'FontSize',14);
%axis([1 init1 min(log(2).y)-0.01 max(log(2).y)])
h1 = ylabel('Process Outputs');
set(h1,'FontSize',14);


end
