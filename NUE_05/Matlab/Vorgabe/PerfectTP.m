function [ Filtered_Signal ] = PerfectTP( Signal, f_s, f_CutOff )
% Fuehrt eine optimale Tiefpassfilterung durch.
% fft alle Frequenzen von 0 bis (N-1)/N*f_t=(1-1/N)*f_t

if f_CutOff <= f_s/2
    % alle f �ber f_Bound l�schen -> Index finden
    f_CutOff_idx = f_CutOff /f_s*numel(Signal)+1;
    
    %alle Indizes oberhalb ceil(f_Bound_idx) m�ssen weg, au�er:
    f_CutOff_idx2 = numel(Signal)+1-f_CutOff_idx+1;
    
    %alle Indizes untehralb ceil(f_Bound_idx2) m�ssen weg, au�er:
    % Ganz genau: alle Indizes zwischen ceil(f_Bound_idx) und floor(f_Bound_Idx2)
    
    Sig_fft=fft(Signal);
    Sig_fft(ceil(f_CutOff_idx):floor(f_CutOff_idx2))=0;
    %Sig_fft(ceil(f_Bound_idx):end)=0;
    Filtered_Signal=(ifft(Sig_fft));
end
end
