function writeData(M, subfoldername, excelwrite)
%	writeData.m 
%   written by Feroze Mohideen 
%   last edited 8/9/18
%   
%   INPUTS
%   M = map of each group to list of latencies
%   subfoldername = name of .txt folder, output will have same name
%   excelwrite = completed cells to write to the file
%
%   OUTPUTS
%   excel file saved in '/Outputs/'

    % aggregate the results of each treatment
    aggwrite = {'Treatment', 'Mean NCV (m/s)', 'Median NCV (m/s)'};
    k = keys(M);
    val = values(M);
    for i=1:length(M)
        aggwrite = [aggwrite; string(k{i}), mean(val{i}), median(val{i})];
    end

    % write excelwrite to the left side, aggwrite to the right side
    filename = strcat(subfoldername, '.xlsx');
    filename = fullfile('/Outputs/', filename);
    xlswrite(filename,excelwrite)
    xlswrite(filename, aggwrite, 1, 'G1')
end