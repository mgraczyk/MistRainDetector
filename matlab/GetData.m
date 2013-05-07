addpath('Code');
rain1 = wavread('./data/rain1.wav');
rain1 = mean(rain1,2);
rain2 = wavread('./data/rain2.wav');
rain2 = mean(rain2,2);
rain3 = wavread('./data/rain3.wav');
rain3 = mean(rain3,2);
rain4 = wavread('./data/rain4.wav');
rain4 = mean(rain4,2);
rrain1 = wavread('./data/rrain1.wav');
rrain2 = audioread('./data/rrain2.wav');
rrain3 = audioread('./data/rrain3.wav');
rrain4 = audioread('./data/rrain4.wav');

bckrnd1 = audioread('./data/background1.wav');
bckrnd2 = audioread('./data/background2.wav');
bckrnd3 = audioread('./data/background3.wav');
bckrnd4 = audioread('./data/background4.wav');
bckrnd5 = audioread('./data/background5.wav');
bckrnd6 = audioread('./data/background6.wav');
bckrnd7 = audioread('./data/background7.wav');
bckrnd8 = audioread('./data/background8.wav');

long_mix = audioread('./data/longMix.wav');

Fs = 44100;
rain_len = 661500;

wnoise = randn(rain_len,1);
bnoise = cumsum(randn(rain_len,1),1);
unoise = 2*rand(rain_len,1) - 0.5;

rains = [rain1(1:rain_len), rain2(1:rain_len), rain3(1:rain_len), rain4(1:rain_len)];
rrains = [rrain1(1:rain_len), rrain2(1:rain_len), rrain3(1:rain_len), rrain4(1:rain_len)];
bckrnd=[bckrnd1(1:rain_len), bckrnd2(1:rain_len), bckrnd3(1:rain_len), bckrnd4(1:rain_len), bckrnd5(1:rain_len), bckrnd6(1:rain_len),...
    bckrnd7(1:rain_len), bckrnd8(1:rain_len)];
rand_noise = [wnoise, bnoise, unoise];

clear rain1 rain2 rain3 rain4;
clear rrain1 rrain2 rrain3 rrain4;
clear bckrnd1 bckrnd2 bckrnd3 bckrnd4 bckrnd5 bckrnd6 
clear wnoise bnoise unoise;

% if (~doPlot)
%     return
% end
% 
% figure
% for i=1:4
%     subplot(2,2,i);
%     plot(fft_rains(:,i));
%     title(sprintf('Rain %d', i));
% end
% 
% figure
% for i=1:4
%     subplot(2,2,i);
%     plot(fft_rrains(:,i));
%     title(sprintf('Real Rain %d', i));
% end
% 
% figure;
% for i=1:size(bckrnd,2)
%     subplot(3,2,i);
%     plot(fft_bkrnd(:,i));
%     title(sprintf('Background Noise %d', i));
% end
% 
% figure;
% for i=1:2
%     subplot(1,2,i);
%     plot(fft_randn(:,i));
%     title(sprintf('Random Noise %d', i));
% end
