NewPot = zeros(size(Features,2), TotalLabels);
for im = 1 : length(ImageToSpIdx)
    intern_idx = [ImageToSpIdx{im}.offset + 1: ImageToSpIdx{im}.offset + ImageToSpIdx{im}.tot_sp];
    sp_labels = new_labels(intern_idx);
    
    FeatWeight = zeros(size(Features,1), TotalLabels);
    %TODO - remove Labels! should be new_labels! Test Code! Labels
    for l = 1 : TotalLabels
        FeatWeight(:,l) = Features(:,intern_idx) * ((ILP(intern_idx,l)' == 1)' + 1);%(new_labels(intern_idx) == l) + 1; %P(w|y)
    end
    
    tot_f = sum(FeatWeight,1).* freq;
    FeatWeight = FeatWeight ./ (repmat(tot_f, size(FeatWeight,1),1));
    NewPot(intern_idx,:) = Features(:,intern_idx)' * (FeatWeight);

end


% tot_f = sum(FeatWeight,1).* freq;
% FeatWeight = FeatWeight ./ (repmat(tot_f, size(FeatWeight,1),1));
% NewPot = Features' * (FeatWeight);

for p = 1 : length(NewPot)
    NewPot(p,:) = NewPot(p,:) / sum(NewPot(p,:));
end