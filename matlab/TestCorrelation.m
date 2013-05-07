function [corrData] = TestCorrelation(golden, toCompare)

corM = corr([golden, toCompare]);
corrData = corM(:,1);

end