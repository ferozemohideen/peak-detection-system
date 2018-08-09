function savePlots(M, subfoldername)
%	savePlots.m 
%   written by Feroze Mohideen 
%   last edited 8/9/18
%   
%   INPUTS
%   M = map assigning each group to a set of NCV values
%   subfoldername = input .txt folder name, copied as output plot name
%
%   OUTPUTS
%   plot showing average NCV with error bars across groups, saved in 
%   '/Outputs/Images'

    % Gather groups and NCV vals from map
    k = keys(M);
    val = values(M);
    
    % Aggregate ncvs and errors
    figure(1)
    ncvs = [];
    errors = [];
    for i = 1:length(M)
        ncvs = [ncvs mean(val{i})];
        errors = [errors std(val{i})];
    end
    
    % Plot results with errorbars
    scatter(1:length(M), ncvs, 40, 'LineWidth', 2, 'MarkerEdgeColor',[0 .5 .5], ...
                  'MarkerFaceColor',[0 .7 .7])
    hold on
    errorbar(1:length(M), ncvs, errors)
    
    % Set axis limits and labels
    xlim([0, length(M) + 1]);
    ylim([0, max(ncvs+errors) + 0.1]);
    title(strcat(subfoldername, ' NCV'))
    ylabel('Mean NCV m/s')
    xlabel('Treatment')
    ax = gca;
    ax.XTick = 1:length(M);
    ax.XTickLabels = k;
    grid on;    
    
    % Save and print confirmation
    saveas(gcf, strcat('Outputs/Images/', char(subfoldername), '-scatter.png'))
    fprintf("All done!\n");
end