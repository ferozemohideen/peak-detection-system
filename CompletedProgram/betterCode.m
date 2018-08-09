clear

% Set up vectors and file locations, compile list of input data
[foldername, subfoldername, dataList,...
    excelwrite, names, lengths, M] = setup();

% Run through the list of data
for k=1:length(dataList)
    % Extract traces from each file and assign file to group
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
    
    % Figure out length & number of traces
    tracelength = 2000;
    numtraces = length(data)/tracelength;   

    % Bring baseline of data plot to zero, find the time index of right after artifact
    traceMatrix = [];
    times = Time(1:2000);
    for i = 1:length(Time)/tracelength
        traceMatrix(:,i) = Voltage(2000*(i-1)+1:2000*i);
    end
    [baselinedTraces, ~, ~, ~, ~] = betterBaseline(traceMatrix);

    latencylist=[];
    amplitudelist=[];
    
    % Through each file, find the peak in each trace and append results
    for i=1:numtraces 
        try
            [indices, amplitude, latency] = findROI(traceMatrix(:,i));
            latencylist = [latencylist latency];
            amplitudelist = [amplitudelist amplitude];
        catch
            continue;
        end
    end
    
    % print progress
    fprintf("Analyzing file \'%s\' (%d/%d)\n", group, k,length(dataList));
    
    % Lookup length from lengths file 
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
    
    % Calculate outputs
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

% Write outputs
writeData(M, subfoldername, excelwrite);
savePlots(M, subfoldername);



