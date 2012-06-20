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
AnzahlBitWorte = 2^8 ;       % Vervollständigen
status_alt = 0;
anzahl_worte = 0;
for k = 1:1:length(Rahmen)
    if Rahmen(k)==0
        if status_alt==1
            anzahl_worte = anzahl_worte + 1;
        end
    end
    status_alt = Rahmen(k);
end
Wortindex = zeros(1,anzahl_worte);
n=1;
for k = 1:1:length(Rahmen)
    if Rahmen(k)==0
        if status_alt==1
            Wortindex(n)=k;
            n=n+1;
        end
    end
    status_alt = Rahmen(k);
end

Bits = zeros(anzahl_worte,8); %anzahl der w�rter, Code

for k = 1:1:length(Wortindex)-1
    laenge_byte = Wortindex(k+1)-Wortindex(k);
    laenge_Bit = round(laenge_byte/8);
    Bits(k,1) = Data(Wortindex(k)+(round(laenge_Bit/2)));
    Bits(k,2) = Data(Wortindex(k)+(round(laenge_Bit/2))+laenge_Bit);
    Bits(k,3) = Data(Wortindex(k)+(round(laenge_Bit/2))+laenge_Bit*2);
    Bits(k,4) = Data(Wortindex(k)+(round(laenge_Bit/2))+laenge_Bit*3);
    Bits(k,5) = Data(Wortindex(k)+(round(laenge_Bit/2))+laenge_Bit*4);
    Bits(k,6) = Data(Wortindex(k)+(round(laenge_Bit/2))+laenge_Bit*5);
    Bits(k,7) = Data(Wortindex(k)+(round(laenge_Bit/2))+laenge_Bit*6);
    Bits(k,8) = Data(Wortindex(k)+(round(laenge_Bit/2))+laenge_Bit*7);
end

Kennlinie = zeros(2,length(Wortindex));

for k = 1:1:length(Wortindex)
    result = 0;
    if (Bits(k,1)==1)
        result = 1;
    end
    if (Bits(k,2)==1)
        result = result+2;
    end
    if (Bits(k,3)==1)
        result = result+4;
    end
    if (Bits(k,4)==1)
        result = result+8;
    end
    if (Bits(k,5)==1)
        result = result+16;
    end
    if (Bits(k,6)==1)
        result = result+32;
    end
    if (Bits(k,7)==1)
        result = result+64;
    end
    if (Bits(k,8)==1)
        result = result+128;
    end
    Kennlinie(1,k) = result;
    Kennlinie(2,k) = A(k);
end

% Vektor für die Dezimalwerte der Bitworte
DecVal=ones(1,AnzahlBitWorte)*NaN;
% Vektor für die zugehörigen Spannungspegel
VoltVal=ones(1,AnzahlBitWorte)*NaN;

for i=1:AnzahlBitWorte
    DecVal(i)  = i-1;       % Vervollständigen
    VoltVal(i) = A(i);       % Vervollständigen
end

stem(VoltVal,DecVal)
xlabel(  'hallo'  )
ylabel(  'paul'  )