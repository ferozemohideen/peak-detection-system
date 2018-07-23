%% Read in data
clear
dataList = dir('ptx different conc/*.txt');
%dataList = dataList(1:10);

excelwrite = {'File', 'Amplitude','Scaled NCV'};

for k=1:length(dataList)
    data = load(dataList(k).name);
    titleOfGraph = string(dataList(k).name);
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

     figure(k)
%     for i=1:numtraces
%         plot(times, traceMatrix(:,i), 'r-')
%         hold on
%     end
    try
        [artifactTimes, baselinedTraces, ~, ~, ~, ~, ~] = betterBaseline(times, traceMatrix);
    catch   
        warning('error in calculating %s', titleOfGraph)
        excelwrite = [excelwrite; titleOfGraph, NaN, NaN];
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
     
    [indices, temp, latency] = findROI(meanTrace,times,k);
    excelwrite = [excelwrite; titleOfGraph, temp, 1/latency];
    %plot(times(indices), meanTrace(indices), 'b-', 'LineWidth', 2)

%     try
%         axis([times(startIndex-50) times(indices(end)+400) meanTrace(peakIndex)-5 -meanTrace(peakIndex)+5])

    %xdistance = (times(indices(end))-times(indices(1)));
    %rectangle('Position', [times(indices(1)) meanTrace(peakIndex)-0.1 xdistance 2*abs(meanTrace(peakIndex))])
end
%csvwrite('ctrlamplitudes', transpose(ctrlamplitudes));
%csvwrite('ctrllatencies', transpose(1./ctrllatencies));

%csvwrite('ptxamplitudes', transpose(ptxamplitudes));
%csvwrite('ptxlatencies', transpose(1./ptxlatencies));
filename = 'ptxdiffconc.xlsx';
xlswrite(filename,excelwrite)

