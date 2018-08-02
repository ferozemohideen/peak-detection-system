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

M = containers.Map('KeyType', 'char', 'ValueType', 'any');

for k=1:length(dataList)
    data = load(strcat(foldername, subfoldername, '/', dataList(k).name));
    group = string(dataList(k).name);
    words = lower(group);
    words = words.split();
    if words(1) == "ctrl"
        key = 'ctrl';
    else
        key = strcat(words(1), ' ', words(2));
        key = char(key);
    end
    
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
    
    if isKey(M, key)
        M(key) = [M(key) NCV];
    else
        M(key) = NCV;
    end
    
end

filename = strcat(subfoldername, '.xlsx');
filename = fullfile('/Outputs/', filename);
xlswrite(filename,excelwrite)

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



