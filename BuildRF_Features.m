clear;

TotLeaf = [];
Dir = './Trees/ERHF_100/';
for i = 1 : 200
    i
    if exist([Dir 'tree_' num2str(i) '_LID.mat']);
        load([Dir 'tree_' num2str(i) '_LID.mat']);
    
        LeafId = sparse(LeafId);
        LeafId = LeafId * 1.0;
        TotLeaf = cat(1,TotLeaf, LeafId);
    end
end
Features = TotLeaf;
save('ERHF_FeaturesTest.mat', 'Features');

Features = Features(:,1:159238);
save('ERHF_Features.mat', 'Features');
