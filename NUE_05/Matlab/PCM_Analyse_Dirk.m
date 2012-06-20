% PCM_Analyse.m
clear all;
%close all;
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


% die folgende routine w�rde das erste Bit auslassen wenn die Aufnahme der
% Messwerte bei einer fallenden Flanke startet

if Rahmen(1) == 1 && Rahmen(2) == 0
    display('M��p')
end

% Vektor erstellen, der eine 1 enth�lt wo ein neues bit anf�ngt
WortStart = Rahmen(2:end) -Rahmen(1:end-1);

% entstadene negative Werte l�schen
WortStart(WortStart<0) = 0;

% eine null ist verloren gegangen
WortStart = [0; WortStart];




% 
BitProWort = 8

% Anzahl Worte:
AnzahlBitWorte = sum(Wortstart)      % Vervollständigen

% Vektor für die Dezimalwerte der Bitworte
DecVal=ones(1,AnzahlBitWorte)*NaN;
% Vektor für die zugehörigen Spannungspegel
VoltVal=ones(1,AnzahlBitWorte)*NaN;

for i=1:AnzahlBitWorte
    DecVal(i)  = 0;       % Vervollständigen
    VoltVal(i) = DecVal(i);       % Vervollständigen
end

stem(VoltVal,DecVal)
xlabel(  '????'  )
ylabel( ' ???? ' )