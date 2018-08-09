function savePlots(M, subfoldername)
    k = keys(M);
    val = values(M);
    figure(1)
    ncvs = [];
    errors = [];
    for i = 1:length(M)
        ncvs = [ncvs mean(val{i})];
        errors = [errors std(val{i})];
    end
    scatter(1:length(M), ncvs, 40, 'LineWidth', 2, 'MarkerEdgeColor',[0 .5 .5], ...
                  'MarkerFaceColor',[0 .7 .7])
    hold on
    errorbar(1:length(M), ncvs, errors)

    xlim([0, length(M) + 1]);
    ylim([0, max(ncvs+errors) + 0.1]);
    title(strcat(subfoldername, ' NCV'))
    ylabel('NCV m/s')
    xlabel('Treatment')
    ax = gca;
    ax.XTick = 1:length(M);
    ax.XTickLabels = k;
    grid on;    
    saveas(gcf, strcat('Outputs/Images/', char(subfoldername), '-scatter.png'))
    fprintf("All done!\n");
end