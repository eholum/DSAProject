clearvars;
close all;
clear plot;



zc_threshold = 0.100; % zero_crossings / num_samples
en_threshold = 0.075; % Energy threshold
silence_en_threshold = 0.03; % Silence energy threshold

sound_file = 'holum.wav';
[speech, fs] = audioread(sound_file);

% Identify voiced, unvoiced, and silence from basic recording
[voiced, unvoiced, silence, t] = part_3(speech, fs, zc_threshold, en_threshold, silence_en_threshold);

% First part, just identify silence, voiced, unvoiced
%{
hold off;
plot(t, voiced, 'b');
hold on;
plot(t, unvoiced, 'r');
plot(t, silence, 'g');
legend('voiced', 'unvoiced', 'silence')
xlabel('time (s)');
ylabel('Amp');
title('Plot of Voiced/Unvoiced/Silence for Standard Recording');
%}

% Try 5db of noise to recording and repeat part 3, really throws it all to
% hell, dropping out zero crossings makes it somewhat better.
%{
sound_file = 'noisy_speech.wav';
[speech, fs] = audioread(sound_file);

zc_threshold = 1; % zero_crossings / num_samples
en_threshold = 0.075; % Energy threshold
silence_en_threshold = 0.03; % Silence energy threshold

[voiced, unvoiced, silence, t] = part_3(speech, fs, zc_threshold, en_threshold, silence_en_threshold);

hold off;
plot(t, voiced, 'b');
hold on;
plot(t, unvoiced, 'r');
plot(t, silence, 'g');
legend('voiced', 'unvoiced', 'silence')
xlabel('time (s)');
ylabel('Amp');
title('Plot of Voiced/Unvoiced/Silence for Noisy Recording');
%}


% Part 5

% Removes zeroes from the returned vectors to get voiced, unvoiced and
% silence in stand alone vectors
s_voiced = voiced(voiced~=0);
s_unvoiced = unvoiced(unvoiced~=0);
s_silence = silence(silence~=0);

% Listen to selections
% soundsc(s_voiced, fs)
% soundsc(s_unvoiced, fs)
% soundsc(s_silence, fs)

N = length(s_silence)*2;
X = abs(fft(s_silence,N));
F = [-N/2:N/2-1]/N;
plot(F,X),
xlabel('frequency / f s')
grid;
title('Approximate Spectrum of Voiced Speech with FFT');