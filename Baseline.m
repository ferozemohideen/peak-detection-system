%% Function to bring baseline to zero

function [Bdata] = Baseline(x, numtraces, origtraces)

Time = x(:,1);
Voltage = x(:,2);

sl = gradient(x);
Xartifact = find(abs(sl) > 10);  %Using gradient to find the beginning of the stimulus artifact
Xartifact1 = Xartifact(1)-2;     %Subtracting two ensures that a part of the artifact does not skew mean of noise

Bdata=[];
for i=1:numtraces
    traceTime = origtraces{i,1} (:,1);
    traceVolt = origtraces{i,1} (:,2);
    basediff = mean (traceVolt(1:Xartifact1));  % Finds the mean of the noise
    basedy = traceVolt - basediff;              % Subtract that mean from the original Voltage data
    thedata = horzcat(traceTime, basedy);
    Bdata = [Bdata;thedata];
    
end

