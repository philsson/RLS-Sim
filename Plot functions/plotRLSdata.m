
    log(1) = load('convergenceRLSZ');
    

    xLength = (1:length(log(1).y))*xScale;



        %% ------- PLot 1 ---------------------------------------------------------

        figure('Name', 'Z-axis RLS_convergenceZ', 'Position', [600 400 600 300]) %, 'Position', [110, 800, 1290,320]); clf;
        subplot(3,1,1); hold all; grid on;
        plot(xLength, log(1).r,'--', 'LineWidth',lineSize + 0.5, 'Color', Ref);
        plot(xLength, log(1).y, 'LineWidth',lineSize, 'Color', Manual)
        plot(xLength, log(1).y, 'LineWidth',lineSize,'Color', Evo)
        axis([0 max(xLength) min(log(1).y) max(log(1).y)])
        h = ylabel('y [deg/sec]');
        set(h,'FontSize',textSize+textSize_offset_y);
        set(gca,'XTickLabel','');

        subplot(3,1,2); hold all; grid on;
        stairs(xLength, log(1).rls_w1,  'LineWidth',lineSize, 'Color', 'k')%,'--', 'Color', 'k');
        stairs(xLength, log(1).rls_w2, 'LineWidth',lineSize,'Color', 'r')%,'--', 'Color', 'r');
        stairs(xLength, log(1).rls_w3, 'LineWidth',lineSize,'Color', 'm')%,'--', 'Color', 'r');
        axis([0 max(xLength) -1 7])
        h = ylabel('RLS weights');
        set(h,'FontSize',textSize+textSize_offset_y);
        set(gca,'XTickLabel','');

        subplot(3,1,3); hold all; grid on;
        stairs(xLength, log(1).Kp, 'LineWidth',lineSize,'Color', Evo)
        axis([0 max(xLength) min(log(1).Kp)-0.005 max(log(1).Kp)])
        h = ylabel('Kp');
        h1 = xlabel('Time [sec]');
        set(h,'FontSize',textSize+textSize_offset_y);
        set(h1,'FontSize',textSize)


        if get_easy_files
           saveas(gcf,'Results\RLS_convergenceZ','epsc'); 
        end