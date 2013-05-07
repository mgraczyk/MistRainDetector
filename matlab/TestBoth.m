GetData;

d = Detector;
golden = d.MyFilter(rrains(:,1));

for i=1:2
    if (i==1)
        false_positives = TestCorrelation(golden, d.MyFilter(bckrnd));
        disp(false_positives);
    else
        positives = TestCorrelation(golden, d.MyFilter(rrains));
        disp(positives);
    end
end
