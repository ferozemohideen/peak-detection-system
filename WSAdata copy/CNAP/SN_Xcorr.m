%previcously known as marcio2_j02.m
%select more than 1 file (of same response?)to analise, makes table with animal number, table
%with latencies and with amplitudes of dots generated

clear all;
%close all;
clc
%load prototype.txt;
load template_SN.txt;
prototype=template_SN(70:200);

a=[];
b=[];
si=20;         %size of table matrix containing latency and amplitude data
tabLat=[];
tabAmp=[];
tempo_pos3=[];
C3_peak=[];
C4=[];              %media de C3 acumulado
limiar=0.0055;       %threshold for what is considered a reponses 0.0145 sem filtros
thresh=.9;           %for limiar3: fraction of max difference from baseline considered noise (use 1)
%limiar2=0.005;       %threshold for detecting xcorr peaks
tmax=50e-3;
tmin=5.21e-3;


[Arquivo Path] = uigetfile(['*.txt'],'select your files','MultiSelect', 'on');


for k=1:size (Arquivo,2);
    Arq = Arquivo {1,k};
    
    FileID=fopen([Path Arq],'r');
    % Carrega cabecalho da primeira linha - Numero de canais, frequencia de amostragem
    frewind(FileID);
    texto1=fgetl(FileID);
    texto2=fgetl(FileID);
    Ts=str2num(texto2(1:8))*1e-3;
    fs=1/Ts;
    texto3=fgetl(FileID);
    texto4=fgetl(FileID);
    texto5=fgetl(FileID);
    texto6=fgetl(FileID);
    texto7=fgetl(FileID);
    num_amostras=str2num(texto7);
    for i=1:num_amostras
        tx=fgetl(FileID);
        dados(i)=str2num(tx);
    end
    
    figure(k);
    tamanho_da_tela=get(0,'ScreenSize');
    set(figure(k),'Position',[0 40 tamanho_da_tela(3) tamanho_da_tela(4)-120]);
    
    %plot A --------------------------
    subplot(4,1,1);
    tempo=(0:num_amostras-1)*Ts;
    plot(tempo*1e3,dados);
    xlabel('Tempo (ms)');
    ylabel('mV');
    text(6,max(dados),texto1(96:length(texto1)));
    text(40,min(dados),texto2);
    
    %plot B ---------------------------
    subplot(4,1,2);
    ind=find((tempo>=tmin)&(tempo<=tmax));
    dados2=dados(ind);
    % remove DC level
    dados2=dados2-mean(dados(3:round(4.8e-3/Ts)));
    plot(tempo(ind)*1e3,dados2);
    axis([5 tmax*1e3 -0.5 0.5]);
    xlabel('Tempo (ms)');
    ylabel('mV');
    
    %plot 3 ----------------------------
    ind=find((tempo>=tmin)&(tempo<=tmax)); %5.5ms is good for SN
    dados3=dados(ind);
    dados3=dados3-mean(dados(3:round(4.8e-3/Ts)));
   
%     % set cuttoff freq---------------------
        %fmax=2500;
%     [B,A] = butter(4,[(100/(fs/2)) (fmax/(fs/2))],'bandpass');
%     %[B,A] = butter(4,(1/(fs/2)),'high');
%     dados3 = filtfilt(B,A,dados3);
    
    % multiply by a Tukey window
    %janela=window(@tukeywin,length(dados3));
    %dados3=dados3.*janela';
    %dados3=dados3-mean(dados3);
    
    subplot(4,1,3);
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
    
    texto3=['peak =' num2str(peak) '   valey =' num2str(valey)];
    texto4=['peak-to-peak = ' num2str(peak-valey) ...
        '   tmax = ' num2str(tmmax) '   tmin = ' num2str(tmmin)];
    
    text(((tmax*1e3)/1.5),0.2,texto3);
    text(((tmax*1e3)/1.5),-0.2,texto4);
    axis([5 tmax*1e3 -0.5 0.5]);
    xlabel('Tempo (ms)');
    ylabel('mV');
    
    %figure(3)
    %plot(prototype);
    
    %plot 4 ----------------------------
    %subplot(4,1,4);
    %NN=1024;
    %[Pxx,f]=psd(dados3,NN,fs,NN,NN-1);
    %Pxx=Pxx/sum(Pxx);
    
    % set the max frequency of PSD
    %ind2=find(f<=fmax);
    
    [C,LAGS] = xcorr(dados3,prototype);
 %    [C,LAGS] = xcov(dados3,prototype);
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
    subplot(4,1,4);
    plot(tempo_lag,C2);
    hold on;
    plot(tempo_lag,C3,'r');
    plot(tempo_lag,temp_lim,'g');
    num_peak_correl=0;
    if ~isempty(ind6)
        plot(tempo_pos3,C3_peak,'.k');
        num_peak_correl=length(C3_peak);
        t_peak1=tempo_pos3(1);
        texto6=['lag of 1st correl peak = ' num2str(t_peak1)];
        text(((tmax*1e3)/1.5),0.1,texto6);
    end;
    
    axis([5 tmax*1e3 0 0.5]);
    maxcorrel=max(C2);
    texto5=['max correl =' num2str(maxcorrel) '   num peak correl =' num2str(num_peak_correl)];
    text(((tmax*1e3)/1.5),0.2,texto5);
    
    xlabel('Tempo (ms)');
    ylabel('Correlation (a.u.)');
    
    %-----------------------------
    %table of dots (b=latencies, d=amplitudes)- para cada arquivo
    a=[a;texto1(96:110)];
    %a=[a;texto1(96:110) '    (milisecs)';texto1(96:110) '   (amplitude)'];
    b=[];
    d=[];
    if isempty(ind6)
        tempo_pos3=[];
        C3_peak=[];
    end
    b=[tempo_pos3,zeros(1,(si-size(tempo_pos3,2)))];
    d=[C3_peak,zeros(1,(si-size(C3_peak,2)))];
%     tabLat=[tabLat;b];
%     tabAmp=[tabAmp;d];
    
    
    %------------------------------
    %media de xcorr para achar resposas reais (repetidos)
    
   C4=[C4;C3];        %accumular C3 (onda de xcorr)
    
end

C4media=mean(C4);
C4std=std(C4);
pks=zeros(size(C4media));

         %--define limiar = to max baseline levels
    if (max(C4media(1:110))>= -min(C4media(1:110))),
        limiar3=thresh*max(C4media(1:110))  %response threshold =a% of max at baseline
    else limiar3=-thresh*min(C4media(1:110));
    end
    
    
for i = 1:size(C4media,2),    
    if (C4media(i)>=4*C4std(i))% & C4media(i)> limiar),  %tirar "%" to include limiar
    pks(i)=C4media(i);
    end
end

figure
plot(tempo_lag,C4media,'k')
hold on
plot(tempo_lag,C4std,'r')
figure
plot(tempo_lag,pks,'b')
[C4PKS,locs]=findpeaks(pks);

a
response_peaks=[tempo_lag(1,locs);C4media(1,locs); C4std(1,locs)]


% save tabLat
% save tabAmp
% save animal a