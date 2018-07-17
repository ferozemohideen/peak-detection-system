% ------------Waveform Shape Analysis (WSA) simulation experiment------
%
% This code produces a simulated signal of interest, and a signal that has
% been scaled up or down (by 50% and 200% respectively). Three template
% signals are generated, the correct one (Temp{1}), and two with the 
% frequencies scaled by freq2 (Temp{2} and freq3 (Temp{3}). We used 2 and 
% 0.5 respetively for our simulation experiment. The following figures are
% generated: 
%
% Figure 1 shows the three template siganls.
%
% Figure 2 shows 6 examples of the signal of interest and the scaled 
% signals (subplot 1), a signal of noise (subplot 2), the sum of the 
% signals of interest and noise (subplot3) with the templates overlayed at 
% the beginning of the trace. Subplot 4 shows the WSA algorithm output 
% (WSA1, WSA2 and WSA3) for each template (subplot4) and automatically 
% detected peaks based on a threshold generated from the standard deviation
% scaled by 'ThreshScale'. The siganl of interest is also overlayed with 
% peak-to-peak values identified. All peaks of WSA outputs, as well as the
% positive and negative peaks of the siganl of interest are reported in the
% workspace. 
%
% Figure 3 plots subplot 2 so the observer can perform trained eye analysis
% (TEA)without influence of where the signals are. This also highlights the 
% difficulties of applying TEA. 
%

close all
clear all
clc;

% starting parameters:
strt=100;
samp=1000;
t=1:6000; 
ThreshScale=4;
freq2=0.65       %2;
freq3=0.7       %0.5;

% define 3 templates: Temp{1} is the standard template matched to x1,
% Temp{2} and Temp{3} are scaled by freq2 and freq3 respectively: 
x1=sin(2*pi*0.015*t);
x2=sin(2*pi*freq2*0.015*t);
x3=sin(2*pi*freq3*0.015*t);

Temp{1}=[zeros(1,strt/10), x1(1:66),zeros(1,strt/10)];
Temp{2}=[zeros(1,strt/10), x2(1:round(66/freq2)),zeros(1,strt/10)];
Temp{3}=[zeros(1,strt/10), x3(1:round(66/freq3)),zeros(1,strt/10)];

% find the max point for each template to shift the output signal (WSA)
% accordingly
for i=1:3
    [a, Temp_pk{i}]=max(Temp{i});
end

% plot the 3 templates:
figure
plot(Temp{1})
hold on
plot(Temp{2}, 'r')
plot(Temp{3}, 'g')
legend('template 1', 'template 2', 'template 3')

% define a target signal based on x1
x=[zeros(1,strt+(round(10*randn(1,1)))), 0.5*x1(1:66),zeros(1,strt+(round(10*randn(1,1)))),...
    zeros(1,strt+(round(10*randn(1,1)))), x1(1:66),zeros(1,strt+(round(10*randn(1,1)))),...
    zeros(1,strt+(round(10*randn(1,1)))), 2*x1(1:66),zeros(1,strt+(round(10*randn(1,1))))];

x=[zeros(1,500),x x x x x x];
t=t(1:size(x,2));

randn('state', 0) 
noise=0.35*randn(1, size(t,2));
noise=noise-mean(noise);
noise=noise(1:size(x,2));

figure;

y=noise+x;
h(1)=subplot (4,1,1);
plot (t, x, 'k')
ylim([-3 3])
ylabel('Amplitude (mV)')

h(2)=subplot (4,1,2);
plot (noise, 'k')
ylim([-3 3])
ylabel('Amplitude (mV)')

h(3)=subplot (4,1,3);
plot (y, 'k')
ylim([-3 3])
ylabel('Amplitude (mV)')

hold on
% plot (t, x)
plot (Temp{1}, 'b')
plot (Temp{2}, 'r')
plot (Temp{3}, 'g')

% WSA algorithm
for i=1:3
[C,LAGS] = xcorr(y,Temp{i});
WSA_C{i}=C(round(length(C)/2):end);
LAGS_C{i}=LAGS(round(length(C)/2):end);
end

% shift WSA output by latency to peak of template:
WSA{1}=[zeros(1,Temp_pk{1}),WSA_C{1}];
WSA{2}=[zeros(1,Temp_pk{2}),WSA_C{2}];
WSA{3}=[zeros(1,Temp_pk{3}),WSA_C{3}];

% plot output signals
h(4)=subplot(4,1,4);
plot (WSA{1}, 'b');
hold on
plot (WSA{2}, 'r');
plot (WSA{3}, 'g');
plot(x, 'k')
ylabel({'Cross correlation (a.u.)','Amplitude (mV)'})
xlabel('Time (ms)')
linkaxes(h,'x')

set(gcf,'Pointer','fullcrosshair')


% find peaks (magnitudes and latencies, and plot onto traces):
for i=1:3
    if i==1
        k='b.';
    elseif i==2
        k='r.';
    elseif i==3
        k='g.';
    end
    thresh{i}=ThreshScale*std(WSA{i}(Temp_pk{i}:400));
    hold on
    % plot(t, thresh{i}, k) % uncomment to see thresholds
    [pks{i}, locs{i}]=findpeaks (WSA{i}, 'MinPeakHeight', thresh{i},'MinPeakDistance',15);
    plot(locs{i}, pks{i}, k)
end



% plot the target siganl determine the true peaks and latencies:

% find max peaks:
  [pks{4}, locs{4}]=findpeaks (x, 'MinPeakHeight', 0,'MinPeakDistance',15);
    plot(locs{4}, pks{4}, 'k.')

% find min peaks: 
[pks{5}, locs{5}]=findpeaks (-x, 'MinPeakHeight', 0,'MinPeakDistance',15);
    plot(locs{5}, -pks{5}, 'k.')

legend ('WSA1', 'WSA2', 'WSA3', 'target signal')


% plot a figure to analyse using TEA. User is requested to find the latency
% of the peaks and the peak-to-peak mangnitudes of the signal based on
% their own observations:
figure
plot(y) 
title('signal for analysis')
ylabel('Amplitude (mV)')
xlabel('Time (ms)')

% display latency and magnitude results for each template and target signal
% in command window:

display ('results from template 1 (correct template):')
latency1=locs{1}
magnitude1=pks{1}

display ('results from template 2:')
latency2=locs{2}
magnitude2=pks{2}

display ('results from template 3:')
latency3=locs{3}
magnitude3=pks{3}

display ('target signal peak to peak values(without noise):')
latency4=locs{4}
magnitude4=pks{4}+pks{5}


display ('latency error (template 1 - template 2)')
freq2
latError2=locs{1}-locs{2};
latError2=reshape(latError2,6, 3)

display ('latency error (template 1 - template 3)')
freq3
latError3=locs{1}-locs{3};
latError3=reshape(latError3,6, 3)