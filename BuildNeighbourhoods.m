load LabelMeGlobalFeat;
IdxA = (1:2:length(ImagesDB));
IdxB = (2:2:length(ImagesDB));
ImagesDB_A = ImagesDB(IdxA);
ImagesDB_B = ImagesDB(IdxB);
clear ImagesDB

k = 10;
[NeibsA, ImagesDB_A] = FindNeibours(ImagesDB_A, k);
[NeibsB, ImagesDB_B] = FindNeibours(ImagesDB_B, k);
% [TestPredictionB NeibsB] = TagProp(ImagesDB_A, ImagesDB_B, k);
% [TestPredictionA NeibsA] = TagProp(ImagesDB_B, ImagesDB_A, k);
%%
load Index

PerImageNeibs(IdxA, :) = IdxA(NeibsA);
PerImageNeibs(IdxB, :) = IdxB(NeibsB);

save('Neighbourhoods.mat', 'PerImageNeibs');