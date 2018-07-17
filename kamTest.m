%% Read in data
clear
dataList = dir('Ferozes data/*.txt');

for k=1:length(dataList)
%% Read in data
data = textread(dataList(k).name);
Time = data(:,1);
Voltage = data(:,2);

%% Figure out length & number of traces
%prompt = 'How many data points are in one trace? ';
tracelength = 2000;    %length of one trace
numtraces = length(data)/tracelength;   %number of traces

%% Bring baseline of data plot to zero
origtlmatrix = tracelength*ones(numtraces,1); %Creates a numtraces x 1 matrix of tracelength
origtraces =  mat2cell(data, origtlmatrix, 2);  %Creates a numtraces x 1 with a tracelength x 2 matrix (each trace) within each cell

Bdata = Baseline(data, numtraces, origtraces); %Calls function Baseline

% figure(1)
% for i=0:numtraces-1
%     plot(Time(2000*i+1:2000*(i+1)), Voltage(2000*i+1:2000*(i+1)), 'b-')
%     hold on
% end
% altVoltage = Bdata(:,2);
% for i=0:numtraces-1
%     plot(Time(2000*i+1:2000*(i+1)), altVoltage(2000*i+1:2000*(i+1)), 'r-')
%     hold on
% end
% %plot(Time, Bdata(:,2), 'r-')
% legend('Original', 'Baselined')

%% Convert data to matrix of all the traces
tlmatrix = tracelength*ones(numtraces,1); %Creates a numtraces x 1 matrix of tracelength
traces =  mat2cell(Bdata, tlmatrix, 2);  %Creates a numtraces x 1 with a tracelength x 2 matrix (each trace) within each cell

%% Smooth every trace
windowWidth = 4; % Whatever you want.
kernel = ones(windowWidth,1) / windowWidth;
% figure(2)
fltrace =[];
for i=1:numtraces
    onetrace = traces{i,1};
    filtrace = filter(kernel,1, onetrace(:,2)); % Implement moving average filter on each trace
    filtraces = horzcat(onetrace(:,1), filtrace);
    fltrace = [fltrace;filtraces];
    onetrace = [];
end

% plot(fltrace(:,1), fltrace(:,2))
% hold on 
% 
 tlmatrix = tracelength*ones(numtraces,1); %Creates a numtraces x 1 matrix of tracelength
 filteredtraces =  mat2cell(fltrace, tlmatrix, 2);  %Creates a numtraces x 1 with a tracelength x 2 matrix (each trace) within each cell
% 
 meanfilteredtrace = Mean(tracelength, numtraces, filteredtraces);
% 
% plot(meanfilteredtrace(:,1), meanfilteredtrace(:,2), 'r-', 'LineWidth', 3)
% 
% legend ('All Smoothed Traces', 'Smoothed Mean Trace')

%% Find mean of all traces
meantraces = Mean(tracelength, numtraces, traces);   %Call function 'Mean'

% figure(3)
% plot(meantraces(:,1), meantraces(:,2), 'r.', 'MarkerSize', 20)
% hold on
% plot (Time, Voltage, 'b.')
% legend ('Mean Trace', 'Original Data')

xmean = meantraces(:,1);
ymean = meantraces(:,2);

meanmins = islocalmin(meantraces(:,2));   % Find local minimas
meanmaxs = islocalmax(meantraces(:,2));   % Finds local maximas


%% Median
% medtraces = Median(tracelength, numtraces, traces);   %Call function 'Median'
% 
% figure(4)
% plot(medtraces(:,1), medtraces(:,2), 'g.','MarkerSize', 20)
% hold on
% plot (meantraces(:,1), meantraces(:,2), 'r.','MarkerSize', 20)
% hold on
% plot (Time, Voltage, 'b.')
% 
% legend ('Median Trace', 'Mean Trace', 'All Traces')

%% Find the beginning/end of artifact & of 1st peak

grad = gradient(meantraces(:,2));  % Calulates gradient of mean trace

% Finds beginning and end of stimulus artifact through gradient analysis
Xartifact = find(abs(grad) > 10);  
Xartifactbeg = Xartifact(1);
Xartifact2 = find(abs(grad(Xartifactbeg:tracelength)) < 0.2);
Xartifactend = Xartifact2(1) +Xartifactbeg-1;
next = Xartifactend+1;

Xpeak = find((abs(grad(next:tracelength))) >= 0.2); % Beginning of first peak occurs at first point after artifact where gradient is larger than 0.2
Xpeakbeg = Xpeak(1)+ Xartifactend;

Xpeakmax = find(meanmaxs(Xpeakbeg:2000));  % End of first peak occurs at point after beginning of peak where there exists a local maximum
Xpeakend = Xpeakmax(1) + Xpeakbeg - 1;


%% Find the beginning/end of artifact & of 1st peak (filtered)

gradfilt = gradient(meanfilteredtrace(:,2));

Xartifactf = find(abs(gradfilt) > 10);
Xartifactbegf = Xartifactf(1);
Xartifact2f = find(abs(gradfilt(Xartifactbegf:tracelength)) < 0.2);
Xartifactendf = Xartifact2f(1) +Xartifactbegf-1;
nextf = Xartifactendf+1;

Xpeakf = find((abs(gradfilt(nextf:tracelength))) >= 0.2);
%Xpeakbegf = Xpeakf(1)+ Xartifactendf;

meanmaxsf = islocalmax(meanfilteredtrace(:,2));


%% Voltage data for each trace
% z=[];
% qe=[];
% for i=1:numtraces
% z = (traces{i,1} (:,2));
% qe = horzcat(qe, z);
% end
    
%% Outliers
% nn = [];
% outliers = [];
% 
% for j = 1:tracelength
%     for i=1:numtraces
%         y = traces{i,1} (j,:);
%         d = y(:,2);
%         nn = horzcat(nn,d);
%     end
%     
%     TF = isoutlier(nn);
%     nn = [];
%     outliers = [outliers;TF];
% end 

%% Find minima of each trace (Not filtered)

% minimas = Minimum(numtraces, traces, Xpeakbeg, Xpeakend);
% 
% figure(5)
% plot(minimas(:,1),minimas(:,2), '.', 'MarkerSize', 20)
% grid on
% hold on
% Amplitude = mean(minimas);
% 
% plot(Amplitude(:,1), Amplitude(:,2) , 'r.', 'MarkerSize', 20)

%% while loop to find beginning of peak

for i = Xpeakbeg:-1:1
    if ymean(i-1) < ymean(i)
       break
    end 
end

beg = i;

Xpeakmaxf = find(meanmaxsf((Xpeakbeg+1):2000));
Xpeakendf = Xpeakmaxf(1) + Xpeakbeg;

%% minimas with inverse loop method

% minimasW = Minimum(numtraces, traces, i, Xpeakendf);
% 
% figure(6)
% plot(minimasW(:,1),minimasW(:,2), '.', 'MarkerSize', 20)
% grid on
% hold on
% AmplitudeW = mean(minimasW);
% 
% plot(AmplitudeW(:,1), AmplitudeW(:,2) , 'r.', 'MarkerSize', 20)

%% Histograms of NCV & Amplitude
% 
% figure(7)
% hi = histogram(minimasW(:,1))
% figure(8)
% h = histogram(minimasW(:,1), 'BinWidth', 0.00005)
% 
% figure(9)
% AmplitudeHistogram = histogram(minimasW(:,2), 'BinWidth', 0.25)

%% Integral of first peak

xtest = xmean(beg:Xpeakendf);
ytest = ymean(beg:Xpeakendf);

figure(k)
plot(xmean, ymean)
%axis([xmean(beg-50) xmean(Xpeakendf+50) -30 30])
hold on
area(xtest, ytest)

Area = trapz(xtest, abs(ytest));

%% Phase Difference



end
