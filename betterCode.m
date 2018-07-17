%% Read in data
clear
dataList = dir('Ferozes data/*.txt');
%dataList = dataList(1:10);
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

    %figure(k)
%     for i=1:numtraces
%         plot(times, traceMatrix(:,i), 'b-')
%         hold on
%     end

    [artifactTimes, baselinedTraces, ~, ~, ~, ~, ~] = betterBaseline(times, traceMatrix);
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
    
    %plot(times(endIndex:end), meanTrace(endIndex:end), 'b-')
    %plot(times(maxindex:end), smoothendata, 'b-')
% %     title(titleOfGraph)
    
    [indices] = findROI(meanTrace,times, k);
    %plot(times(indices), meanTrace(indices), 'b-', 'LineWidth', 2)

%     try
%         axis([times(startIndex-50) times(indices(end)+400) meanTrace(peakIndex)-5 -meanTrace(peakIndex)+5])
%     catch
%         warning('this one is ALSO wrong lmao');
%     end
    %xdistance = (times(indices(end))-times(indices(1)));
    %rectangle('Position', [times(indices(1)) meanTrace(peakIndex)-0.1 xdistance 2*abs(meanTrace(peakIndex))])
end
