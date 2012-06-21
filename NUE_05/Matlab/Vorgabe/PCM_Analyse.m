% PCM_Analyse.m
clear all;
close all;
load('pcm_data_test.mat')
% A... Spannungssignal
% B... Bitwörter+Rahmensynchronisationssignal

%Filter Kanal B
B_filt=PerfectTP(B,1/Tinterval,200e3);
% Split gefilterten Kanal B
[Data Rahmen]=Split(B_filt);
% Data bereinigen:
Data(Data<2.5)=0;
Data(Data>=2.5)=1;

% Anzahl Worte:
AnzahlBitWorte = ??? ;       % Vervollständigen

% Vektor für die Dezimalwerte der Bitworte
DecVal=ones(1,AnzahlBitWorte)*NaN;
% Vektor für die zugehörigen Spannungspegel
VoltVal=ones(1,AnzahlBitWorte)*NaN;

for i=1:AnzahlBitWorte
    DecVal(i)  = ???;       % Vervollständigen
    VoltVal(i) = ???;       % Vervollständigen
end

stem(VoltVal,DecVal)
xlabel(  ????  )
ylabel(  ????  )