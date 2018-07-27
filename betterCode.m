%% Read in data
clear
dataList = dir('ptx different conc/*.txt');
%dataList = dataList(103:118);
totallatency = [];
%excelwrite = {'Group', 'Amplitude','Scaled NCV'};
excelwrite = {};
stdevs = [];


for k=1:length(dataList)
    latencylist=[];
    amplitudelist=[];
    %figure(k)
    data = load(dataList(k).name);
    titleOfGraph = string(dataList(k).name);
    temp = titleOfGraph.split();
    if temp(1) == 'ctrl'
        group = temp(1) + " " + temp(2);
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

        try
            [artifactTimes, baselinedTraces, ~, ~, ~, ~, ~] = betterBaseline(times, traceMatrix);
        catch   
            warning('error in calculating %s', titleOfGraph)
            excelwrite = [excelwrite; group, NaN, NaN];
            continue
        end
        meanTrace = mean(baselinedTraces, 2);    
        for i=1:numtraces 
            try
                [indices, amplitude, latency] = findROI(traceMatrix(:,i),times,k);
                latencylist = [latencylist latency];
                amplitudelist = [amplitudelist amplitude];
            catch
                latencylist = [latencylist];
                continue;
            end
        end
        %excelwrite = [excelwrite; group, temp, 1/latency];
        %plot(times(indices), meanTrace(indices), 'b-', 'LineWidth', 2)
        [N, edges] = histcounts(latencylist, 20);
        centers=[];
        for l=1:length(edges)-1
            centers = [centers (edges(l)+edges(l+1))/2];
        end

        % weighted average
        % totallatency = [totallatency sum(centers.*(N./sum(N)))];

        % mode
        %histogram(latencylist, 19)
    %     totallatency = [totallatency centers(find(N==max(N),1))];
    %     title(titleOfGraph + ' ' + (centers(find(N==max(N),1))))

        % median
        totallatency = [totallatency median(latencylist)];
        %title(titleOfGraph + ' ' + mode(latencylist))
        stdevs = [stdevs std(latencylist)];
        columntoadd = {group};
        for h = 1:length(latencylist)
            columntoadd = [columntoadd; latencylist(h)];
        end
        for j = 1:(300-length(latencylist))
            columntoadd = [columntoadd; NaN];
        end
        excelwrite = [excelwrite columntoadd];
    end  

end
%csvwrite('ctrlamplitudes', transpose(ctrlamplitudes));
%csvwrite('ctrllatencies', transpose(1./ctrllatencies));

%csvwrite('ptxamplitudes', transpose(ptxamplitudes));
%csvwrite('ptxlatencies', transpose(1./ptxlatencies));
filename = 'allcontrols.xlsx';
xlswrite(filename,excelwrite)
%histogram(latencylist, 20)

