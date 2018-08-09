function [output, startIndex, endIndex, maxindex, firstmin] = betterBaseline(trace)
%	betterBaseline.m 
%   written by Feroze Mohideen 
%   last edited 8/9/18
%   
%   INPUTS
%   trace = each individual trace of a file
%
%   OUTPUTS
%   index of real trace beginning (ignoring dip in signal following
%   artifact)
%   output = matrix of each trace subtraced by its noise, making it
%   baselined
%   startIndex = start of SA, where latency is measured from
%   endIndex = end of SA, where peak detection starts
%   maxindex = index of max value, ie height of SA
%   firstmin = index right after first dip after SA
    
    % threshold for start of SA
    diffamount = 5;
        
    % find start of SA by seeing where the trace suddenly drops
    startIndex = find(abs(diff(trace)) > diffamount, 1);
    output = trace-mean(trace(1:startIndex));
    maxindex = find(trace == max(trace), 1);
    smoothendata = smoothdata(trace(maxindex:end),'movmean',12);

    % Find location of the first minimum after the SA
    [~, locs] = findpeaks(-smoothendata);
    if isempty(locs)
        firstmin = 20; % estimation in case of error
    else
        firstmin = locs(1);
    end        
    [~, locs] = findpeaks(smoothendata(firstmin:end));
    finish = locs(1);
        
    endIndex = finish+maxindex+firstmin;
end
        
