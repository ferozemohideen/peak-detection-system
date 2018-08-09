function [foldername, subfoldername, dataList, excelwrite, totallatency, names, lengths, M] = setup()
    foldername = 'Files/';
    subfolder =  dir(foldername);
    dirFlags = [subfolder.isdir] & ~strcmp({subfolder.name},'.') & ~strcmp({subfolder.name},'..');
    subfolder = subfolder(dirFlags);
    subfoldername = subfolder(1).name;

    dataList = dir(strcat(foldername, subfoldername, '/*.txt'));
    totallatency = [];
    excelwrite = {'Group', 'Amplitude','Latency', 'Length (mm)', 'NCV (m/s)'};

    lengthfile = dir(strcat(foldername, '*.xlsx'));
    lengthfilename = lengthfile(1).name;
    [lengths, txt, ~] = xlsread(strcat(foldername, lengthfilename));
    names = [];

    for i=1:length(txt)
        temp = string(txt{i});
        names = [names temp]; 
    end

    M = containers.Map('KeyType', 'char', 'ValueType', 'any');
end