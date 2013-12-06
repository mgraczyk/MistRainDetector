% Read in sample rain file and clip a short amount
[rain_sound, Fs, Nbits] = wavread('rain.wav');
rain_sound = rain_sound(2000000:2500000,:);
white_noise = wgn(100000,1, -22);

figure(1);
subplot(2,2,1);
spectrogram(rain_sound(200000:300000,1), hamming(100), 0, 512, Fs);
title('Rain Spectrogram');

subplot(2,2,2);
spectrogram(white_noise, hamming(100), 0, 512, Fs);
title('WGN Spectrogram');

% Make some phase noise
a = zeros(1,100);
a(1) = 1;
for ii = 2:100
a(ii) = (ii - 2.5) * a(ii-1) / (ii-1);
end
theta = filter(1,a,white_noise);
phase_noise = exp(1.0i*theta);
subplot(2,2,3);
spectrogram(phase_noise, hamming(100), 0, 512, Fs);
title('Phase Noise');

% Read some Brown Noise
[brown_noise FsB, ~] = wavread('brownnoise.wav');
brown_noise = brown_noise(1:100000);
subplot(2,2,4);
spectrogram(brown_noise, hamming(100), 0, 512, Fs);
title('Brown Noise');