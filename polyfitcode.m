%Read in data
data = textread('ctrl myl 1.2.4.txt');
Time = data(:,1);
Voltage = data(:,2);

%Figure out length & number of traces
prompt = 'How many data points are in one trace? ';
tracelength = input(prompt);    %length of one trace
numtraces = length(data)/tracelength;   %number of traces

%Bring baseline of data plot to zero

subplot(1, 2, 1);
plot(data(:,1), data(:,2), 'b-');
grid on;
baseLineIndexes = Time > 0 & Voltage < 3 & Voltage > -3;
% Fit those to a line
xBaseLine = Time(baseLineIndexes);
yBaseLine = Voltage(baseLineIndexes);
% Overlay them in red.
hold on;
plot(xBaseLine, yBaseLine, 'r.', 'LineWidth', 2);
legend('Signal', 'Base Line');
% Set up figure properties:
% Enlarge figure to full screen.
%set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
% Get rid of tool bar and pulldown menus that are along top of figure.
%set(gcf, 'Toolbar', 'none', 'Menu', 'none');
% Give a name to the title bar.
%set(gcf, 'Name', 'Demo by ImageAnalyst', 'NumberTitle', 'Off') 

% Fit a line to the baseline elements.
coefficients = polyfit(xBaseLine, yBaseLine, 1);
% Extrapolate everywhere
xFit = linspace(min(Time), max(Time), length(Time));
yFit = polyval(coefficients, xFit);

% Subtract the baseline from TanY
correctedTanY = Voltage - yFit';
% Clamp to 0
%correctedTanY = max(correctedTanY, 0);
% Plot baseline corrected
subplot(1, 2, 2);
plot(Time, correctedTanY, 'b-');
grid on;
legend('Corrected Signal');

Bdata = horzcat(Time, correctedTanY);
%Convert data to matrix of all the traces
tlmatrix = tracelength*ones(numtraces,1); %Creates a numtraces x 1 matrix of tracelength
traces =  mat2cell(Bdata, tlmatrix, 2);  %Creates a numtraces x 1 with a tracelength x 2 matrix (each trace) within each cell

%%%
new = [];
meantraces = [];

for j = 1:tracelength
    for i=1:numtraces
    y = traces{i,1} (j,:);
    new = [new;y];
    end
    
    meantrace = mean(new);
    new = [];
    meantraces = [meantraces;meantrace];
end 

figure(2)
plot(meantraces(:,1), meantraces(:,2), 'r-','LineWidth', 2)
hold on
plot (Time, Voltage, 'b-', 'LineWidth', 0.01)
