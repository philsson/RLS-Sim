%% ------- Evaluation 2 ---------------------------------------------------

global textSize;
global textSize_offset_y;
global lineSize;
global xScale;

global Ref;
global Evo;
global Manual;



log(1) = load('2EVOZ');
log(2) = load('2Manual_tuningZ');

xLength = (1:length(log(1).y))*xScale;

length1 = length(xLength)*0.33;
length2 = length(xLength)*0.66;
length3 = length(xLength);



    %% ------- PLot 1 ---------------------------------------------------------

    figure('Name', 'Z-axis Evalution 2') %, 'Position', [110, 800, 1290,320]); clf;
    subplot(3,1,1); hold all; grid on;
    plot(xLength, log(1).r,'--', 'LineWidth',lineSize + 0.5, 'Color', Ref);
    plot(xLength, log(2).y, 'LineWidth',lineSize, 'Color', Manual)
    plot(xLength, log(1).y, 'LineWidth',lineSize,'Color', Evo)
    axis([0 max(xLength) min(log(1).y) max(log(1).y)])
    h = ylabel('y [deg/sec]');
    set(h,'FontSize',textSize+textSize_offset_y);

    subplot(3,1,2); hold all; grid on;
    stairs(xLength, log(2).u,  'LineWidth',lineSize, 'Color', Manual)%,'--', 'Color', 'k');
    stairs(xLength, log(1).u, 'LineWidth',lineSize,'Color', Evo)%,'--', 'Color', 'r');
    axis([0 max(xLength) min(log(1).u) max(log(1).u)])
    h = ylabel('u');
    set(h,'FontSize',textSize+textSize_offset_y);

    subplot(3,1,3); hold all; grid on;
    stairs(xLength, log(2).Kp,  'LineWidth',lineSize, 'Color', Manual)
    stairs(xLength, log(1).Kp, 'LineWidth',lineSize,'Color', Evo)
    axis([1 max(xLength) min(log(1).Kp) max(log(1).Kp)])
    h = ylabel('Kp');
    h1 = xlabel('Time [sec]');
    set(h,'FontSize',textSize+textSize_offset_y);
    set(h1,'FontSize',textSize)
    
    %saveas(gcf,'Results\Z-axis\Evaluation 2\EVO and Manual Tuning\1EVOManualtuning');
    %saveas(gcf,'Results\Z-axis\Evaluation 2\EVO and Manual Tuning\1EVOManualtuning','epsc');
    %saveas(gcf,'Results\Z-axis\Evaluation 2\EVO and Manual Tuning\1EVOManualtuning','svg');
  
    
    
    %% ------- PLot 2 ---------------------------------------------------------

    l1 = length(xLength)/length(log(2).MISE_blocks);
    l2 = length(xLength)/length(log(2).MISE_blocks);
    
    figure('Name', 'Z-axis Evalution 2') %, 'Position', [110, 800, 1290,320]); clf;
    subplot(2,1,1); hold all; grid on;
    stairs(xLength(1:l1:end), log(2).MISE_blocks, 'LineWidth',lineSize, 'Color', Manual)
    stairs(xLength(1:l1:end), log(1).MISE_blocks, 'LineWidth',lineSize,'Color', Evo)
    axis([0 max(xLength(1:l1:end)) 0 15])
    h = ylabel('MISE/sp');
    set(h,'FontSize',textSize+textSize_offset_y);
    
    subplot(2,1,2); hold all; grid on;
    stairs(xLength(1:l1:end), log(2).MAE_blocks, 'LineWidth',lineSize, 'Color', Manual)
    stairs(xLength(1:l1:end), log(1).MAE_blocks, 'LineWidth',lineSize,'Color', Evo)
    axis([0 max(xLength(1:l1:end)) 0 3])
    h = ylabel('MAE/sp');
    h1 = xlabel('Time [sec]');
    set(h,'FontSize',textSize+textSize_offset_y);
    set(h1,'FontSize',textSize)
    
    
%     saveas(gcf,'Results\Z-axis\Evaluation 2\EVO and Manual Tuning\1EVOManualtuning_errors');
%     saveas(gcf,'Results\Z-axis\Evaluation 2\EVO and Manual Tuning\1EVOManualtuning_errors','epsc');
%     saveas(gcf,'Results\Z-axis\Evaluation 2\EVO and Manual Tuning\1EVOManualtuning_errors','svg');



    %% ------- PLot 3 ---------------------------------------------------------

    inertia_offset = 100;
    
    figure('Name', 'Z-axis Evalution 2') %, 'Position', [110, 800, 1290,320]); clf;
    subplot(1,3,1); hold all; grid on;
    plot((length1-inertia_offset:length1)*xScale, log(2).r(length1-inertia_offset:length1) - log(2).y(length1-inertia_offset:length1), 'LineWidth',lineSize, 'Color', Manual)
    plot((length1-inertia_offset:length1)*xScale, log(2).r(length1-inertia_offset:length1) - log(1).y(length1-inertia_offset:length1), 'LineWidth',lineSize,'Color', Evo)
    axis([(length1-inertia_offset)*xScale length1*xScale -11 11]);
    h = ylabel({'y [deg/sec]'; 'Inertia 1'});
    set(h,'FontSize',textSize+textSize_offset_y);
    
    subplot(1,3,2); hold all; grid on;
    plot((length2-inertia_offset:length2)*xScale, log(2).r(length2-inertia_offset:length2) - log(2).y(length2-inertia_offset:length2), 'LineWidth',lineSize, 'Color', Manual)
    plot((length2-inertia_offset:length2)*xScale, log(2).r(length2-inertia_offset:length2) - log(1).y(length2-inertia_offset:length2), 'LineWidth',lineSize,'Color', Evo)
    axis([(length2-inertia_offset)*xScale length2*xScale -11 11]);
    h = ylabel({'Inertia 2'});
    h1 = xlabel('Time [sec]');
    set(h,'FontSize',textSize+textSize_offset_y);
    set(h1,'FontSize',textSize)

    subplot(1,3,3); hold all; grid on;
    plot((length3-inertia_offset:length3)*xScale, log(2).r(length3-inertia_offset:length3) - log(2).y(length3-inertia_offset:length3), 'LineWidth',lineSize, 'Color', Manual)
    plot((length3-inertia_offset:length3)*xScale, log(2).r(length3-inertia_offset:length3) - log(1).y(length3-inertia_offset:length3), 'LineWidth',lineSize,'Color', Evo)
    axis([(length3-inertia_offset)*xScale length3*xScale -11 11]);
    h = ylabel({'Inertia 3'});
    set(h,'FontSize',textSize+textSize_offset_y);       
    

    %saveas(gcf,'Results\Z-axis\Evaluation 2\EVO and Manual Tuning\1EVOManualtuning');
    %saveas(gcf,'Results\Z-axis\Evaluation 2\EVO and Manual Tuning\1EVOManualtuning','epsc');
    %saveas(gcf,'Results\Z-axis\Evaluation 2\EVO and Manual Tuning\1EVOManualtuning','svg');
   