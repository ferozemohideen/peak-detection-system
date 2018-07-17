%% Read in data
data = textread('ctrl nonmyl 1.1.2.txt');
Time = data(:,1);
Voltage = data(:,2);

%% Figure out length & number of traces
prompt = 'How many data points are in one trace? ';
tracelength = input(prompt);    %length of one trace
numtraces = length(data)/tracelength;   %number of traces

%% Bring baseline of data plot to zero
origtlmatrix = tracelength*ones(numtraces,1); %Creates a numtraces x 1 matrix of tracelength
origtraces =  mat2cell(data, origtlmatrix, 2);  %Creates a numtraces x 1 with a tracelength x 2 matrix (each trace) within each cell

Bdata = Baseline(data, numtraces, origtraces); %Calls function Baseline

figure(1)
%plot(Time, Voltage, 'b-')
%hold on
plot(Time, Bdata(:,2), 'r-')
%legend('Original', 'Baselined')

%% Convert data to matrix of all the traces
tlmatrix = tracelength*ones(numtraces,1); %Creates a numtraces x 1 matrix of tracelength
traces =  mat2cell(Bdata, tlmatrix, 2);  %Creates a numtraces x 1 with a tracelength x 2 matrix (each trace) within each cell

%% Smooth every trace
windowWidth = 4; % Whatever you want.
kernel = ones(windowWidth,1) / windowWidth;
figure(8)
fltrace =[];
for i=1:numtraces
    onetrace = traces{i,1};
    filtrace = filter(kernel,1, onetrace(:,2));
    filtraces = horzcat(onetrace(:,1), filtrace);
    fltrace = [fltrace;filtraces];
    onetrace = [];
end

plot(fltrace(:,1), fltrace(:,2))
hold on 

tlmatrix = tracelength*ones(numtraces,1); %Creates a numtraces x 1 matrix of tracelength
filteredtraces =  mat2cell(fltrace, tlmatrix, 2);  %Creates a numtraces x 1 with a tracelength x 2 matrix (each trace) within each cell

meanfilteredtrace = Mean(tracelength, numtraces, filteredtraces);

plot(meanfilteredtrace(:,1), meanfilteredtrace(:,2), 'r-', 'LineWidth', 3)

legend ('All Smoothed Traces', 'Smoothed Mean Trace')
%% Find mean of all traces
meantraces = Mean(tracelength, numtraces, traces);   %Call function 'Mean'

figure(2)
plot(meantraces(:,1), meantraces(:,2), 'r', 'MarkerSize', 10)
%hold on
%plot (Time, Voltage, 'b.')
%legend ('Mean Trace', 'Original Data')

hold on 
plot(meanfilteredtrace(:,1), meanfilteredtrace(:,2))
grid on 
legend('Mean Trace', 'Smoothed Mean Trace')

xmean = meantraces(:,1);
ymean = meantraces(:,2);

meanmins = islocalmin(meantraces(:,2));
meanmaxs = islocalmax(meantraces(:,2));
%plot(xmean,ymean,xmean(meanmaxs),ymean(meanmaxs),'r*',xmean(meanmins),ymean(meanmins), 'b*')


%% Median
medtraces = Median(tracelength, numtraces, traces);   %Call function 'Median'

%figure(4)
%plot(medtraces(:,1), medtraces(:,2), 'g.','MarkerSize', 20)
%hold on
%plot (meantraces(:,1), meantraces(:,2), 'r.','MarkerSize', 20)
%hold on
%plot (Time, Voltage, 'b.')

%legend ('Median Trace', 'Mean Trace', 'All Traces')

%% g
%figure(7)
%grid on
%meanfilt = sgolayfilt(meantraces,3,11);
%plot(meanfilt(:,1), meanfilt(:,2));

%% Find the beginning/end of artifact & of 1st peak

grad = gradient(meantraces(:,2));
figure(9)
plot(meantraces(:,1), grad)

Xartifact = find(abs(grad) > 10);
Xartifactbeg = Xartifact(1)
Xartifact2 = find(abs(grad(Xartifactbeg:tracelength)) < 0.2);
Xartifactend = Xartifact2(1) +Xartifactbeg-1
next = Xartifactend+1;

Xpeak = find((abs(grad(next:tracelength))) >= 0.2);
Xpeakbeg = Xpeak(1)+ Xartifactend

Xpeakmax = find(meanmaxs(Xpeakbeg:2000));
Xpeakend = Xpeakmax(1) + Xpeakbeg - 1

%% Find the beginning/end of artifact & of 1st peak (filtered)

gradfilt = gradient(meanfilteredtrace(:,2));
figure(5)
plot(meanfilteredtrace(:,1), gradfilt)

Xartifactf = find(abs(gradfilt) > 10);
Xartifactbegf = Xartifactf(1)
Xartifact2f = find(abs(gradfilt(Xartifactbegf:tracelength)) < 0.2);
Xartifactendf = Xartifact2f(1) +Xartifactbegf-1
nextf = Xartifactendf+1;

Xpeakf = find((abs(gradfilt(nextf:tracelength))) >= 0.2);
Xpeakbegf = Xpeakf(1)+ Xartifactendf


meanmaxsf = islocalmax(meanfilteredtrace(:,2));



%% Voltage data for each trace
z=[];
qe=[];
for i=1:numtraces
z = (traces{i,1} (:,2));
qe = horzcat(qe, z);
end
    
%% Outliers
nn = [];
outliers = [];

for j = 1:tracelength
    for i=1:numtraces
    y = traces{i,1} (j,:);
    d = y(:,2);
    nn = horzcat(nn,d);
    end
    
    TF = isoutlier(nn);
    nn = [];
    outliers = [outliers;TF];
end 

%% Find minima of each trace

minimas = Minimum(numtraces, traces, Xpeakbeg, Xpeakend);

figure(6)
plot(minimas(:,1),minimas(:,2), '.', 'MarkerSize', 20)
grid on
hold on
Amplitude = mean(minimas);

plot(Amplitude(:,1), Amplitude(:,2) , 'r.', 'MarkerSize', 20)


%% while loop to find beginning of peak

for i = Xpeakbeg:-1:1
    if ymean(i-1) < ymean(i)
       break
       i
    end 
end

beg = i

Xpeakmaxf = find(meanmaxsf((Xpeakbeg+1):2000));
Xpeakendf = Xpeakmaxf(1) + Xpeakbeg

%% minimas with inverse loop method

minimasW = Minimum(numtraces, traces, i, Xpeakendf);

figure(11)
plot(minimasW(:,1),minimasW(:,2), '.', 'MarkerSize', 20)
grid on
hold on
AmplitudeW = mean(minimasW);

plot(AmplitudeW(:,1), AmplitudeW(:,2) , 'r.', 'MarkerSize', 20)

figure(12)
hi = histogram(minimasW(:,1))
figure(14)
h = histogram(minimasW(:,1), 'BinWidth', 0.00005)

figure(15)
AmplitudeHistogram = histogram(minimasW(:,2), 'BinWidth', 0.25)

%ytest = ymean((beg<=xmean)&&(xmean<=Xpeakendf));
%xtest = (beg<=xmean)&&(xmean<=Xpeakendf);
xtest = xmean(beg:Xpeakendf);
ytest = ymean(beg:Xpeakendf);

figure(16)
plot(xmean, ymean, 'k-')
hold on
area(xtest, ytest)

Area = trapz(xtest, abs(ytest))

%% Phase Difference

% phase difference calculation

% remove the DC component
x = ymean - mean(ymean);
y = meanfilteredtrace(:,2) - mean(meanfilteredtrace(:,2));

% signals length
N = length(x);

% window preparation
win = rectwin(N);

% fft of the first signal
X = fft(x.*win);

% fft of the second signal
Y = fft(y.*win);

% phase difference calculation
[~, indx] = max(abs(X));
[~, indy] = max(abs(Y));
PhDiff = angle(Y(indy)) - angle(X(indx));

%PhDiff = PhDiff*180/pi;

% display the phase difference
PhDiffstr = num2str(PhDiff);
disp(['Phase difference Y->X = ' PhDiffstr])


%%

BVolt = Bdata(:,2);
btrace1 = BVolt(1:2000);

