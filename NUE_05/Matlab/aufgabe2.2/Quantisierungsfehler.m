clear; close all;

%Messungen laden
%Kanal B=Eingangssignal, Kanal A=decodiertes Signal

sinus100 = load('sinus_clk100kHz');
% sinus100 = load('sinus_clk100kHz');
% 
% dreieck8 = load('dreieck_clk8kHz');
% dreieck100 = load('dreieck_clk100kHz');

%Mittelwertbefreiung
a = sinus100.A;
b = sinus100.B;

a = a-mean(a);
b = b-mean(b);

%minimale zeitliche Verschiebung finden


%und Signale entsprechend zuschneiden
faktor = max(b)/max(a);
a = a*faktor;

figure(1);
plot(a)
hold on
plot(b, 'r')
hold off

%Quantisierungsfehler bestimmen
%y = Ergebnis decodiertes Signal, je auf Kanal A
%u = Eingangsignal, je auf Kanal B
a = y;
b = u;

q = y-u;


%Plot Quantisierungsfehler-Histogramm
%hist(q)     % macht automatisch 10 gleichgroﬂe bins


%Plot Quantisierungsfehler-LDS

