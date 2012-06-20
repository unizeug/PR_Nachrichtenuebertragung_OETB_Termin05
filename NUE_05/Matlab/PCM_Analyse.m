% PCM_Analyse.m
clear;
clear all;
close all;
load('pcm_data_test.mat')
% A... Spannungssignal
% B... Bitw�rter+Rahmensynchronisationssignal

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
    display('Fehler beim Erstellen des Rahmens')
end

% Vektor erstellen, der eine 1 enth�lt wo ein neues bit anf�ngt
WortStart = Rahmen(2:end) -Rahmen(1:end-1);

% entstadene negative Werte l�schen
WortStart(WortStart<0) = 0;

% eine null ist verloren gegangen und wird wieder erg�nzt
WortStart = [0; WortStart];

%Anzahl der Bits pro Wort
m = 8;                             % Siehe Datenblatt Steckbrett

% Anzahl Worte:
% das letzte Wort kann nicht als vollst�ndig angesehen werden    
AnzahlBitWorte = sum(WortStart)-1; 

Datenblock = Data;
%display('Datenblock am Anfang');
%length(Datenblock)

% l�schen der Abtastwerte vor dem ersten Bitwort
h=1;
while WortStart(h)<1
    Datenblock(1) = [];
    WortStart(1) = [];
    %h=h+1;
end
%display('Ersten abtstwerte abgeschnitten');
%length(Datenblock)

% erstellen des Vektors in denen die Bitwerte abgespeichert werden
Dateninbit = ones(AnzahlBitWorte*8,1)*9;
%Laufvariable innerhalb von Dateninbit
l=1;
% Die einzelnen Bitworte bearbeiten
for i=1:AnzahlBitWorte
    % Anzahl der Abtastwerte in dem Aktuellen BitWort bestimmen
    j =2;
    while WortStart(j)<1
        j = j+1;
    end

    % beschneiden vom WortStart
    WortStart(1:j) = [];
    
    for n = 1:8
        % Anzahl der Abtastwerte f�r das erste Bit bestimmen
        kn=round(j/(9-n));
        Dateninbit(l) = sum(Datenblock(1:kn))/kn;
        %km Daten aus dem Datenblock l�schen
        Datenblock(1:kn) = [];
        % Abtastwerte aus dem aktuellen Abtastwertblock l�schen
        j = j-kn;
        % raufz�hlen der Laufvariable in Daten in Bit
        l = l+1;
    end
    
    % Testbereich
    %i
    %display('ter durchlauf');
    %length(Datenblock)
end

% Data bereinigen:
Dateninbit(Dateninbit<0.5)=0;
Dateninbit(Dateninbit>=0.5)=1;

Dateninbit = Dateninbit';

for n=1:AnzahlBitWorte
   bin2dec(num2str(Dateninbit(1:8)));
end

umax=2;
%ULSB
ULSB = (2*umax)/(2^(m)-1);


% Vektor f�r die Dezimalwerte der Bitworte
DecVal=ones(1,AnzahlBitWorte);
% Vektor f�r die zugeh�rigen Spannungspegel
VoltVal=ones(1,AnzahlBitWorte);

for n=1:AnzahlBitWorte
    DecVal(n)  = bin2dec(num2str(Dateninbit(1:8)));
    Dateninbit(1:8) = [];
    VoltVal(n) = (DecVal(n)-128)*ULSB;       % Vervollst�ndigen
end

figure(1);
stem(VoltVal,DecVal);
xlabel('Spannung [V]');
ylabel('Abtaststufe');
axis([-2 2 0 258]);

% % Vektor mit den Codew�rtern f�r ein Bit
% Codevek = zeros(m,1);
% for n=1:m
%     Codevek(n) = 2^(m-n);
% end
% 
% % Vektor mit CodeW�rtern f�r
% Codevek2 = Codevek;
% for o=1:(AnzahlBitWorte-1)
%     Codevek2 = [Codevek2 ; Codevek];
% end
% 
% Codevek3 = zeros(AnzahlBitWorte,1);
% %for p=1:m:AnzahlBitWorte
% %    Codevek3(l:l+m-1) = Codevek2(l
% %end
