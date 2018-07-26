%% Read in data
clear
dataList = dir('ptx different conc/*.txt');
dataList = dataList(103:118);
totallatency = [];
excelwrite = {'Group', 'Amplitude','Scaled NCV'};
stdevs = [];

amplitudelist=[];
for k=1:length(dataList)
    latencylist=[];
    figure(k)
    data = load(dataList(k).name);
    titleOfGraph = string(dataList(k).name);
    temp = titleOfGraph.split();
    if temp(1) ~= 'ctrl'
        group = temp(1) + " " + temp(2);
    else
        group = temp(1);
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

     %figure(k)
%     for i=1:numtraces
%         plot(times, traceMatrix(:,i), 'r-')
%         hold on
%     end
    try
        [artifactTimes, baselinedTraces, ~, ~, ~, ~, ~] = betterBaseline(times, traceMatrix);
    catch   
        warning('error in calculating %s', titleOfGraph)
        excelwrite = [excelwrite; group, NaN, NaN];
        continue
    end
    % for i=1:length(artifactTimes)
    %     plot(artifactTimes(1,i), artifactTimes(2,i),  'r.')
    %     hold on
    % end
    % for i=1:size(baselinedTraces,2)
    %     plot(times, baselinedTraces(:,i), 'r-')
    %     hold on
    % end
    % for i=1:length(artifactTimes)
    %     plot(artifactTimes(3,i), artifactTimes(4,i),  'r.')
    %     hold on
    % end
    meanTrace = mean(baselinedTraces, 2);    
    for i=1:numtraces 
        try
            [indices, amplitude, latency] = findROI(traceMatrix(:,i),times,k);
            latencylist = [latencylist latency];
            amplitudelist = [amplitudelist amplitude];
        catch
            continue;
        end
    end
    %excelwrite = [excelwrite; group, temp, 1/latency];
    %plot(times(indices), meanTrace(indices), 'b-', 'LineWidth', 2)
    [N, edges] = histcounts(latencylist, 19);
    centers=[];
    for l=1:length(edges)-1
        centers = [centers (edges(l)+edges(l+1))/2];
    end
    
    % weighted average
    % totallatency = [totallatency sum(centers.*(N./sum(N)))];
    
    % mode
    histogram(latencylist, 19)
%     totallatency = [totallatency centers(find(N==max(N),1))];
%     title(titleOfGraph + ' ' + (centers(find(N==max(N),1))))
    
    % median
    totallatency = [totallatency median(latencylist)];
    title(titleOfGraph + ' ' + mode(latencylist))
    stdevs = [stdevs std(latencylist)];
end
%csvwrite('ctrlamplitudes', transpose(ctrlamplitudes));
%csvwrite('ctrllatencies', transpose(1./ctrllatencies));

%csvwrite('ptxamplitudes', transpose(ptxamplitudes));
%csvwrite('ptxlatencies', transpose(1./ptxlatencies));
filename = 'ptxdiffconc.xlsx';
%xlswrite(filename,excelwrite)
%histogram(latencylist, 20)

