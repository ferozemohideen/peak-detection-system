function [foldername, subfoldername, dataList, excelwrite, names, lengths, M] = setup()
%	setup.m 
%   written by Feroze Mohideen 
%   last edited 8/9/18
%
%   OUTPUTS
%   foldername = folder of inputs
%   subfoldername = folder of .txt files in folder
%   dataList = list of all .txt files to analyze from folder
%   excelwrite = beginning of aggregate excel data, just section titles for
%   now
%   names = name of each text file
%   lengths = lengths extracted from lengths file
%   M = map which maps each treatment to a list of NCVs

    % gather inputs from files
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
    
    % construct map to be filled in later
    M = containers.Map('KeyType', 'char', 'ValueType', 'any');
end