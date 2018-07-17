data = textread('ctrl myl 1.2.4.txt');
trace =  mat2cell(data, [2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000], [2]);
new = [];
menf = [];
nw = [];
medf = [];

for j = 1:2000
    for i=1:50
    y = trace{i,1} (j,:);
    new = [new;y];
    end
    
    men = mean(new);
    menf = [menf;men];
end 



for k = 1:2000
    for i=1:50
    w = trace{i,1} (k,:);
    nw = [nw;w];
    end
    
    med = median(nw);
    medf = [medf;med];
end 
TanX = trace{1,1} (:,1);
TanY = menf(:,2);

figure(1)
plot(data(:,1), data(:,2))

figure(2)
plot(trace{1,1} (:,1), menf(:,2))

%figure(3)
%plot(trace{1,1} (:,1), medf(:,2))

% Now smooth with a Savitzky-Golay sliding polynomial filter

%figure(4);
%windowWidth = 27;
%polynomialOrder = 3;
%smoothY = sgolayfilt(menf(:,2), polynomialOrder, windowWidth);
%plot(menf(:,1), smoothY, 'b-', 'LineWidth', 2);
%grid on;

TanX = trace{1,1} (:,1);
TanY = menf(:,2);
figure(4);
subplot(1, 2, 1);
plot(TanX, TanY, 'b-');
grid on;
baseLineIndexes = TanX > 0 & TanY >-0.1 & TanY<-0.05;
% Fit those to a line
xBaseLine = TanX(baseLineIndexes);
yBaseLine = TanY(baseLineIndexes);
% Overlay them in red.
hold on;
plot(xBaseLine, yBaseLine, 'r.', 'LineWidth', 2);
legend('Signal', 'Base Line');

% Fit a line to the baseline elements.
coefficients = polyfit(xBaseLine, yBaseLine, 1);
% Extrapolate everywhere
xFit = linspace(min(TanX), max(TanX), length(TanX));
yFit = polyval(coefficients, xFit);

% Subtract the baseline from TanY
correctedTanY = TanY - yFit';
% Clamp to 0
%correctedTanY = max(correctedTanY, 0);
% Plot baseline corrected
subplot(1, 2, 2);
plot(TanX, correctedTanY, 'b-');
grid on;
legend('Corrected Signal');
