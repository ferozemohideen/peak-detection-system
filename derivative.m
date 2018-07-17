figure(12)
trace1 = meantraces;
trace1Times = trace1(:,1);
trace1Volt = trace1(:,2);
firstdev= [];
for i= 2:tracelength
    %slope = (trace1Volt(i)- trace1Volt(i-1))./ (trace1Times(i)- trace1Times(i-1));
    slope = (trace1Volt(i)- trace1Volt(i-1))/(5e-05);
    firstdev = [firstdev;slope];
    slope =[];
end

q = firstdev/(10e3);


plot(trace1(:,2), 'r')
hold on
plot(q, 'b')

hold on

secdev = [];
for i= 2:(tracelength-1)
    %slope2 = (firstdev(i)- firstdev(i-1))./ (trace1Times(i)- trace1Times(i-1));
    slope2 = (firstdev(i)- firstdev(i-1))/(5e-05);
    secdev = [secdev;slope2];
    slope2 =[];
end

p = secdev/(10e7);

plot(p, 'g')

legend ('Original', 'First Derivative', 'Second Derivative')
