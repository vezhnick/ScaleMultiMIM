clear;
load LabelMeGlobalFeatTest;
load IndexTest

ImagesDB_Tr = ImagesDB(train_idx);
ImagesDB_Tst = ImagesDB(test_idx);
clear ImagesDB

k = 5;

[TestPredictionTst NeibsTst] = TagProp(ImagesDB_Tr, ImagesDB_Tst, k);
save('TestPredictionILP.mat');
%%
load IndexTest

PerImageILP = zeros(length(Index), size(TestPredictionTst,2));
PerImageNeibs = zeros(length(Index), k);

PerImageILP(test_idx, :) = TestPredictionTst;

PerImageNeibs(test_idx, :) = train_idx(NeibsTst);


predILP = zeros(TotalSP, size(PerImageILP, 2));

for i = 1 : size(Index,2)
    predILP(Index{i}.offset+1 : Index{i}.offset + Index{i}.tot_sp, :) = repmat( PerImageILP(i,:), Index{i}.tot_sp, 1);
end

save('predILPTest.mat', 'predILP');
save('NeibsTest.mat', 'PerImageNeibs');