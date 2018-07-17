%part1 of ff file processing - must run in directory of files to analyse
%1st select baseline files
%2nd select ff files, creates matrix with ff subracted
%3rd run part2 of ff file processing

clear all;
close all;
clc

gen_res=[];
folfreq=[]; %matrix com tudos os ff dados
FileName=[];
%----------------------------------
%selecionar arquivos para respostas genericas
[Arquivo Path] = uigetfile(['*.txt'],'select generic responses','MultiSelect', 'on');

figure;

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

hold on
    tempo=(0:num_amostras-1)*Ts;
    plot(tempo*1e3,dados);
    xlabel('Tempo (ms)');
    ylabel('mV');
    
gen_res=[gen_res; dados];

end

gen_res=mean(gen_res);

tempo=(0:num_amostras-1)*Ts;
    plot(tempo*1e3,gen_res,'r');
    xlabel('Tempo (ms)');
    ylabel('mV');


figure;
    tempo=(0:num_amostras-1)*Ts;
    plot(tempo*1e3,gen_res);
    xlabel('Tempo (ms)');
    ylabel('mV');
    
 
%----------------------------------
%selecionar arquivos para subtrair responstas de ff da generica

[Arquivo Path] = uigetfile(['*.txt'],'select ff responses','MultiSelect', 'on');


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
    FileName=[FileName;texto1(end-25:end)];
    for i=1:num_amostras
        tx=fgetl(FileID);
        dados(i)=str2num(tx);
    end
    
figure(k+2);
subplot (2,1,1);
    tempo=(0:num_amostras-1)*Ts;
    plot(tempo*1e3,dados);
    hold on;
    plot(tempo*1e3,gen_res,'r');
    xlabel('Tempo (ms)');
    ylabel('mV');
    
ff_res= dados - gen_res;
    
 folfreq=[folfreq;ff_res];

subplot (2,1,2);
    tempo=(0:num_amostras-1)*Ts;
    plot(tempo*1e3,ff_res);
    text(6,max(dados),texto1(end-25:end));
end

save ffdados folfreq tempo Ts FileName;
    
    
    
    