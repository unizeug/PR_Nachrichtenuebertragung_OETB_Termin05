% PCM_Analyse.m
clear;
clear all;
close all;
%load('pcm_data_test.mat')
load('dreieckflanken');
% A... Spannungssignal
% B... Bitwörter+Rahmensynchronisationssignal

%Filter Kanal B
B_filt=-1*PerfectTP(B,1/Tinterval,200e3);
% Split gefilterten Kanal B
[Data Rahmen]=Split(B_filt);
% Data bereinigen:
Data(Data<2.5)=0;
Data(Data>=2.5)=1;

% die folgende routine würde das erste Bit auslassen wenn die Aufnahme der
% Messwerte bei einer fallenden Flanke startet

if Rahmen(1) == 1 && Rahmen(2) == 0
    display('Fehler beim Erstellen des Rahmens')
end

% Vektor erstellen, der eine 1 enthält wo ein neues bit anfängt
WortStart =  Rahmen(1:end-1)-Rahmen(2:end);

% entstadene negative Werte löschen
WortStart(WortStart<0) = 0;

% eine null ist verloren gegangen und wird wieder ergänzt
WortStart = [0; WortStart];
WortStart2 = WortStart;
Bitindex = zeros(length(Data),1);
Bitist1 = zeros(length(Data),1);
h=1; 
%Anzahl der Bits pro Wort
m = 8;                             % Siehe Datenblatt Steckbrett

% Anzahl Worte:
% das letzte Wort kann nicht als vollständig angesehen werden    
AnzahlBitWorte = sum(WortStart)-1; 

Datenblock = Data;
%display('Datenblock am Anfang');
%length(Datenblock)

% löschen der Abtastwerte vor dem ersten Bitwort

while WortStart(1)<1
    Datenblock(1) = [];
    WortStart(1) = [];
    A(1) = [];
    h=h+1;
end
%display('Ersten abtstwerte abgeschnitten');
%length(Datenblock)

% erstellen des Vektors in denen die Bitwerte abgespeichert werden
Dateninbit = ones(AnzahlBitWorte*8,1)*9;
originalspannung = ones(AnzahlBitWorte,1)*9;
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
    
    originalspannung(i) = A(1);
    A(1:j) = [];
    for n = 1:8
        % Anzahl der Abtastwerte für das n-ten Bit bestimmen
        kn=round(j/(9-(n)));
        x = round(kn/2);
        Dateninbit(l) = Datenblock(x);
        h = h+x;
        Bitindex (h) = 1;
        if (Dateninbit(l) == 1) && (n==1)
            Bitist1(h) = 1;
        end
        h = h+kn-x;
        %km Daten aus dem Datenblock löschen
        Datenblock(1:kn) = [];        
        % Abtastwerte aus dem aktuellen Abtastwertblock löschen
        j = j-kn;
        % raufzählen der Laufvariable in Daten in Bit
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
originalspannung = originalspannung';

for n=1:AnzahlBitWorte
   bin2dec(num2str(Dateninbit(1:8)));
end

umax=2;
%ULSB
ULSB = (2*umax)/(2^(m)-1);


% Vektor für die Dezimalwerte der Bitworte
DecVal=ones(1,AnzahlBitWorte);
% Vektor für die zugehörigen Spannungspegel
VoltVal=ones(1,AnzahlBitWorte);

for n=1:AnzahlBitWorte
    DecVal(n)  = bin2dec(num2str(Dateninbit(1:8)));
    Dateninbit(1:8) = [];
    VoltVal(n) = originalspannung(1);
    originalspannung(1) = [];
end

figure(1);
stem(VoltVal,DecVal);
xlabel('Spannung [V]');
ylabel('Abtaststufe');
%axis([-2 2 0 258]);


% figure(11);
% stem(Data);
% hold on
% stem(WortStart2+0.0001,'r')
% stem(Bitindex+0.00005,'g');
% stem(Bitist1+0.000025,'c');
% hold off
% 
% figure(12);
% hold on
% stem(WortStart2+0.0001,'c');
% stem(Rahmen,'r');
% hold off

% % Vektor mit den Codewörtern für ein Bit
% Codevek = zeros(m,1);
% for n=1:m
%     Codevek(n) = 2^(m-n);
% end
% 
% % Vektor mit CodeWörtern für
% Codevek2 = Codevek;
% for o=1:(AnzahlBitWorte-1)
%     Codevek2 = [Codevek2 ; Codevek];
% end
% 
% Codevek3 = zeros(AnzahlBitWorte,1);
% %for p=1:m:AnzahlBitWorte
% %    Codevek3(l:l+m-1) = Codevek2(l
% %end
