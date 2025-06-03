function exportFig(imgName)
    if nargin < 1 || isempty(imgName)
        % Try to get caller name
        stack = dbstack('-completenames');
        if length(stack) >= 2
            [~, callerName] = fileparts(stack(2).file);
        else
            callerName = 'figure';
        end

        t = datetime('now','Format','yyyyMMdd_HHmmss');
        imgName = sprintf('%s_%s', callerName, char(t));
    end

    fig = gcf;
    set(fig, 'Units', 'pixels', 'Position', [100 100 643 343]); % для ворда самое то
    drawnow;

    exportgraphics(fig, [imgName '.png'], 'Resolution', 600);
end
