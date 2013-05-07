TestDetect;

freq_bins = 4096;
fft_r1 = 10*log10(abs(fft(rrains(:,1), freq_bins)));
fft_r1 = fft_r1(1:round(end/2));
fft_r2 = 10*log10(abs(fft(rrains(:,2), freq_bins)));
fft_r2 = fft_r2(1:round(end/2));

freqs = (1:numel(fft_r1))*22050/numel(fft_r1);

f = figure;
subplot(2,1,1);
plot(freqs, fft_r1);
title('Rain Sample 1 FFT');
xlabel('Frequency Hz');
ylabel('Magnitude (db)');

subplot(2,1,2);
plot(freqs, fft_r2);
title('Rain Sample 2 FFT');
xlabel('Frequency Hz');
ylabel('Magnitude (db)');

print(f, './Report/rainFreq.eps');


f = figure;
im = imread('./Report/blocks.png');
imshow(im);
print(f,'./Report/blocks.eps');
