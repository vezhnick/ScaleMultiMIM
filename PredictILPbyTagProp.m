load LabelMeGlobalFeat;
IdxA = (1:2:length(ImagesDB));
IdxB = (2:2:length(ImagesDB));
ImagesDB_A = ImagesDB(IdxA);
ImagesDB_B = ImagesDB(IdxB);
clear ImagesDB

k = 5;

[TestPredictionB NeibsB] = TagProp(ImagesDB_A, ImagesDB_B, k);
[TestPredictionA NeibsA] = TagProp(ImagesDB_B, ImagesDB_A, k);
%%
load Index

PerImageILP = zeros(length(Index), size(TestPredictionA,2));
PerImageNeibs = zeros(length(Index), k);

PerImageILP(IdxA, :) = TestPredictionA;
PerImageILP(IdxB, :) = TestPredictionB;

PerImageNeibs(IdxA, :) = IdxB(NeibsA);
PerImageNeibs(IdxB, :) = IdxA(NeibsB);


predILP = zeros(TotalSP, size(PerImageILP, 2));

for i = 1 : size(Index,2)
    predILP(Index{i}.offset+1 : Index{i}.offset + Index{i}.tot_sp, :) = repmat( PerImageILP(i,:), Index{i}.tot_sp, 1);
end

save('predILP.mat', 'predILP');
save('Neibs.mat', 'PerImageNeibs');