
%select more than 1 file
%removes baseline for each response
%removes capacitance artifact by smoothing functions (fig3/3)
%plots mean of all selected responses (black) and SD (red)
%shows responses greater than 2xSD to make average response


clear all;
close all;
clc

tmax=50e-3;
tmin=2e-3;
dados4=[];
AvRes=[];
thresh=1;           %fraction of max difference from baseline considered noise (use 1)
SDd=1.9;            %SD required to detect considered a response (1.9 GOOD)
tiscap=0;           %if tiscap=1, filter/smooth algorithm will subtract from response
prefilt=0;          %if prefilt=1, high pass filter acitive
fmax=2500;          %low pass filter
fmin=100;           %high pass filter
LF=250;             %tiscap Low pass filter (400)
smth=7;             %tiscap smoothing number (use 6 (8) generally)
strt=11;            %tiscap starting number where low pass filter starts (use 11 (24) generally)
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
    
    
    %plot individual responses --------------------------
        %---whole raw response
    subplot(3,1,1);
    tempo=(0:num_amostras-1)*Ts;
    plot(tempo*1e3,dados);
    xlabel('Tempo (ms)');
    ylabel('mV');
    text(6,max(dados),texto1(96:length(texto1)));
    text(40,min(dados),texto2);
    
        %---selection between tmin and tmax
    subplot(3,1,2);
    ind=find((tempo>=tmin)&(tempo<=tmax));
    dados2=dados(ind);
    
        %---remove DC level
    dados2=dados2-mean(dados(3:round(4.8e-3/Ts)));
    %plot(tempo(ind)*1e3,dados2); plot below after filter
    axis([5 tmax*1e3 -0.5 0.5]);
    xlabel('Tempo (ms)');
    ylabel('mV');

        %---pre-filter
        if prefilt==1;
    %[B,A] = butter(4,[(fmin/(fs/2)) (fmax/(fs/2))],'bandpass');
    [B,A] = butter(4,(fmin/(fs/2)),'high');
    dados2 = filtfilt(B,A,dados2);    
        end;
        
      plot(tempo(ind)*1e3,dados2);  
      AvRes=[AvRes;dados2];     %accumulate AvRes without tiscap correction  
        
      
      %---tissue capacitance subtration:
        if tiscap==1,
            %obtain starting point of curve
[maxi, maxloc]=max(dados2);
[mini, minloc]=min(dados2);
startPt=[0,maxloc,minloc];
stPt=max(startPt);
dados2a=dados2(stPt:end);
            %obtain capacitance artifact curve

dados2b=dados2a(strt:end);%obtain and filter response      
[B,A] = butter(4,(LF/(fs/2)),'low');
dados2b = filtfilt(B,A,dados2b);
dados2c=[dados2a(1:strt-1) dados2b];

base=mean(dados2b((size(dados2b,2)/2):end)); %calculate stable baseline after respnose
if dados2a(1,1)>0, %was 2b?
[flt]=find(dados2c<base); %find flatline value
else
    [flt]=find(dados2c>base);
end
flt1=flt(1,1);
dados2e=[dados2c(1:flt1)];
dados2f = padarray(dados2e, [0 size(dados2c,2)-flt1], 'replicate', 'post');

d0=zeros(stPt-1,1);
d1=smooth(dados2f,smth);
dados2d=[d0;d1]';
  
hold on
 plot (tempo(ind)*1e3,dados2d,'r')
  

        %---subtract tissue capacitance:
dados3=dados2-dados2d;
subplot(3,1,3);
plot (tempo(ind)*1e3,dados3);

        else dados3=dados2;
        end;
        
    %accumulate responses:
    dados4=[dados4;dados3];
    
    
end

    AvRes=mean(AvRes);
    C3media=mean(dados4);
    C3std=std(dados4);
    pksMax=zeros(size(C3media));
    pksMin=zeros(size(C3media));
    
            %--define limiar = to max baseline levels
    if (max(C3media(1:110))>= -min(C3media(1:110))),
        limiar=thresh*max(C3media(1:110))  %response threshold =a% of max at baseline
    else limiar=-thresh*min(C3media(1:110));
    end
    
for i = 1:size(C3media,2),    
    if (C3media(i)>=SDd*C3std(i) & C3media(i)> limiar),
    pksMax(i)=C3media(i);
    elseif (C3media(i)<=-SDd*C3std(i) & C3media(i)< -limiar),
    pksMin(i)=C3media(i);  
    end
end

figure;
plot(tempo(ind)*1e3,C3media,'k','LineWidth',2)
hold on
plot(tempo(ind)*1e3,C3std,'r')
plot(tempo(ind)*1e3,-C3std,'g')
plot(tempo(ind)*1e3,AvRes,'b');
figure
plot(tempo(ind)*1e3,pksMax,'b')
hold on
plot(tempo(ind)*1e3,pksMin,'r')

%[C3PKS,locs]=findpeaks(pks);
   
    
