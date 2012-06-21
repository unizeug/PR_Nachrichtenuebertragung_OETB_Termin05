function [ Data, Synchro ] = Split( MixSignal )
% Trennt das gemixte Signal in Daten und Rahmensynchronisationssignal

RahmenAmplitude=8;
DatenAmplitude=5;
RahmenThreshold=(RahmenAmplitude+DatenAmplitude)/2;

RahmenIdx=find(MixSignal>RahmenThreshold);
Synchro=zeros(numel(MixSignal),1);
Synchro(RahmenIdx)=1;
Data=MixSignal-Synchro*RahmenAmplitude;

end

