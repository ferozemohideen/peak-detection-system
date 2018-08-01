%% Read in data
clear
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
[lengths, txt, raw] = xlsread(strcat(foldername, lengthfilename));
names = [];

for i=1:length(txt)
    temp = string(txt{i});
    names = [names temp]; 
end

for k=1:length(dataList)
    data = load(strcat(foldername, subfoldername, '/', dataList(k).name));
    group = string(dataList(k).name);

    Time = data(:,1);
    Voltage = data(:,2);
    %% Figure out length & number of traces
    tracelength = 2000;
    numtraces = length(data)/tracelength;   %number of traces

    %% Bring baseline of data plot to zero
    traceMatrix = [];
    times = Time(1:2000);
    for i = 1:length(Time)/tracelength
        traceMatrix(:,i) = Voltage(2000*(i-1)+1:2000*i);
    end
    
    [artifactTimes, baselinedTraces, ~, ~, ~, ~, ~] = betterBaseline(times, traceMatrix);
    meanTrace = mean(baselinedTraces, 2);
    
    latencylist=[];
    amplitudelist=[];
    startIndexList=[];
    
    for i=1:numtraces 
        try
            [indices, amplitude, latency, startIndex] = findROI(traceMatrix(:,i),times,k);
            latencylist = [latencylist latency];
            startIndexList = [startIndexList startIndex];
            amplitudelist = [amplitudelist amplitude];
        catch
            continue;
        end
    end
        
    fprintf("Analyzing file \'%s\' (%d/%d)\n", group, k,length(dataList));
    
    index = find(names == group);
    if isempty(index)
        fprintf("Couldn't find the length of %s in the lengths file!\nTo continue without this file, press y. Otherwise, press n to exit.", group);
        letter = input(' Enter: ', 's');
        if letter == "y"
            excelwrite = [excelwrite; group, 0, 0, 0, 0];
            continue;
        else
            break;
        end
    end
        
    distance = lengths(index);
    latency = median(latencylist);
    amplitude = median(amplitudelist);
    NCV = distance/(0.05*latency);
    excelwrite = [excelwrite; group, amplitude, latency , distance, NCV];
end

filename = strcat(subfoldername, '.xlsx');
xlswrite(filename,excelwrite)
fprintf("All done!\n");



