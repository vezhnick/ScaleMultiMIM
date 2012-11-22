FeatWeight = zeros(size(Features,1), TotalLabels);
for l = 1 : TotalLabels
    FeatWeight(:,l) = Features(:,idx_train) * (train_labels == l - 1) + 10; %P(w|y)
end
%LeafPot = LeafPot .* repmat(freq, size(LeafPot,1),1);

tot_f = sum(FeatWeight,1);%.* freq;
FeatWeight = FeatWeight ./ (repmat(tot_f, size(FeatWeight,1),1));
NewPot = Features' * (FeatWeight);
%NewPot = NewPot .* ILP;

%NewPot = NewPot .* (OP_mtx);
%[junk init] = max(NewPot(:,1:end)');

for p = 1 : length(NewPot)
    NewPot(p,:) = NewPot(p,:) / sum(NewPot(p,:));
end
