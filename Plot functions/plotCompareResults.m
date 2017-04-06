function [ ] = plotCompareResults( log1 , log2, plot_name, inertia)
close all

textSize = 18;

log(1) = load(log1);
log(2) = load(log2);

disp('Log file loaded to "log"')
init1 = length(log(1).y)*0.33;
init2 = length(log(1).y)*0.66;
init3 = length(log(1).y);

%% ------- Outputs, PID and Errors ----------------------------------------

figure('Name', plot_name) %, 'Position', [110, 800, 1290,320]); clf;
subplot(5,1,1); hold all; grid on;
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
%h = legend('Evo', 'Manual tuning','Reference signal');
h1 = ylabel('y');
%set(h,'FontSize',textSize);
set(h1,'FontSize',textSize);

subplot(5,1,2); hold all; grid on;
plot(1:length(log(1).y),log(1).r - log(1).y,'--', 'LineWidth',1)%,'--', 'Color', 'r');
plot(1:length(log(2).y),log(1).r - log(2).y, '--', 'LineWidth',1)%,'--', 'Color', 'k');
axis([1 length(log(1).y) min(log(1).r - log(2).y) max(log(1).r - log(2).y)])
title(plot_name);
%h = legend('e Evo', 'e Manual tuning');
h1 = ylabel('e');
%set(h,'FontSize',textSize);
set(h1,'FontSize',textSize);

subplot(5,1,3); hold all; grid on;
plot(1:length(log(1).Kp),log(1).Kp,'--');
plot(1:length(log(2).Kp),log(2).Kp, '--');
axis([1 length(log(1).Kp) min(log(2).Kp)-0.01 max(log(1).Kp)])
%h = legend('Kp Evo', 'Kp Manual tuning');
h1 = ylabel('Kp');
%set(h,'FontSize',textSize);
set(h1,'FontSize',textSize);

subplot(5,1,4); hold all; grid on;
plot(2:length(log(1).MAE_blocks),log(1).MAE_blocks(2:end),'--');
plot(2:length(log(2).MAE_blocks),log(2).MAE_blocks(2:end), '--');
%h = legend('MAE/setpoint Evo', 'MAE/setpoint Manual tuning');
h1 = ylabel('MAE/sp');
%set(h,'FontSize',textSize);
set(h1,'FontSize',textSize);

subplot(5,1,5); hold all; grid on;
plot(2:length(log(1).MISE_blocks),log(1).MISE_blocks(2:end),'--');
plot(2:length(log(2).MISE_blocks),log(2).MISE_blocks(2:end), '--');
%h = legend('MISE/setpoint Evo', 'MISE/setpoint Manual tuning');
h1 = ylabel('MISE/sp');
%set(h,'FontSize',textSize);
set(h1,'FontSize',textSize);



%% ------- Outputs ----------------------------------------

if 0 == 1

    figure('Name', plot_name) %, 'Position', [110, 800, 1290,320]); clf;
    hold all; grid on;
    subplot(3,1,1); hold all; grid on;
    plot(1:init1, log(1).y(1:init1), '');
    plot(1:init1,log(2).y(1:init1), '--');
    plot(1:init1,log(1).r(1:init1));
    axis([1 init1 min(log(2).y)-0.01 max(log(2).y)])
    %h = legend('Evo', 'Manual tuning','Reference signal');
    h1 = ylabel('y inertia 1');
    %set(h,'FontSize',textSize);
    set(h1,'FontSize',textSize);

    subplot(3,1,2); hold all; grid on;
    plot(init1:init2, log(1).y(init1:init2));
    plot(init1:init2,log(2).y(init1:init2), '--');
    plot(init1:init2,log(1).r(init1:init2));
    axis([init1 init2 min(log(1).y)-0.01 max(log(1).y)])
    h1 = ylabel('y inertia 2');
    set(h1,'FontSize',textSize);

    subplot(3,1,3); hold all; grid on;
    plot(init2:init3, log(1).y(init2:init3));
    plot(init2:init3,log(2).y(init2:init3), '--');
    plot(init2:init3,log(1).r(init2:init3));
    axis([init2 init3 min(log(2).y)-0.01 max(log(2).y)])
    h1 = ylabel('y inertia 3');
    set(h1,'FontSize',textSize);

    if inertia
    plot([init1 init1],[min(log(1).y) max(log(1).y)], 'Color', 'b');
    text(init1, min(log(1).y), 'Changed inertia', 'Color', 'b', 'fontsize',8);
    plot([init2 init2],[min(log(1).y) max(log(1).y)], 'Color', 'b');
    text(init2, min(log(1).y), 'Changed inertia', 'Color', 'b', 'fontsize',8);
    end
    %title(plot_name);
    %h = legend('r', 'y1', 'y2');
    %h1 = ylabel('Process Outputs');
    %set(h,'FontSize',14);
    %set(h1,'FontSize',14);

end

%% ------- Error of different inertia ----------------------------------------

if 0==1
    figure;
    section = 100;

    subplot(1,3,1); hold all; grid on;
    plot(init1-section:init1,log(1).r(init1-section:init1) - log(1).y(init1-section:init1),'--', 'LineWidth',1)%,'--', 'Color', 'r');
    plot(init1-section:init1,log(1).r(init1-section:init1) - log(2).y(init1-section:init1), '--', 'LineWidth',1)%,'--', 'Color', 'k');
    axis([init1-section init1 min(log(1).r - log(2).y) max(log(1).r - log(2).y)])
    h1 = ylabel('e inertia 1');
    set(h1,'FontSize',textSize);


    subplot(1,3,2); hold all; grid on;
    plot(init2-section:init2,log(1).r(init2-section:init2) - log(1).y(init2-section:init2),'--', 'LineWidth',1)%,'--', 'Color', 'r');
    plot(init2-section:init2,log(1).r(init2-section:init2) - log(2).y(init2-section:init2), '--', 'LineWidth',1)%,'--', 'Color', 'k');
    axis([init2-section init2 min(log(1).r - log(2).y) max(log(1).r - log(2).y)])
    h1 = ylabel('e inertia 2');
    set(h1,'FontSize',textSize);


    subplot(1,3,3); hold all; grid on;
    plot(init3-section:init3,log(1).r(init3-section:init3) - log(1).y(init3-section:init3),'--', 'LineWidth',1)%,'--', 'Color', 'r');
    plot(init3-section:init3,log(1).r(init3-section:init3) - log(2).y(init3-section:init3), '--', 'LineWidth',1)%,'--', 'Color', 'k');
    axis([init3-section init3 min(log(1).r - log(2).y) max(log(1).r - log(2).y)])
    h1 = ylabel('e inertia 3');
    set(h1,'FontSize',textSize);
    %h = legend('Evo', 'Manual tuning');
    set(h1,'FontSize',textSize);

end

%% ------- Outputs 2 ----------------------------------------

figure('Name', plot_name) %, 'Position', [110, 800, 1290,320]); clf;
hold all; grid on;
subplot(1,2,1); hold all; grid on;
plot(200:400, log(1).y(200:400), '--');
plot(200:400,log(2).y(200:400), '--');
plot(200:400,log(1).r(200:400));
axis([200 400 min(log(2).y)-0.01 max(log(2).y)])
h1 = ylabel('y');
%set(h,'FontSize',14);
set(h1,'FontSize',textSize);

subplot(1,2,2); hold all; grid on;
plot(1800:2000, log(1).y(1800:2000), '--');
plot(1800:2000,log(2).y(1800:2000), '--');
plot(1800:2000,log(1).r(1800:2000));
axis([1800 2000 min(log(2).y)-0.01 max(log(2).y)])


end
