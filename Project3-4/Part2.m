clc;
clear all;
close all;

tstart=-1;
tend=1;
fs=50;
ts=1/fs;
subplot(2,1,1)
t=tstart:ts:tend-ts;
x1=zeros(size(t));
N=length(t);
x1(t==0)=1;
plot(t, x1);
xlabel('Time (s)')
ylabel('delta(t)')
title('delta(t)')

freq1=0:fs/N:(N-1)*fs/N;
x1F=fft(x1);
x1Fvalue = abs(x1F) / max(abs(x1F));

subplot(2,1,2)
freq2=-fs/2:fs/N:fs/2-fs/N;
x1Fshifted=fftshift(x1F);
x1FshiftedValue = x1Fshifted / max(abs(x1Fshifted));
plot(freq2, abs(x1FshiftedValue))
xlabel('Frequency (Hz)')
ylabel('Furier Transform')
title('Furier Transform of delta(t)')
xlim([-2,2])
ylim([0,2])

pause(1);

%PART 2,2:

tstart=-1;
tend=1;
fs=50;
ts=1/fs;
subplot(2,1,1)
t=tstart:ts:tend-ts;
x2=zeros(size(t))+1;
N=length(t);
plot(t,x2);
xlabel('Time (s)')
ylabel('x(t)=1')
title('x(t)=1')


freq1=0:fs/N:(N-1)*fs/N;
x2F=fft(x2);
x1Fvalue = abs(x2F) / max(abs(x2F));
subplot(2,1,2)
freq2=-fs/2:fs/N:fs/2-fs/N;
x2Fshifted=fftshift(x2F);
x2FshiftedValue = x2Fshifted / max(abs(x2Fshifted));
plot(freq2, abs(x2FshiftedValue))
xlabel('Frequency (Hz)')
ylabel('Furier Transform')
title('Furier Transform of x(t)')