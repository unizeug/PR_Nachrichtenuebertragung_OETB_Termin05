clear; close all;

%Messungen laden
%Kanal B=Eingangssignal, Kanal A=decodiertes Signal

sinus8 = load('sinus_clk100kHz');
% sinus100 = load('sinus_clk100kHz');
% 
% dreieck8 = load('dreieck_clk8kHz');
% dreieck100 = load('dreieck_clk100kHz');

%Mittelwertbefreiung
a = sinus8.A;
b = sinus8.B;

a = a-mean(a);
b = b-mean(b);


%und Signale entsprechend zuschneiden
faktor = max(b)/max(a);
a = a*faktor;

figure(1);
plot(a);
hold on
plot(b, 'r');
hold off
AXIS([0 3500 -1.5 2]);
xlabel('Zeitachse t');
ylabel('Amplitude V');
SUPTITLE(['\bf Eingangssignal und decodiertes, amplitudenangepasstes Signal',10]);
legend('Eingangssignal','decodiertes, amplitudenangepasstes Signal');


%minimale zeitliche Verschiebung finden
[xr,lag]=xcorr(a,b);
[mx,mind]=max(abs(xr));
delay_eva=lag(mind);

% [c,lags] = xcorr(a,b);
% index_center=(length(c)+1)./2;
% [c,index_max]=max(c);
% delay=index_max-index_center


t = (1:length(a)-delay_eva);

figure(2);
plot(t,a(delay_eva+1:end))
hold on
plot(t,b(1:end-delay_eva),'r')
hold off
AXIS([0 3500 -1.5 2]);
xlabel('Zeitachse t');
ylabel('Amplitude V');
SUPTITLE(['\bf Eingangssignal und decodiertes, amplitudenangepasstes Signal ohne Zeitverschiebung',10]);
legend('Eingangssignal','korrekt decodiertes Ausgangssignal');

%Quantisierungsfehler qf bestimmen
y = a;          %y = Ergebnis decodiertes Signal, je auf Kanal A
u = b;          %u = Eingangsignal, je auf Kanal B

qf = y(delay_eva+1:end)-u(1:end-delay_eva);

figure(3);
plot(qf);
% AXIS([0 3500 -1.5 2]);
xlabel('Zeitachse t');
ylabel('Amplitude V');
SUPTITLE(['\bf Quantisierungsfehler',10]);

% %Plot Quantisierungsfehler-Histogramm
figure(4);
hist(qf, 'g');     % macht automatisch 10 gleichgro�e bins


% %Plot Quantisierungsfehler-LDS
% 
