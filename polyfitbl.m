data = textread('ctrl myl 1.2.4.txt');
trace =  mat2cell(data, [2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000], [2]);
TanX = data(:,1);
TanY = data(:,2);

subplot(1, 2, 1);
plot(data(:,1), data(:,2), 'b-');
grid on;
baseLineIndexes = TanX > 0 & TanY < 3 & TanY > -3;
% Fit those to a line
xBaseLine = TanX(baseLineIndexes);
yBaseLine = TanY(baseLineIndexes);
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