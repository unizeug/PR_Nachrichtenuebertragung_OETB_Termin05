clear; close all;clc;

%% Messungen laden und Zeitvektor erstellen
%Kanal B=Eingangssignal, Kanal A=decodiertes Signal

Signal = 0; % für ein Sinussignal
%Signal = 1; % für ein Dreiecksignal

%Frequenz = 8000;
Frequenz = 100000;

Bild_abspeichern = 0; % kein Bild wird gespeichert
%Bild_abspeichern = 1; % Das LDS wird gespeichert

if Signal == 0
    if Frequenz == 8000
        sinus = load('sinus_clk8kHz');
        sinus.B = -1*sinus.B;
        disp('f=8K')
    else
        sinus = load('sinus_clk100kHz');
        disp('100k')
    end
    tend=sinus.Length*sinus.Tinterval;
    t=linspace(0,tend,sinus.Length);

else % Signal == 'Dreieck'
    if Frequenz == 8000
        dreieck = load('dreieck_clk8kHz');
        dreieck.B = -1*dreieck.B;
    else % Frequenz == 100000
        dreieck = load('dreieck_clk100kHz');
    end
    tend=dreieck.Length*dreieck.Tinterval;
    t=linspace(0,tend,dreieck.Length);
end

%% Mittelwertbefreiung

if Signal == 0
    a = sinus.A;
    b = sinus.B;
    if Frequenz == 8000
        a(3710) = a(3720);     %Fuschkorrektur
        a(1085) = -1.0480;    %Fuschkorrektur
    end
else % Signal == 'dreieck'
    a = dreieck.A;
    b = dreieck.B;
end

a = a-mean(a);
b = b-mean(b);


%% und Signale entsprechend zuschneiden
faktor = max(b)/max(a);
a = a*faktor;

%% plotten der Mittelwertfreien und Amplitudenangepassten Signale
figure(1);
plot(t,a);
hold on
plot(t, b, 'r');
hold off
AXIS([0 0.05 -1.5 2]);
xlabel('Zeitachse t');
ylabel('Amplitude V');
SUPTITLE(['\bf Eingangssignal und decodiertes, amplitudenangepasstes Signal',10]);
legend('Eingangssignal','decodiertes, amplitudenangepasstes Signal');


%% errechnen der Kreuzkorrelation
%minimale zeitliche Verschiebung finden
% [xr,lag]=xcorr(a,b);
% [mx,mind]=max(abs(xr));
% delay_eva=lag(mind)

[c,lags] = xcorr(a,b);
index_center=(length(c)+1)./2;
[c,index_max]=max(c);
delay=index_max-index_center


% t = (1:length(a)-delay_eva);


t = t(1:length(a)-delay);

%% plotten der Verschobene Signale

figure(2);
% plot(t,a(delay_eva+1:end))
plot(t,a(delay+1:end))
hold on
% plot(t,b(1:end-delay_eva),'r')
plot(t,b(1:end-delay),'r')
hold off
%AXIS([0 3500 -1.5 2]);
xlabel('Zeitachse t');
ylabel('Amplitude V');
SUPTITLE(['\bf Eingangssignal und decodiertes, amplitudenangepasstes Signal ohne Zeitverschiebung',10]);
legend('Eingangssignal','korrekt decodiertes Ausgangssignal');

%% Quantisierungsfehler qf bestimmen
y = a;          %y = Ergebnis decodiertes Signal, je auf Kanal A
u = b;          %u = Eingangsignal, je auf Kanal B

%qf = y(delay_eva+1:end)-u(1:end-delay_eva);
qf = y(delay+1:end)-u(1:end-delay);


%% plotten des Quantisierungsfehlers und des Histogramms
figure(3);
plot(t,qf);
% AXIS([0 3500 -1.5 2]);
xlabel('Zeitachse t');
ylabel('Amplitude V');
SUPTITLE(['\bf Quantisierungsfehler',10]);

% %Plot Quantisierungsfehler-Histogramm
figure(4);
hist(qf);     % macht automatisch 10 gleichgroße bins
xlabel('Spannung [V]');
ylabel('Häufigkeit');
SUPTITLE(['\bf Histogramm des Quantisierungsfehlers', 10]);

%% errechnen des Leistungsdichtespektrums
[qfauto,lag]=xcorr(qf,qf);

f_T=100000; % oder =8000

if Signal == 0
    T_ges=sinus.Tinterval*sinus.Length;
    disp('sinus')
else
    disp('Dreieck')
    T_ges=dreieck.Tinterval*dreieck.Length;
end





%% plotten der Autokorrelation und des Leistungsdichtespektrum des
%% Quantisierungsfehlers
FFTshiftplotZP_autocorr(qfauto, T_ges, f_T,4,'b', 525,-750,750)

%% Bilder des LDS Abspeichern
if Bild_abspeichern == 1
    disp('Bild wurde abgespeichert')
    figure(525);
    if Signal == 0 % Sinussignal
        if Frequenz == 8000
            print -painters -dpdf -r600 ../../Bilder/sin8_Quantisierungsfehler_LDS.pdf
        else
            print -painters -dpdf -r600 ../../Bilder/sin100_Quantisierungsfehler_LDS.pdf
        end
    else % Dreieckssignal
        if Frequenz == 8000
            print -painters -dpdf -r600 ../../Bilder/drei8_Quantisierungsfehler_LDS.pdf
        else
            print -painters -dpdf -r600 ../../Bilder/drei100_Quantisierungsfehler_LDS.pdf
        end
    end
end

