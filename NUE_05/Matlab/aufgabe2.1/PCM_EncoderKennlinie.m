%Dreieckflanken 
clear;

dreieck = load('dreieckflanken');

figure(1);
plot(-dreieck.B, 'r')
hold on
plot(dreieck.A)
hold off
AXIS([0 7.8*10^4 -5 16]);
xlabel('Zeitachse t');
ylabel('Amplitude V');
title('Eingangssignal und Summe FS+PCM Data');
legend('Summe FS+PCM Data', 'Eingangssignal');