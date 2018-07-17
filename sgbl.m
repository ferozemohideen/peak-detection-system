data = textread('ctrl myl 1.2.4.txt');
trace =  mat2cell(data, [2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000], [2]);


% Now smooth with a Savitzky-Golay sliding polynomial filter

figure(4);
windowWidth = 27;
polynomialOrder = 3;
smoothY = sgolayfilt(data(:,2), polynomialOrder, windowWidth);
figure(1);
plot(data(:,1), smoothY, 'b-', 'LineWidth', 2);
grid on;
