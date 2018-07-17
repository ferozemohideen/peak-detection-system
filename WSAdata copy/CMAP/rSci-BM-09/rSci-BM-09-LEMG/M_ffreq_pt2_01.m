%part2 of ff file processing
%opens saved matrix with ff files subtracted from baseline response
%compares with generic response
%makes tables with animal number, table with latencies and with amplitudes of dots generated
%must analise peaks manually as there is no correction for artifact

close all;
clear all;
clc
load generic_M.txt;
prototype=generic_M(60:500);
load ffdados;

a=[];
b=[];
si=20;         %size of table matrix containing latency and amplitude data
tabLat=[];
tabAmp=[];
tempo_pos3=[];
C3_peak=[];
C4=[];              %media de C3 acumulado
limiar=0.005;       %threshold for what is considered a reponses 0.0145 sem filtros
%limiar2=0.005;       %threshold for detecting xcorr peaks
tmax=50e-3;
tmin=5.21e-3;
resp_mat=[];

for k=1:size (folfreq,1);
    dados=folfreq(k,:);
    tamanho_da_tela=get(0,'ScreenSize');
    set(figure,'Position',[0 40 tamanho_da_tela(3)*0.75 tamanho_da_tela(4)*0.75-120]);
    
    %plot A --------------------------
    subplot(3,1,1);
    ind=find((tempo>=tmin)&(tempo<=tmax));
    dados3=dados(ind);
    % remove DC level
    dados3=dados3-mean(dados(3:round(4.8e-3/Ts)));
    plot(tempo(ind)*1e3,dados3);
    axis([5 tmax*1e3 -0.5 0.5]);
    xlabel('Tempo (ms)');
    ylabel('mV');
    text(6,max(dados3),FileName(k,:));
    %plot 3----------------------------
       
    subplot(3,1,1);
    plot(tempo(ind)*1e3,dados3);
    hold on;
    plot((tempo(1:length(prototype))*1e3+tmin*1e3),prototype,'r');
    
    indpico=find((tempo>tmin)&(tempo<8e-3));
    peak=max(dados3( indpico - indpico(1)+1 ));
    valey=min(dados3( indpico - indpico(1) +1 ));
    
    ind_tmmax=find(dados3( indpico - indpico(1)+1 )==peak);
    tmmax=(tmin*1e3+ind_tmmax*Ts*1e3);
    ind_tmmin=find(dados3( indpico - indpico(1)+1 )==valey);
    tmmin=(tmin+ind_tmmin*Ts*1e3);
    
    axis([5 tmax*1e3 -0.5 0.5]);
    xlabel('Tempo (ms)');
    ylabel('mV');
    
    %figure(3)
    %plot(prototype);

    [C,LAGS] = xcorr(dados3,prototype);
    C2=C(round(length(C)/2):end);   %C2=c com atasos pos
    LAGS2=LAGS(round(length(C)/2):end);
    tempo_lag=LAGS2*Ts*1e3+tmin*1e3;
    C3=zeros(1,length(tempo_lag));  %c3=c2 só pos
    C3=C2;
    ind5=find(C3<0);
    C3(ind5)=0;
    Cmax=max(C3);
    % limiar=0.018;
    ind6=[];
    ind6=find(C3>=limiar);
    %ind6=find(tempo_lag(ind61)>=6);
    %tam_prototype=length(prototype)*Ts;
    if ~isempty(ind6)
        %pos1=zeros(1,length(tempo(ind)));
        pos11=zeros(1,length(C3));
        pos11(ind6)=Cmax;
        pos1=gradient(pos11);
        ind7=find(pos1<0);
        pos1(ind7)=0;
        pos20=find(pos1>0);
        pos2=downsample(pos20,2);
        %tempo_pos2=tempo_lag(pos2);
        %C2_peak=C3(pos2);
        C3_peak=[];
        tempo_pos3=[];
        pos_C3_peak=[];
        jj=length(pos2);
        if jj>=1
            for j=1:(length(pos2))
                vet=C3(pos2(j):(pos2(j)+20));
                max3=max(vet);
                pos_C3_peak(j)=find(vet==max3)+pos2(j)-1;
                C3_peak(j)=C3(pos_C3_peak(j));
            end;
            tempo_pos3=tempo_lag(pos_C3_peak);
        end;    
        
        if C3(1)>=limiar
            vet=C3(1:20);
            max4=max(vet);
            pos_peak1=find(vet==max4);
            C3_peak=[max4 C3_peak];
            tempo_peak1=tempo_lag(pos_peak1);
            tempo_pos3=[tempo_peak1 tempo_pos3];
        end;
        
    end;
    temp_lim=ones(1,length(tempo_lag))*limiar;
    subplot(3,1,2);
    plot(tempo_lag,C2);
    hold on;
    plot(tempo_lag,C3,'r');
    plot(tempo_lag,temp_lim,'g');
    
    num_peak_correl=0;
    if ~isempty(ind6)
        plot(tempo_pos3,C3_peak,'.k');
        num_peak_correl=length(C3_peak);
        t_peak1=tempo_pos3(1);
    end;
    
    %axis([5 tmax*1e3 0 0.5]);
    maxcorrel=max(C2);
    
    xlabel('Tempo (ms)');
    ylabel('Correlation (a.u.)');
    text(6,max(C3_peak),FileName(k,:));
    
    %figure;
   % plot(tempo_lag,C3);
 
pks=zeros(size(C3));

 
thresh = 12*mean (C3(end-(size(C3,2)/3):end));

for i = 1:size(C3,2),    
    if (C3(i)> thresh),
    pks(i)=C3(i);
    end
end
subplot(3,1,3);
 plot(tempo_lag,pks,'k')

 [C3PKS,locs]=findpeaks(pks);
 text(6,max(pks),FileName(k,:));
FileName(k,:)
response_peaks=[tempo_lag(1,locs);C3(1,locs)]

end





