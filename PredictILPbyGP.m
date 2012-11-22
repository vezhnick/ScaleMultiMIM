load LabelMeGlobalFeat;
IdxA = (1:2:length(ImagesDB));
IdxB = (2:2:length(ImagesDB));
% ImagesDB_A = ImagesDB(IdxA);
% ImagesDB_B = ImagesDB(IdxB);
%clear ImagesDB

k = 5;

TestPredictionB = GP_ILP(ImagesDB, IdxA, IdxB);
TestPredictionA = GP_ILP(ImagesDB, IdxB, IdxA);
%%
load Index

PerImageILP = zeros(length(Index), size(TestPredictionA,2));
% PerImageNeibs = zeros(length(Index), k);

PerImageILP(IdxA, :) = TestPredictionA;
PerImageILP(IdxB, :) = TestPredictionB;

% PerImageNeibs(IdxA, :) = IdxB(NeibsA);
% PerImageNeibs(IdxB, :) = IdxA(NeibsB);


predILP = zeros(TotalSP, size(PerImageILP, 2));

for i = 1 : size(Index,2)
    predILP(Index{i}.offset+1 : Index{i}.offset + Index{i}.tot_sp, :) = repmat( PerImageILP(i,:), Index{i}.tot_sp, 1);
end

save('predILP_GP.mat', 'predILP');
% save('Neibs.mat', 'PerImageNeibs');