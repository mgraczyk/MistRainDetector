function [ metric ] = ComputeFiltCorr(signal)
%COMPUTEFILTCORR Summary of this function goes here
%   Detailed explanation goes here
GetData;

golden = rrains(:,1);
thresh = 0.1;

golden_filtered = MyFilter(golden);
signal_filtered = MyFilter(signal);

sum_golden = sum(golden_filtered);
sum_signal = sum(signal_filtered);

if sum_signal < thresh*sum_golden
    metric = 0;
else    
    metric = corr(signal_filtered, golden_filtered);
end


end

