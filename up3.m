%Jan Liskiewicz 277437
close all
clear all


%% Przygotowanie sygna³u
signal=open('x2m.mat');
signal=signal.x2m;

fs=2e6;
fo=98e6;


%% wybór sygna³u pe³nego lub testowego

%sig=signal(1:2^14);
%sig=signal;


%% wyœwietlenie widma sygna³u
f=linspace(97e6,99e6,numel(sig));

figure(1)
plot(f,abs(fftshift(fft(sig))));
xlabel('Czestotliwoœæ')
ylabel('dB')
title('widmo sygna³u')


%% Demodulacja i decymacja
t=1:numel(sig);
%czêstotliwoœæ wybranej stacji= fo+f1
%98Mhz+0.3Mhz=98.3MHz
%wybrana stacja to "RMF Classic"
f1=0.3e6; 
y=(sin(2*pi*f1/fs*t)-1i*cos(2*pi*f1/fs*t)).';

%demodulacja sygna³u
sig_demod=sig.*y;

%decymacja sygna³u
sig_demod2=decimate(sig_demod,4);
figure(2);
f=linspace(-1,1,numel(sig_demod2));
plot(f,abs(fftshift(fft(sig_demod2))));
xlabel('Czestotliwoœæ unormowana')
ylabel('dB')
title('widmo sygna³u po przetworzeniu')


%% Spektrogram
%(mo¿na pomin¹æ dla pe³nego sygna³u)
figure(3);
spectrogram(sig_demod2,100,[],[],'centered','yaxis')
[~,f,t,p]=spectrogram(sig_demod2,100,[],[],'centered','yaxis');


%% Uzyskanie dŸwiêku ze spektrogramu
%przygotowane w celach pogl¹dowych i dla póŸniejszego porównania
%(mo¿na pomin¹æ)
[fridge,~,lr] = tfridge(p,f);

figure(4)
sound1=filter([1,0.4],[2,-0.6],fridge);
plot(sound1)
title('przewidywany sygna³ dŸwiêkowy')
soundsc(sound1,10000);


%% Obliczenie czêstotliwoœci chwilowej
clear faza2
Ts=1;
n=4:numel(sig_demod2)/Ts-4;
faza=(unwrap(angle(sig_demod2(n*Ts)))-unwrap(angle(sig_demod2((n-1)*Ts))))/Ts;
figure(5)
plot(faza)
title('czêstotliwoœæ chwilowa')
Ts=50;
for n=1:(numel(faza)/Ts)-1    
    faza2(n)=mean(faza(n*Ts+1:(n+1)*Ts));    
end
figure(6)
plot(faza2);
title('czêstotliwoœæ chwilowa uœredniona')


%% Ods³uchanie sygna³u audio
sound2=filter([1,0.4],[2,-0.6],faza2);
figure(7)
plot(sound2);
title('otrzymany sygna³ dŸwiêkowy')
fs1=fs*numel(sound2)/numel(sig);
soundsc(sound2,fs1)





