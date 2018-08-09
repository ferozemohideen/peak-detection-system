function writeData(M, subfoldername, excelwrite)
    aggwrite = {'Treatment', 'Mean NCV (m/s)', 'Median NCV (m/s)'};
    k = keys(M);
    val = values(M);
    for i=1:length(M)
        aggwrite = [aggwrite; string(k{i}), mean(val{i}), median(val{i})];
    end

    filename = strcat(subfoldername, '.xlsx');
    filename = fullfile('/Outputs/', filename);
    xlswrite(filename,excelwrite)
    xlswrite(filename, aggwrite, 1, 'G1')
end