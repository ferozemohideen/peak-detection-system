function [indices, amplitude] = findROI(meanTrace, times)
    %figure(k)
    [~, ~, startIndex, endIndex, ~, maxindex, firstmin] = betterBaseline(times, meanTrace);
    %plot(times,meanTrace,'r-')
    %hold on
    %plot(times(maxindex:end), smoothdata(meanTrace(maxindex:end), 'movmean', 11), 'b-')
    hold on
    plot(times(startIndex), meanTrace(startIndex), 'g*', times(endIndex), meanTrace(endIndex), 'r*',...
        times(firstmin+maxindex), meanTrace(firstmin+maxindex), 'r*')
    
    wave = meanTrace(endIndex:end)-(meanTrace(endIndex)-meanTrace(startIndex));
    wave = smoothdata(wave,'movmean', 10);
    %plot(times(endIndex:end), wave, 'b-')
    [~, ~, wdths, proms] = findpeaks(meanTrace(1:startIndex));
    [~, locs] = findpeaks(wave, 'MinPeakProminence', max(proms), 'MinPeakWidth', mean(wdths));
    [~, vlocs] = findpeaks(-wave, 'MinPeakProminence', max(proms), 'MinPeakWidth', mean(wdths));
    
%     [pks, locs] = findpeaks(-meanTrace(endIndex:end),...%'MinPeakHeight', 2*max(pks), 
%                 );
    plot(times(locs+endIndex),meanTrace(locs+endIndex), 'b*', times(vlocs+endIndex), meanTrace(vlocs+endIndex), 'g*')
    %plot(times(locs+endIndex),wave(locs), 'b*', times(vlocs+endIndex), wave(vlocs), 'g*')
    axis([times(startIndex-50) times(endIndex+200) -5 5])
    
    checkvec = abs(gradient(smoothdata(meanTrace, 'movmean', 11)));
    
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
        plot(times(indices), meanTrace(indices), 'b-', 'LineWidth', 2)
        
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
        plot(times(indices), meanTrace(indices), 'b-', 'LineWidth', 2)
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
            plot(times(indices), meanTrace(indices), 'b-', 'LineWidth', 2)
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
            plot(times(indices), meanTrace(indices), 'b-', 'LineWidth', 2)
        end
    end  
    values = meanTrace(indices);
    amplitude = abs(max(values)-min(values));
end
