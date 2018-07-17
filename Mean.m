%% Function to find mean of all traces

function [meantraces] = Mean(tracelength, numtraces, traces)

new = [];
meantraces = [];

for j = 1:tracelength
    for i=1:numtraces
    y = traces{i,1} (j,:);
    new = [new;y];
    end
    
    meantrace = mean(new);
    new = [];
    meantraces = [meantraces;meantrace];
end 