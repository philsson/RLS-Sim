%-------- Evaluation 3 ---------------------------------------------------



%% ------- Z axis ---------------------------------------------------------

if plot_z_axis

    log(1) = load('3EVOZ');
    log(2) = load('3IPDZ');

    xLength = (1:length(log(1).y))*xScale;

    length1 = length(xLength)*0.33;
    length2 = length(xLength)*0.66;
    length3 = length(xLength);



        %% ------- PLot 1 ---------------------------------------------------------

        figure('Name', 'Z-axis IPD Evalution 3') %, 'Position', [110, 800, 1290,320]); clf;
        subplot(3,1,1); hold all; grid on;
        plot(xLength, log(1).r,'--', 'LineWidth',lineSize + 0.5, 'Color', Ref);
        plot(xLength, log(2).y, 'LineWidth',lineSize, 'Color', Manual)
        plot(xLength, log(1).y, 'LineWidth',lineSize,'Color', Evo)
        axis([0 max(xLength) min(log(1).y) max(log(1).y)])
        h = ylabel('y [deg/sec]');
        set(h,'FontSize',textSize+textSize_offset_y);
        set(gca,'XTickLabel','');

        subplot(3,1,2); hold all; grid on;
        stairs(xLength, log(2).u,  'LineWidth',lineSize, 'Color', Manual)%,'--', 'Color', 'k');
        stairs(xLength, log(1).u, 'LineWidth',lineSize,'Color', Evo)%,'--', 'Color', 'r');
        axis([0 max(xLength) min(log(1).u)-0.3 max(log(1).u)+0.3])
        h = ylabel('u');
        set(h,'FontSize',textSize+textSize_offset_y);
        set(gca,'XTickLabel','');

        subplot(3,1,3); hold all; grid on;
        stairs(xLength, log(2).Kp,  'LineWidth',lineSize, 'Color', Manual)
        stairs(xLength, log(1).Kp, 'LineWidth',lineSize,'Color', Evo)
        axis([1 max(xLength) min(log(1).Kp) max(log(1).Kp)+0.005])
        h = ylabel('Kp');
        h1 = xlabel('Time [sec]');
        set(h,'FontSize',textSize+textSize_offset_y);
        set(h1,'FontSize',textSize)

%          saveas(gcf,'Results\Z-axis\Evaluation 3\EVO and Manual Tuning\3EVOManualtuningZ');
%          saveas(gcf,'Results\Z-axis\Evaluation 3\EVO and Manual Tuning\3EVOManualtuningZ','epsc');
%          saveas(gcf,'Results\Z-axis\Evaluation 3\EVO and Manual Tuning\3EVOManualtuningZ','svg');

        if get_easy_files
           saveas(gcf,'Results\3EVOIPDZ','epsc');
        end

        %% ------- PLot 2 ---------------------------------------------------------

        l1 = length(xLength)/length(log(2).MISE_blocks);
        l2 = length(xLength)/length(log(2).MISE_blocks);

        figure('Name', 'Z-axis IPD Evalution 3') %, 'Position', [110, 800, 1290,320]); clf;
        subplot(2,1,1); hold all; grid on;
        stairs(xLength(1:l1:end), log(2).MISE_blocks, 'LineWidth',lineSize, 'Color', Manual)
        stairs(xLength(1:l1:end), log(1).MISE_blocks, 'LineWidth',lineSize,'Color', Evo)
        axis([0 max(xLength(1:l1:end)) 0 32])
        h = ylabel('MISE/sp');
        set(h,'FontSize',textSize+textSize_offset_y);
        set(gca,'XTickLabel','');

        subplot(2,1,2); hold all; grid on;
        stairs(xLength(1:l1:end), log(2).MAE_blocks, 'LineWidth',lineSize, 'Color', Manual)
        stairs(xLength(1:l1:end), log(1).MAE_blocks, 'LineWidth',lineSize,'Color', Evo)
        axis([0 max(xLength(1:l1:end)) 0 5])
        h = ylabel('MAE/sp');
        h1 = xlabel('Time [sec]');
        set(h,'FontSize',textSize+textSize_offset_y);
        set(h1,'FontSize',textSize)



%         saveas(gcf,'Results\Z-axis\Evaluation 3\EVO and Manual Tuning\3EVOManualtuning_errorsZ');
%         saveas(gcf,'Results\Z-axis\Evaluation 3\EVO and Manual Tuning\3EVOManualtuning_errorsZ','epsc');
%         saveas(gcf,'Results\Z-axis\Evaluation 3\EVO and Manual Tuning\3EVOManualtuning_errorsZ','svg');


        if get_easy_files
           saveas(gcf,'Results\3EVOIPD_errorsZ','epsc');
        end

        %% ------- PLot 3 ---------------------------------------------------------

        inertia_offset = 100;

        figure('Name', 'Z-axis IPD Evalution 3') %, 'Position', [110, 800, 1290,320]); clf;
        subplot(2,2,1); hold all; grid on;
        plot((length1-inertia_offset:length1)*xScale, log(2).r(length1-inertia_offset:length1),'--', 'LineWidth',lineSize, 'Color', Ref)
        plot((length1-inertia_offset:length1)*xScale, log(2).y(length1-inertia_offset:length1), 'LineWidth',lineSize, 'Color', Manual)
        plot((length1-inertia_offset:length1)*xScale, log(1).y(length1-inertia_offset:length1), 'LineWidth',lineSize,'Color', Evo)
        axis([(length1-inertia_offset)*xScale length1*xScale -11 11]);
        h = ylabel({'y [deg/sec]'; 'Battery ~90%'});
        set(h,'FontSize',textSize+textSize_offset_y);
        set(gca,'XTickLabel','');

        subplot(2,2,2); hold all; grid on;
        plot((length3-inertia_offset:length3)*xScale, log(2).r(length3-inertia_offset:length3),'--', 'LineWidth',lineSize, 'Color', Ref)
        plot((length3-inertia_offset:length3)*xScale, log(2).y(length3-inertia_offset:length3), 'LineWidth',lineSize, 'Color', Manual)
        plot((length3-inertia_offset:length3)*xScale, log(1).y(length3-inertia_offset:length3), 'LineWidth',lineSize,'Color', Evo)
        axis([(length3-inertia_offset)*xScale length3*xScale -11 11]);
        h = ylabel({'Battery ~60%'});
        set(h,'FontSize',textSize+textSize_offset_y);   
        set(gca,'YTickLabel','')
        set(gca,'XTickLabel','');

        subplot(2,2,3); hold all; grid on;
        plot((length1-inertia_offset:length1)*xScale, log(2).r(length1-inertia_offset:length1) - log(2).y(length1-inertia_offset:length1), 'LineWidth',lineSize, 'Color', Manual)
        plot((length1-inertia_offset:length1)*xScale, log(2).r(length1-inertia_offset:length1) - log(1).y(length1-inertia_offset:length1), 'LineWidth',lineSize,'Color', Evo)
        axis([(length1-inertia_offset)*xScale length1*xScale -11 11]);
        h = ylabel({'error'; 'Battery ~90%'});
        set(h,'FontSize',textSize+textSize_offset_y);
        h1 = xlabel('Time [sec]');
        set(h1,'FontSize',textSize); 

        subplot(2,2,4); hold all; grid on;
        plot((length3-inertia_offset:length3)*xScale, log(2).r(length3-inertia_offset:length3) - log(2).y(length3-inertia_offset:length3), 'LineWidth',lineSize, 'Color', Manual)
        plot((length3-inertia_offset:length3)*xScale, log(2).r(length3-inertia_offset:length3) - log(1).y(length3-inertia_offset:length3), 'LineWidth',lineSize,'Color', Evo)
        axis([(length3-inertia_offset)*xScale length3*xScale -11 11]);
        h = ylabel({'Battery ~60%'});
        set(h,'FontSize',textSize+textSize_offset_y);   
        set(gca,'YTickLabel','');
        h1 = xlabel('Time [sec]');
        set(h1,'FontSize',textSize); 

%         saveas(gcf,'Results\Z-axis\Evaluation 3\EVO and Manual Tuning\3EVOManualtuning_inertiaZ');
%         saveas(gcf,'Results\Z-axis\Evaluation 3\EVO and Manual Tuning\3EVOManualtuning_inertiaZ','epsc');
%         saveas(gcf,'Results\Z-axis\Evaluation 3\EVO and Manual Tuning\3EVOManualtuning_inertiaZ','svg');

        if get_easy_files
           saveas(gcf,'Results\3EVOIPD_inertiaZ','epsc');
        end
   
end







%% ------- X axis ---------------------------------------------------------

if plot_x_axis

    log(1) = load('3EVOX');
    log(2) = load('3IPDX');

    xLength = (1:length(log(1).y))*xScale;

    length1 = length(xLength)*0.33;
    length2 = length(xLength)*0.66;
    length3 = length(xLength);



        %% ------- PLot 1 ---------------------------------------------------------

        figure('Name', 'X-axis IPD Evalution 3') %, 'Position', [110, 800, 1290,320]); clf;
        subplot(3,1,1); hold all; grid on;
        plot(xLength, log(1).r,'--', 'LineWidth',lineSize + 0.5, 'Color', Ref);
        plot(xLength, log(2).y, 'LineWidth',lineSize, 'Color', Manual)
        plot(xLength, log(1).y, 'LineWidth',lineSize,'Color', Evo)
        axis([0 max(xLength) min(log(1).y) max(log(1).y)])
        h = ylabel('y [deg/sec]');
        set(h,'FontSize',textSize+textSize_offset_y);
        set(gca,'XTickLabel','');

        subplot(3,1,2); hold all; grid on;
        stairs(xLength, log(2).u,  'LineWidth',lineSize, 'Color', Manual)%,'--', 'Color', 'k');
        stairs(xLength, log(1).u, 'LineWidth',lineSize,'Color', Evo)%,'--', 'Color', 'r');
        axis([0 max(xLength) min(log(1).u) max(log(1).u)])
        h = ylabel('u');
        set(h,'FontSize',textSize+textSize_offset_y);
        set(gca,'XTickLabel','');

        subplot(3,1,3); hold all; grid on;
        stairs(xLength, log(2).Kp,  'LineWidth',lineSize, 'Color', Manual)
        stairs(xLength, log(1).Kp, 'LineWidth',lineSize,'Color', Evo)
        axis([1 max(xLength) min(log(1).Kp) max(log(1).Kp)])
        h = ylabel('Kp');
        h1 = xlabel('Time [sec]');
        set(h,'FontSize',textSize+textSize_offset_y);
        set(h1,'FontSize',textSize)

%          saveas(gcf,'Results\X-axis\Evaluation 3\EVO and Manual Tuning\3EVOManualtuningX');
%          saveas(gcf,'Results\X-axis\Evaluation 3\EVO and Manual Tuning\3EVOManualtuningX','epsc');
%          saveas(gcf,'Results\X-axis\Evaluation 3\EVO and Manual Tuning\3EVOManualtuningX','svg');

        if get_easy_files
           saveas(gcf,'Results\3EVOIPDX','epsc');
        end

        %% ------- PLot 2 ---------------------------------------------------------

        l1 = length(xLength)/length(log(2).MISE_blocks);
        l2 = length(xLength)/length(log(2).MISE_blocks);

        figure('Name', 'X-axis IPD Evalution 3') %, 'Position', [110, 800, 1290,320]); clf;
        subplot(2,1,1); hold all; grid on;
        stairs(xLength(1:l1:end), log(2).MISE_blocks, 'LineWidth',lineSize, 'Color', Manual)
        stairs(xLength(1:l1:end), log(1).MISE_blocks, 'LineWidth',lineSize,'Color', Evo)
        axis([0 max(xLength(1:l1:end)) 0 20])
        h = ylabel('MISE/sp');
        set(h,'FontSize',textSize+textSize_offset_y);
        set(gca,'XTickLabel','');

        subplot(2,1,2); hold all; grid on;
        stairs(xLength(1:l1:end), log(2).MAE_blocks, 'LineWidth',lineSize, 'Color', Manual)
        stairs(xLength(1:l1:end), log(1).MAE_blocks, 'LineWidth',lineSize,'Color', Evo)
        axis([0 max(xLength(1:l1:end)) 0 10])
        h = ylabel('MAE/sp');
        h1 = xlabel('Time [sec]');
        set(h,'FontSize',textSize+textSize_offset_y);
        set(h1,'FontSize',textSize)



%         saveas(gcf,'Results\X-axis\Evaluation 3\EVO and Manual Tuning\3EVOManualtuning_errorsX');
%         saveas(gcf,'Results\X-axis\Evaluation 3\EVO and Manual Tuning\3EVOManualtuning_errorsX','epsc');
%         saveas(gcf,'Results\X-axis\Evaluation 3\EVO and Manual Tuning\3EVOManualtuning_errorsX','svg');


        if get_easy_files
           saveas(gcf,'Results\3EVOIPD_errorsX','epsc');
        end

        %% ------- PLot 3 ---------------------------------------------------------

        inertia_offset = 100;

        figure('Name', 'X-axis IPD Evalution 3') %, 'Position', [110, 800, 1290,320]); clf;
        subplot(2,2,1); hold all; grid on;
        plot((length1-inertia_offset:length1)*xScale, log(2).r(length1-inertia_offset:length1),'--', 'LineWidth',lineSize, 'Color', Ref)
        plot((length1-inertia_offset:length1)*xScale, log(2).y(length1-inertia_offset:length1), 'LineWidth',lineSize, 'Color', Manual)
        plot((length1-inertia_offset:length1)*xScale, log(1).y(length1-inertia_offset:length1), 'LineWidth',lineSize,'Color', Evo)
        axis([(length1-inertia_offset)*xScale length1*xScale -11 11]);
        h = ylabel({'y [deg/sec]'; 'Battery ~90%'});
        set(h,'FontSize',textSize+textSize_offset_y);
        set(gca,'XTickLabel','');

        subplot(2,2,2); hold all; grid on;
        plot((length3-inertia_offset:length3)*xScale, log(2).r(length3-inertia_offset:length3),'--', 'LineWidth',lineSize, 'Color', Ref)
        plot((length3-inertia_offset:length3)*xScale, log(2).y(length3-inertia_offset:length3), 'LineWidth',lineSize, 'Color', Manual)
        plot((length3-inertia_offset:length3)*xScale, log(1).y(length3-inertia_offset:length3), 'LineWidth',lineSize,'Color', Evo)
        axis([(length3-inertia_offset)*xScale length3*xScale -11 11]);
        h = ylabel({'Battery ~60%'});
        set(h,'FontSize',textSize+textSize_offset_y);   
        set(gca,'YTickLabel','')
        set(gca,'XTickLabel','');

        subplot(2,2,3); hold all; grid on;
        plot((length1-inertia_offset:length1)*xScale, log(2).r(length1-inertia_offset:length1) - log(2).y(length1-inertia_offset:length1), 'LineWidth',lineSize, 'Color', Manual)
        plot((length1-inertia_offset:length1)*xScale, log(2).r(length1-inertia_offset:length1) - log(1).y(length1-inertia_offset:length1), 'LineWidth',lineSize,'Color', Evo)
        axis([(length1-inertia_offset)*xScale length1*xScale -11 11]);
        h = ylabel({'error'; 'Battery ~90%'});
        set(h,'FontSize',textSize+textSize_offset_y);
        h1 = xlabel('Time [sec]');
        set(h1,'FontSize',textSize); 

        subplot(2,2,4); hold all; grid on;
        plot((length3-inertia_offset:length3)*xScale, log(2).r(length3-inertia_offset:length3) - log(2).y(length3-inertia_offset:length3), 'LineWidth',lineSize, 'Color', Manual)
        plot((length3-inertia_offset:length3)*xScale, log(2).r(length3-inertia_offset:length3) - log(1).y(length3-inertia_offset:length3), 'LineWidth',lineSize,'Color', Evo)
        axis([(length3-inertia_offset)*xScale length3*xScale -11 11]);
        h = ylabel({'Battery ~60%'});
        set(h,'FontSize',textSize+textSize_offset_y);   
        set(gca,'YTickLabel','');
        h1 = xlabel('Time [sec]');
        set(h1,'FontSize',textSize); 

%         saveas(gcf,'Results\X-axis\Evaluation 3\EVO and Manual Tuning\3EVOManualtuning_inertiaX');
%         saveas(gcf,'Results\X-axis\Evaluation 3\EVO and Manual Tuning\3EVOManualtuning_inertiaX','epsc');
%         saveas(gcf,'Results\X-axis\Evaluation 3\EVO and Manual Tuning\3EVOManualtuning_inertiaX','svg');

        if get_easy_files
           saveas(gcf,'Results\3EVOIPD_inertiaX','epsc');
        end
   
end