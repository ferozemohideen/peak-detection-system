function [indices, amplitude, latency] = findROI(trace)
%	findROI.m (ROI = region of interest) 
%   written by Feroze Mohideen 
%   last edited 8/9/18
%   
%   INPUTS
%   trace = each individual trace of a file
%
%   OUTPUTS
%   indices = region of the peak it has guessed
%   amplitude = guessed amplitude of peak
%   latency = distance from peak to startIndex

    % Gather index parameters
    [~, startIndex, endIndex, maxindex, firstmin] = betterBaseline(trace);
    smoothingfactor = 3;    

    % Baseline wave
    wave = trace(endIndex:end)-(trace(endIndex)-trace(startIndex));
    wave = smoothdata(wave,'movmean', smoothingfactor);

    % detect peaks that are more significant than the noise
    [~, ~, wdths, proms] = findpeaks(trace(1:startIndex));
    [~, locs] = findpeaks(wave, 'MinPeakProminence', 4*mean(proms), 'MinPeakWidth', mean(wdths));
    [~, vlocs] = findpeaks(-wave, 'MinPeakProminence', 4*mean(proms), 'MinPeakWidth', mean(wdths));


    checkvec = abs(gradient(smoothdata(trace, 'movmean', smoothingfactor)));
    
    % find the peak under various conditions:
    if isempty(vlocs) % no valleys, only peak
        peak = locs(1)+endIndex;
        if abs(trace(endIndex) - trace(firstmin+maxindex)) > 1
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
            if trace(i) <= trace(indices(1))
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
        if abs(trace(endIndex) - trace(firstmin+maxindex)) > 1
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
            if trace(i) >= trace(indices(1))
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
            if abs(trace(endIndex) - trace(firstmin+maxindex)) > 1
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
                if trace(i) >= trace(indices(1))
                    passed = true;
                end
                if (checkvec(i) < 0.01 && passed) || i == peak  
                    break;
                end 
                i = i + 1;
            end

            latency = valley-startIndex;
        else % peak first
            if abs(trace(endIndex) - trace(firstmin+maxindex)) > 1
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
                if trace(i) <= trace(indices(1))
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
    values = trace(indices);
    amplitude = abs(max(values)-min(values));
end
