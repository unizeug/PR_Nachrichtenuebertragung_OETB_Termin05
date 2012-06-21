clear; close all;
load pcm_data_quantisierung.mat
%Mittelwertbefreiung

%minimale zeitliche Verschiebung finden
%und Signale entsprechend zuschneiden


%Quantisierungsfehler bestimmen
% q = y-u = Quantisierungskennlinie-Eingangssignal


%Plot Quantisierungsfehler-Histogramm
%hist(q)     - macht automatisch 10 gleichgroﬂe bins


%Plot Quantisierungsfehler-LDS

