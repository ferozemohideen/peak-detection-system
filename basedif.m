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

figure(1)
plot(data(:,1), data(:,2))

figure(2) 
plot(trace{1,1} (:,1), menf(:,2))

Xmean = trace{1,1} (:,1);
Ymean = menf(:,2);

basediff1 = mean (Ymean(1:800));
basediff2 = mean (Ymean(100:800));
basedy1 = Ymean - basediff1;
basedy2 = Ymean - basediff2;

figure(3)
subplot(1, 3, 1);
plot(Xmean, Ymean)
subplot(1,3,2);
plot (Xmean, basedy1)
subplot(1,3,3);
plot (Xmean, basedy2)
