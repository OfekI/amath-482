%% Part 1 - Handel
clear variables; close all; clc;
load handel

n=length(y); L=n/Fs;
t=(1:n)/Fs;
k=(Fs/n)*[0:(n-1)/2 -(n-1)/2:-1];
ks=fftshift(k);

S = y';
St = fft(S);

% Plot waveform and fft
subplot(2, 1, 1);
plot(t, S);
xlabel('Time [sec]');
ylabel('Amplitude');
title('Waveform Signal');

subplot(2, 1, 2);
plot(ks, abs(fftshift(St))/max(abs(St)), 'r');
set(gca, 'XLim', [0 2e3]);
xlabel('Frequency [Hz]');
ylabel('Amplitude');
title('Fast Fourier Transform');

sgtitle('Handel Waveform and FFT');

saveas(gcf, 'Handel_Waveform_FFT.jpg');
close(gcf);

% Plot spectrogram over varying window sizes
a = [1; 20; 200];
tslide = 0:0.1:L;
Sgt_spec = zeros(length(tslide), n);

for j=1:length(tslide)
    g = exp(-a .* (t - tslide(j)) .^ 2);
    Sg = g .* S;
    for k=1:length(a)
        Sgt = fft(Sg(k, :));
        Sgt_spec(j, :, k) = fftshift(abs(Sgt));
    end
end

for j=1:length(a)
    f = figure(j);
    pcolor(tslide, ks, Sgt_spec(:, :, j).');
    shading interp;
    set(gca,'Ylim',[0 2e3]);
    colormap(hot);
    xlabel('Time [sec]');
    ylabel('Frequency [Hz]');
    title(sprintf('Handel Spectrogram with Window Size %d', a(j)));
    saveas(f, sprintf('Handel_a=%d.jpg', a(j)));
    close(f);
end

a = 20;
dt = [0.1; 1];
for i=1:length(dt)
    tslide = 0:dt(i):L;
    Sgt_spec = zeros(length(tslide), n);
    
    for j=1:length(tslide)
        g = exp(-a * (t - tslide(j)) .^ 2);
        Sg = g .* S;
        Sgt = fft(Sg);
        Sgt_spec(j, :) = fftshift(abs(Sgt));
    end
    
    f = figure(i);
    pcolor(tslide, ks, Sgt_spec(:, :).');
    shading interp;
    set(gca,'Ylim',[0 2e3]);
    colormap(hot);
    xlabel('Time [sec]');
    ylabel('Frequency [Hz]');
    title(sprintf('Handel Spectrogram with Translations of %0.1f', ...
    dt(i)));
    saveas(f, sprintf('Handel_dt=%0.1f.jpg', dt(i)));
    close(f);
end

%% Part 2.1 - Mary had a Little Lamb (piano)
clear variables; close all; clc;

[y,Fs] = audioread('music1.wav');

L = length(y)/4/Fs; n = length(y)/4;
t = (1:n)/Fs;
k=(Fs/n)*[0:n/2-1 -n/2:-1];
ks=fftshift(k);

S = y(1:n).';

f = figure(1);
plot((1:length(y))/Fs, y);
xlabel('Time [sec]');
ylabel('Amplitude');
title('Mary had a Little Lamb (piano)');
saveas(f, 'Piano_Waveform.jpg');
%close(f);

% Filter to just first 3 notes

s1 = zeros(1, n);
s1(32784:49745) = 1; % got indices from analyzing the plot

s2 = zeros(1, n);
s2(49657:75279) = 1;

s3 = zeros(1, n);
s3(76073:95301) = 1;

f = figure(2);
plot(t, s1 .* S, t, s2 .* S, t, s3 .* S);
xlabel('Time [sec]');
ylabel('Amplitude');
title('First 3 Notes (piano)');
saveas(f, 'Piano_3_Notes_Waveform.jpg');
close(f);

S1t = fft(s1 .* S);
S2t = fft(s2 .* S);
S3t = fft(s3 .* S);

f = figure(3);
subplot(3,1,1);
plot(ks, abs(fftshift(S1t))/max(abs(S1t)), 'LineWidth', 2); axis([0 2e3 0 1]);
xlabel('Frequency [Hz]');
ylabel('Amplitude');
title('First Note Frequency');
subplot(3,1,2);
plot(ks, abs(fftshift(S2t))/max(abs(S2t)), 'r', 'LineWidth', 2); axis([0 2e3 0 1]);
xlabel('Frequency [Hz]');
ylabel('Amplitude');
title('Second Note Frequency');
subplot(3,1,3);
plot(ks, abs(fftshift(S3t))/max(abs(S3t)), 'g', 'LineWidth', 2); axis([0 2e3 0 1]);
xlabel('Frequency [Hz]');
ylabel('Amplitude');
title('Third Note Frequency');
sgtitle('Frequencies of First 3 Notes (piano)');
saveas(f, 'Piano_Frequencies.jpg');
close(f);

[~, s1_max_idx] = max(abs(S1t)); s1_freq = k(s1_max_idx)
[~, s2_max_idx] = max(abs(S2t)); s2_freq = k(s2_max_idx)
[~, s3_max_idx] = max(abs(S3t)); s3_freq = k(s3_max_idx)

%% Part 2.2 Mary had a Little Lamb (recorder)
clear variables; close all; clc;

[y,Fs] = audioread('music2.wav');

L = length(y)/4/Fs; n = length(y)/4;
t = (1:n)/Fs;
k=(Fs/n)*[0:n/2-1 -n/2:-1];
ks=fftshift(k);

S = y(1:n).';

f = figure(1);
plot((1:length(y))/Fs, y);
xlabel('Time [sec]');
ylabel('Amplitude');
title('Mary had a Little Lamb (recorder)');
saveas(f, 'Recorder_Waveform.jpg');
close(f);

% Filter to just first 3 notes

s1 = zeros(1, n);
s1(1621:20877) = 1; % got indices from analyzing the plot

s2 = zeros(1, n);
s2(20877:40815) = 1;

s3 = zeros(1, n);
s3(40815:59359) = 1;

f = figure(2);
plot(t, s1 .* S, t, s2 .* S, t, s3 .* S);
xlabel('Time [sec]');
ylabel('Amplitude');
title('First 3 Notes (recorder)');
saveas(f, 'Recorder_3_Notes_Waveform.jpg');
close(f);

S1t = fft(s1 .* S);
S2t = fft(s2 .* S);
S3t = fft(s3 .* S);

f = figure(3);
subplot(3,1,1);
plot(ks, abs(fftshift(S1t))/max(abs(S1t)), 'LineWidth', 2); axis([0 3.5e3 0 1]);
xlabel('Frequency [Hz]');
ylabel('Amplitude');
title('First Note Frequency');
subplot(3,1,2);
plot(ks, abs(fftshift(S2t))/max(abs(S2t)), 'r', 'LineWidth', 2); axis([0 3.5e3 0 1]);
xlabel('Frequency [Hz]');
ylabel('Amplitude');
title('Second Note Frequency');
subplot(3,1,3);
plot(ks, abs(fftshift(S3t))/max(abs(S3t)), 'g', 'LineWidth', 2); axis([0 3.5e3 0 1]);
xlabel('Frequency [Hz]');
ylabel('Amplitude');
title('Third Note Frequency');
sgtitle('Frequencies of First 3 Notes (recorder)');
saveas(f, 'Recorder_Frequencies.jpg');
close(f);

[s1_max, s1_max_idx] = max(abs(S1t)); s1_freq = k(s1_max_idx)
[s2_max, s2_max_idx] = max(abs(S2t)); s2_freq = k(s2_max_idx)
[s3_max, s3_max_idx] = max(abs(S3t)); s3_freq = k(s3_max_idx)