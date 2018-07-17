%% Function to find median

function [medtraces] = Median(tracelength, numtraces, traces)

nw = [];
medtraces = [];
for k = 1:tracelength
    for i=1:numtraces
    w = traces{i,1} (k,:);
    nw = [nw;w];
    end
    
    med = median(nw);
    nw = [];
    medtraces = [medtraces;med];
end 