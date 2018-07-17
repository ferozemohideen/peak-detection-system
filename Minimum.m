%% Function to find minimum of first peak of all traces

function [minimas] = Minimum(numtraces, traces, Xpeakbeg, Xpeakend)

minimas = [];
for i=1:numtraces
    onetrace = traces{i,1};
    Volt = onetrace(Xpeakbeg:Xpeakend, 1:2);
    peaktime = Volt(:,1);
    peakvolt = Volt(:,2);
    [minVal, indx] = min(peakvolt);
    xValue = peaktime(indx(1));
    minima = horzcat(xValue, minVal);
    minimas = [minimas;minima];
    minima =[];
    
end
