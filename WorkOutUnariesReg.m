FeatWeight = zeros(size(Features,1), TotalLabels);
for l = 1 : TotalLabels
    FeatWeight(:,l) = Features * (new_labels == l) + 1; %P(w|y)
end

tot_f = sum(FeatWeight,1).* freq;
FeatWeight = FeatWeight ./ (repmat(tot_f, size(FeatWeight,1),1));
NewPot = Features' * (FeatWeight);

%No weighting by the size of the SP!
% for p = 1 : length(NewPot)
%     NewPot(p,:) = NewPot(p,:) / sum(NewPot(p,:));
% end

