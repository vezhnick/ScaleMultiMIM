clear;
load LabelMeGlobalFeat;

k = 200;

Neibs = ComputeNeighbours(ImagesDB, ImagesDB, k);
%%
load Index

SPtoImage = zeros(TotalSP, 1);

for i = 1 : size(Index,2)
    SPtoImage(Index{i}.offset+1 : Index{i}.offset + Index{i}.tot_sp, :) = i;
end

save TasksAndNeibs