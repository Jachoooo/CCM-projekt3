close all
clear all


%% Przygotowanie sygnału
signal=open('x2m.mat');
signal=signal.x2m;

fs=2e6;
fo=98e6;


%% wybór sygnału pełnego lub testowego

%sig=signal(1:2^14);
%sig=signal;


%% wyświetlenie widma sygnału
f=linspace(97e6,99e6,numel(sig));

figure(1)
plot(f,abs(fftshift(fft(sig))));
xlabel('Czestotliwość')
ylabel('dB')
title('widmo sygnału')


%% Demodulacja i decymacja
t=1:numel(sig);
%częstotliwość wybranej stacji= fo+f1
%98Mhz+0.3Mhz=98.3MHz
%wybrana stacja to "RMF Classic"
f1=0.3e6; 
y=(sin(2*pi*f1/fs*t)-1i*cos(2*pi*f1/fs*t)).';

%demodulacja sygnału
sig_demod=sig.*y;

%decymacja sygnału
sig_demod2=decimate(sig_demod,4);
figure(2);
f=linspace(-1,1,numel(sig_demod2));
plot(f,abs(fftshift(fft(sig_demod2))));
xlabel('Czestotliwość unormowana')
ylabel('dB')
title('widmo sygnału po przetworzeniu')


%% Spektrogram
%(można pominąć dla pełnego sygnału)
figure(3);
spectrogram(sig_demod2,100,[],[],'centered','yaxis')
[~,f,t,p]=spectrogram(sig_demod2,100,[],[],'centered','yaxis');


%% Uzyskanie dźwięku ze spektrogramu
%przygotowane w celach poglądowych i dla późniejszego porównania
%(można pominąć)
[fridge,~,lr] = tfridge(p,f);

figure(4)
sound1=filter([1,0.4],[2,-0.6],fridge);
plot(sound1)
title('przewidywany sygnał dźwiękowy')
soundsc(sound1,10000);


%% Obliczenie częstotliwości chwilowej
clear faza2
Ts=1;
n=4:numel(sig_demod2)/Ts-4;
faza=(unwrap(angle(sig_demod2(n*Ts)))-unwrap(angle(sig_demod2((n-1)*Ts))))/Ts;
figure(5)
plot(faza)
title('częstotliwość chwilowa')
Ts=50;
for n=1:(numel(faza)/Ts)-1    
    faza2(n)=mean(faza(n*Ts+1:(n+1)*Ts));    
end
figure(6)
plot(faza2);
title('częstotliwość chwilowa uśredniona')


%% Odsłuchanie sygnału audio
sound2=filter([1,0.4],[2,-0.6],faza2);
figure(7)
plot(sound2);
title('otrzymany sygnał dźwiękowy')
fs1=fs*numel(sound2)/numel(sig);
soundsc(sound2,fs1)





