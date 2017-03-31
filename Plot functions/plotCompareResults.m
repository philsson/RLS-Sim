function [ ] = plotCompareResults( log1 , log2, plot_name, inertia)

log(1) = load(log1);
log(2) = load(log2);

disp('Log file loaded to "log"')
init1 = length(log(1).y)*0.33;
init2 = length(log(1).y)*0.66;

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
legend('y Evo', 'y Manual tuning','r Reference signal');
ylabel('Process Outputs');

subplot(4,1,2); hold all; grid on;
plot(1:length(log(1).Kp),log(1).Kp,'--');
plot(1:length(log(2).Kp),log(2).Kp, '--');
axis([1 length(log(1).Kp) min(log(2).Kp)-0.01 max(log(1).Kp)])
legend('Kp Evo', 'Kp Manual tuning');
ylabel('PID values');

subplot(4,1,3); hold all; grid on;
plot(2:length(log(1).MAE_blocks),log(1).MAE_blocks(2:end),'--');
plot(2:length(log(2).MAE_blocks),log(2).MAE_blocks(2:end), '--');
legend('MAE/setpoint Evo', 'MAE/setpoint Manual tuning');
ylabel('MAE');

subplot(4,1,4); hold all; grid on;
plot(2:length(log(1).MISE_blocks),log(1).MISE_blocks(2:end),'--');
plot(2:length(log(2).MISE_blocks),log(2).MISE_blocks(2:end), '--');
legend('MISE/setpoint Evo', 'MISE/setpoint Manual tuning');
ylabel('MISE/setpoint');



%% ------- Outputs ----------------------------------------

figure('Name', plot_name) %, 'Position', [110, 800, 1290,320]); clf;
hold all; grid on;
plot(1:length(log(1).r),log(1).r);
plot(1:length(log(1).y),log(1).y);
plot(1:length(log(2).y),log(2).y, '--');
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
