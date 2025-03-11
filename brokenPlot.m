function t = brokenPlot(p, xdata, y1data, y2data)

    if min(y1data) < max(y2data)
        temp = y1data;
        y1data = y2data;
        y2data = temp;
    end
    % Create a tiled layout with no space between tiles
    t = tiledlayout(p, 2, 1, 'TileSpacing', 'none', 'Padding', 'compact');
    
    % First plot
    nexttile
    hold on
    plot(xdata, y1data);
    set(gca, 'Box', 'off', 'XColor', 'none'); % Hide the box and x-axis line
    
    % Automatically compute y-limits based on data, leaving some margin
    ylim1 = [min(y1data) - 0.1 * range(y1data), ...
             max(y1data) + 0.1 * range(y1data)];
    gap = 0.1 * range(y1data); % Define a gap range as a portion of the total range
    set(gca, 'YLim', [ylim1(1) - gap, ylim1(2) + gap]); % Adjust upper plot limit
    
    % Adjust y-ticks to avoid overlap at the connection point
    yticks(gca, linspace(ylim1(1), ylim1(2), 5));
    plot(xlim, [ylim1(1) ylim1(1)], '--', 'Color',[0.5 0.5 0.5]);
    hold off
    grid on
    % Second plot
    nexttile
    hold on
    plot(xdata, y2data, "Color",[0.8500 0.3250 0.0980]);
    set(gca, 'Box', 'off'); % Hide the box
    
    % Automatically compute y-limits based on data, leaving some margin
    ylim2 = [min(y2data) - 0.1 * range(y2data), ...
             max(y2data) + 0.1 * range(y2data)];
    gap = 0.1 * range(y1data); % Define a gap range as a portion of the total range
    set(gca, 'YLim', [ylim2(1) - gap, ylim2(2) + gap]); % Adjust upper plot limit
    
    % Adjust y-ticks to avoid overlap at the connection point
    yticks(gca, linspace(ylim2(1), ylim2(2), 5));
    plot(xlim, [ylim2(2) ylim2(2)], '--', 'Color',[0.5 0.5 0.5]);
    hold off
    grid on
end

