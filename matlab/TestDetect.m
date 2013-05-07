
clear all
close all
GetData;


d = Detector();

RainIntensities = cell(size(rrains, 2), 1);
BackgroundIntensities = cell(size(bckrnd, 2), 1);
NoiseIntensities = cell(size(rand_noise, 2), 1);

times = (1:(rain_len/d.ChunkLength + 1))*d.ChunkLength/Fs;

f = figure;
for i = 1:numel(RainIntensities)
    subplot(2,2,i);
    RainIntensities{i} = d.DoDetection(rrains(:,i));
    area(times, RainIntensities{i});
    xlabel('time (s)');
    ylabel('intensity');
    title(sprintf('Rain Sample %d', i));
    
    d.Reset();
end
set(f, 'Position', [100,100,500,250]);
print(f,'./Report/truePositives.eps');

f = figure;
for i = 1:numel(BackgroundIntensities)
    subplot(4,2,i);
    BackgroundIntensities{i} = d.DoDetection(bckrnd(:,i));
    area(times, BackgroundIntensities{i});
    xlabel('time (s)');
    ylabel('intensity');
    title(sprintf('Background Noise Sample %d', i));
    
    if (find(BackgroundIntensities{i}))
        fprintf(1, 'Found false positive in background noise %d.\n', i);
    end
    
    d.Reset();
end
print(f,'./Report/falsePositives.eps');


f = figure;
for i = 1:numel(NoiseIntensities)
    subplot(3,1,i);
    NoiseIntensities{i} = d.DoDetection(rand_noise(:,i));
    area(times, NoiseIntensities{i});
    xlabel('time (s)');
    ylabel('intensity');
    title(sprintf('Random Noise Sample %d', i));
    
    if (find(NoiseIntensities{i}))
        fprintf(1, 'Found false positive in random noise %d.\n', i);
    end
    
    d.Reset();
end
print(f,'./Report/noiseTest.eps');

f = figure;
I = d.DoDetection(long_mix);
area((1:(numel(long_mix)/d.ChunkLength + 1))*d.ChunkLength/Fs, I);
xlabel('time (s)');
ylabel('intensity');
title('Mix of Rain and background noise.');
set(f, 'Position', [100,100,500,150]);
print(f,'./Report/longTest.eps');