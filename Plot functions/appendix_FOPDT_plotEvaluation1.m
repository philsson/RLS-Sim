%------- Evaluation 1 ---------------------------------------------------



%% ------- Z axis ---------------------------------------------------------

if plot_z_axis

    log(1) = load('1EVOZ');
    log(2) = load('1FOPDTZ');

    xLength = (1:length(log(1).y))*xScale;



        %% ------- PLot 1 ---------------------------------------------------------

        figure('Name', 'Z-axis FOPDT Evalution 1', 'Position', [600 400 600 300]) %, 'Position', [110, 800, 1290,320]); clf;
        subplot(3,1,1); hold all; grid on;
        plot(xLength, log(1).r,'--', 'LineWidth',lineSize + 0.5, 'Color', Ref);
        plot(xLength, log(2).y, 'LineWidth',lineSize, 'Color', Manual)
        plot(xLength, log(1).y, 'LineWidth',lineSize,'Color', Evo)
        axis([0 max(xLength) min(log(2).y) max(log(2).y)])
        h = ylabel('y [deg/sec]');
        set(h,'FontSize',textSize+textSize_offset_y);
        set(gca,'XTickLabel','');

        subplot(3,1,2); hold all; grid on;
        stairs(xLength, log(2).u,  'LineWidth',lineSize, 'Color', Manual)%,'--', 'Color', 'k');
        stairs(xLength, log(1).u, 'LineWidth',lineSize,'Color', Evo)%,'--', 'Color', 'r');
       axis([0 max(xLength) min(log(2).u) max(log(2).u)])
        h = ylabel('u');
        set(h,'FontSize',textSize+textSize_offset_y);
        set(gca,'XTickLabel','');

        subplot(3,1,3); hold all; grid on;
        stairs(xLength, log(2).Kp,  'LineWidth',lineSize, 'Color', Manual)
        stairs(xLength, log(1).Kp, 'LineWidth',lineSize,'Color', Evo)
        axis([0 max(xLength) min(log(2).Kp) max(log(2).Kp)])
        h = ylabel('Kp');
        h1 = xlabel('Time [sec]');
        set(h,'FontSize',textSize+textSize_offset_y);
        set(h1,'FontSize',textSize)

        %saveas(gcf,'Results\Z-axis\Evaluation 1\EVO & Manual tuning\1EVOManualtuningZ');
        %saveas(gcf,'Results\Z-axis\Evaluation 1\EVO & Manual tuning\1EVOManualtuningZ','epsc');
        %saveas(gcf,'Results\Z-axis\Evaluation 1\EVO & Manual tuning\1EVOManualtuningZ','svg');

        if get_easy_files
           saveas(gcf,'Results\1EVOFOPDTZ','epsc'); 
        end



        %% ------- PLot 2 ---------------------------------------------------------

        l1 = length(xLength)/length(log(2).MISE_blocks);
        l2 = length(xLength)/length(log(2).MISE_blocks);

        figure('Name', 'Z-axis FOPDT Evalution 1') %, 'Position', [110, 800, 1290,320]); clf;
        subplot(2,1,1); hold all; grid on;
        stairs(xLength(1:l1:end), log(2).MISE_blocks, 'LineWidth',lineSize, 'Color', Manual)
        stairs(xLength(1:l1:end), log(1).MISE_blocks, 'LineWidth',lineSize,'Color', Evo)
        %axis([0 max(xLength(1:l1:end)) 0 max(log(1).MISE_blocks)+0.5])
        h = ylabel('MISE/sp');
        set(h,'FontSize',textSize+textSize_offset_y);
        set(gca,'XTickLabel','');

        subplot(2,1,2); hold all; grid on;
        stairs(xLength(1:l2:end), log(2).MAE_blocks, 'LineWidth',lineSize, 'Color', Manual)
        stairs(xLength(1:l2:end), log(1).MAE_blocks, 'LineWidth',lineSize,'Color', Evo)
        axis([0 max(xLength(1:l2:end)) 0 max(log(2).MAE_blocks)+0.2])
        h = ylabel('MAE/sp');
        h1 = xlabel('Time [sec]');
        set(h,'FontSize',textSize+textSize_offset_y);       
        set(h1,'FontSize',textSize)

%         saveas(gcf,'Results\Z-axis\Evaluation 1\EVO & Manual tuning\1EVOManualtuning_errorsZ');
%         saveas(gcf,'Results\Z-axis\Evaluation 1\EVO & Manual tuning\1EVOManualtuning_errorsZ','epsc');
%         saveas(gcf,'Results\Z-axis\Evaluation 1\EVO & Manual tuning\1EVOManualtuning_errorsZ','svg');

        if get_easy_files
           saveas(gcf,'Results\1EVOFOPDT_errorsZ','epsc');
        end
    
end