function [indices, amplitude, latency, startIndex] = findROI(meanTrace)

    % Gather index parameters
    [~, startIndex, endIndex, maxindex, firstmin] = betterBaseline(meanTrace);
    smoothingfactor = 3;    

    % Baseline wave
    wave = meanTrace(endIndex:end)-(meanTrace(endIndex)-meanTrace(startIndex));
    wave = smoothdata(wave,'movmean', smoothingfactor);

    % detect peaks that are more significant than the noise
    [~, ~, wdths, proms] = findpeaks(meanTrace(1:startIndex));
    [~, locs] = findpeaks(wave, 'MinPeakProminence', 4*mean(proms), 'MinPeakWidth', mean(wdths));
    [~, vlocs] = findpeaks(-wave, 'MinPeakProminence', 4*mean(proms), 'MinPeakWidth', mean(wdths));


    checkvec = abs(gradient(smoothdata(meanTrace, 'movmean', smoothingfactor)));

    if isempty(vlocs) % no valleys, only peak
        peak = locs(1)+endIndex;
        if abs(meanTrace(endIndex) - meanTrace(firstmin+maxindex)) > 1
            indices = endIndex:peak;
        else
            indices = [];
            for i = peak-3:-1:endIndex
                indices = [i indices];
                if checkvec(i) < 0.01  
                    break;
                end
            end
            indices = [indices indices(end)+1:peak];
        end
        %indices = indices(1):valley;
        i = peak+1;
        passed = false;
        while(1)
            indices = [indices i];
            if meanTrace(i) <= meanTrace(indices(1))
                passed = true;
            end
            if checkvec(i) < 0.01 && passed
                break;
            end 
            i = i + 1;
        end

        latency = peak-startIndex;
    elseif isempty(locs) % no peaks, only valley
        valley = vlocs(1)+endIndex;
        if abs(meanTrace(endIndex) - meanTrace(firstmin+maxindex)) > 1
            indices = endIndex:valley;
        else
            indices = [];
            for i = valley-3:-1:endIndex
                indices = [i indices];
                if checkvec(i) < 0.01  
                    break;
                end
            end
            indices = [indices indices(end)+1:valley];
        end
        i = valley + 1;
        passed = false;
        while(1)
            indices = [indices i];
            if meanTrace(i) >= meanTrace(indices(1))
                passed = true;
            end
            if checkvec(i) < 0.01 && passed
                break;
            end 
            i = i + 1;
        end

        latency = valley-startIndex;
    else
        valley = vlocs(1)+endIndex;
        peak = locs(1)+endIndex;
        if vlocs(1) < locs(1) % valley first    
            if abs(meanTrace(endIndex) - meanTrace(firstmin+maxindex)) > 1
                indices = endIndex:valley;
            else
                indices = [];
                for i = valley-3:-1:endIndex
                    indices = [i indices];
                    if checkvec(i) < 0.01  
                        break;
                    end
                end
                indices = [indices indices(end)+1:valley];
            end
            i = valley + 1;
            passed = false;
            while(1)
                indices = [indices i];
                if meanTrace(i) >= meanTrace(indices(1))
                    passed = true;
                end
                if (checkvec(i) < 0.01 && passed) || i == peak  
                    break;
                end 
                i = i + 1;
            end

            latency = valley-startIndex;
        else % peak first
            if abs(meanTrace(endIndex) - meanTrace(firstmin+maxindex)) > 1
                indices = endIndex:peak;
            else
                indices = [];
                for i = peak-3:-1:endIndex
                    indices = [i indices];
                    if checkvec(i) < 0.01  
                        break;
                    end
                end
                indices = [indices indices(end)+1:peak];
            end
            i = peak+1;
            passed = false;
            while(1)
                if meanTrace(i) <= meanTrace(indices(1))
                    passed = true;
                end
                indices = [indices i];
                if (checkvec(i) < 0.01 && passed) || i == valley 
                    break;
                end 
                i = i + 1;
            end

            latency = peak-startIndex;
        end
    end  
    values = meanTrace(indices);
    amplitude = abs(max(values)-min(values));
end
