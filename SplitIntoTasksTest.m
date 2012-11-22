clear;
load LabelMeGlobalFeatTest;

k = 200;

train_idx = 1 : 2488;
test_idx = 2489:2688;

Neibs = ComputeNeighbours(ImagesDB(train_idx), ImagesDB(test_idx), k);
%%
load IndexTest

SPtoImage = zeros(TotalSP, 1);

for i = 1 : size(Index,2)
    SPtoImage(Index{i}.offset+1 : Index{i}.offset + Index{i}.tot_sp, :) = i;
end
%%
save TasksAndNeibsTest