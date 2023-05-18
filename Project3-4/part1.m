%PART 1,0:
tstart = 0;
tend = 1;
fs = 20;
ts = 1/fs;
t = tstart:ts:tend-ts;
N = length(t);
f = -fs/2:fs/N:fs/2-fs/N;
x0 = exp(1j * 2 * pi * 5 * t) + exp(1j * 2 * pi * 8 * t);
x0F = fft(x0);
x0Fvalue = abs(x0) / max(abs(x0));
x0Fshifted = fftshift(x0F);
x0FshiftedValue = abs(x0Fshifted) / max(abs(x0Fshifted));
plot(f, x0FshiftedValue);
xlabel('Frequency (Hz)')
ylabel('magnitude')
title('magnitude of exp(1j * 2 \pi * 5 * t) + exp(1j * 2 \pi * 8 * t)')
pause(1);
x0_1 = exp(1j * 2 * pi * 5 * t) + exp(1j * 2 * pi * 5.1 * t);
x0_1F = fft(x0_1);
x0_1Fvalue = abs(x0_1) / max(abs(x0_1));
x0_1Fshifted = fftshift(x0_1F);
x0_1FshiftedValue = abs(x0_1Fshifted) / max(abs(x0_1Fshifted));
plot(f, x0_1FshiftedValue);
xlabel('Frequency (Hz)')
ylabel('magnitude')
title('magnitude of exp(1j * 2 \pi * 5 * t) + exp(1j * 2 \pi * 5.1 * t)');

pause(1);

%PART 1,1:
tstart = -1;
tend = 1;
fs = 50;
ts = 1/fs;
t = tstart:ts:tend-ts;
N = length(t);
x1 = cos(2*pi*5*t);
subplot(2,1,1)
plot(t, x1)
xlabel('Time (s)')
ylabel('cos(10\pit)')
title('cos(10\pit)')

freq2 = 0:fs/N:(N-1)*fs/N;
x1F = fft(x1);
x1Fvalue = abs(x1F) / max(abs(x1F));

subplot(2,1,2)
freq1 = -fs/2:fs/N:fs/2-fs/N;
x1Fshifted = fftshift(x1F);
x1FshiftedValue = abs(x1Fshifted) / max(abs(x1Fshifted));
plot(freq1, x1FshiftedValue)
xlabel('Frequency (Hz)')
ylabel('Furier Transform')
title('Furier Transform of cos(10\pit)')
pause(1);

%PART 1,2:
x2 = rectangularPulse(t);
subplot(2,1,1)
plot(t, x2)
xlabel('Time (s)')
ylabel('rect(\pit)')
title('rect(\pit)')

subplot(2,1,2)
x2F = fft(x2);
x2Fshifted = fftshift(x2F);
x2FshiftedValue = abs(x2Fshifted) / max(abs(x2Fshifted));
plot(freq1, x2FshiftedValue)
xlabel('Frequency (Hz)')
ylabel('Furier Transform')
title('Furier Transform of rect(\pit)')
pause(1);

%part 1,3:
x3 = cos(2*pi*5*t) .* rectangularPulse(t);
subplot(2,1,1)
plot(t, x3)
xlabel('Time (s)')
ylabel('cos(10\pit)rect(t)')
title('cos(10\pit)rect(t)')

subplot(2,1,2)
x3F = fft(x3);
x3Fvalue = abs(x3F) / max(abs(x3F));
x3Fshifted = fftshift(x3F);
x3FshiftedValue = abs(x3Fshifted) / max(abs(x3Fshifted));
plot(freq1, x3FshiftedValue)
xlabel('Frequency (Hz)')
ylabel('Furier Transform')
title('Furier Transform of cos(10\pit)rect(t)')
pause(1)


%Part 1,4:
%Part 1,4:
fs = 100;
ts = 1/fs;
t = tstart:ts:tend-ts;
N = length(t);
freq2 = 0:fs/N:(N-1)*fs/N;
freq1 = -fs/2:fs/N:fs/2-fs/N;
tol = 1*exp(-6);
x4 = cos(2*pi*15*t + pi/4);

x4F = fft(x4);
x4F(abs(x4F) < tol) = 0;
subplot(2,1,1)
plot(freq2,x4F)
xticks(0:10:100);
xlabel('Time (s)')
ylabel('Furier Transform')
title('Furier Transform of cos(30\pit + \pi/4)')
theta = angle(x4F);
subplot(2,1,2);
plot(freq2, theta/pi);
xticks(0:10:100);
xlabel('Frequency (Hz)');
ylabel('Phase (pi)');
title('Phase Spectrum of cos(30\pit + \pi/4)');



%Part 1,5:
tstart = -19;
tend = 19;
fs = 50;
ts = 1/fs;
t = tstart:ts:tend-ts;
N = length(t);
x5 = 0;
for k = -9:9
    x5 = x5 + rectangularPulse(t - 2*k);
end
freq1 = -fs/2:fs/N:fs/2-fs/N;
freq2 = 0:fs/N:(N-1)*fs/N;
subplot(2,1,1)
plot(t, x5)
xlabel('Time (s)')
ylabel('x_5(t)')
title('x_5(t)')
x5F = fft(x5);
x5Fvalue = abs(x5F) / max(abs(x5F));
x5Fshifted = fftshift(x5F);
x5FshiftedValue = abs(x5Fshifted) / max(abs(x5Fshifted));
subplot(2,1,2)
plot(freq1, x5FshiftedValue)
xlabel('Frequency (Hz)')
ylabel('Magnitude')
title('Furier Transform of x_5(f)')

