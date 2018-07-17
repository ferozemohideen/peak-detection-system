data = textread('ctrl myl 1.2.4.txt');
Time = data(:,1);
Voltage = data(:,2);

trace1 = Time(1:2000);
trace2 = Voltage(1:2000);

trace3 = Time(2001:4000);
trace4 = Voltage(2001:4000);

trace5= Time(4001:6000);
trace6 = Voltage(4001:6000);

figure(8)
mins = islocalmin(trace2);
plot(trace1,trace2,trace1(mins),trace2(mins),'r*')

figure(10)


plot(trace1, trace2, 'r-', 'MarkerSize', 20)
hold on
plot(trace3, trace4, 'g-', 'MarkerSize', 20)
hold on
plot(trace5, trace6, 'b-', 'MarkerSize', 20)



