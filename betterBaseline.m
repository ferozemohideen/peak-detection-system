function [artifactTimes, output, startIndex, endIndex, smoothendata,maxindex, firstmin] = betterBaseline(times, traceMatrix)
    diffamount = 5;
        for i=1:size(traceMatrix, 2)
            trace = traceMatrix(:,i);
            start = find(abs(diff(trace)) > diffamount, 1);
            artifactTimes(1:2,i) = [times(start), trace(start)];
            output(:,i) = trace-mean(trace(1:start));
            averagediff = mean(abs(diff(trace(1:start))));
            maxindex = find(trace == max(trace), 1);
            smoothendata = smoothdata(trace(maxindex:end),'movmean',12);
            [~, locs] = findpeaks(-smoothendata);
            firstmin = locs(1);
            %finish = find(abs(gradient(smoothendata(firstmin+5:end))) < 0.05, 1);
            [~, locs] = findpeaks(smoothendata(firstmin:end));
            finish = locs(1);
            artifactTimes(3:4,i) = [times(finish+maxindex), trace(finish+maxindex)];
            %gradient(trace(maxindex:100+maxindex))
        end
        startIndex = start;
        endIndex = finish+maxindex+firstmin;
end
        
