FeatWeight = zeros(size(Features,1), TotalLabels);
%tmp = (Features*Features')^-1;

for l = 1 : TotalLabels
    FeatWeight(:,l) = Features * (new_labels == l) + 1; %P(w|y)
end

tot_f = sum(FeatWeight,1).* freq;
%tot_f = freq / min(freq);
FeatWeight = FeatWeight ./ (repmat(tot_f, size(FeatWeight,1),1));
NewPot = Features' * (FeatWeight);
% for c = 1 : size(NewPot,2)
%     
%     Y(c) = quantile(NewPot(NewPot(:,c) ~= 0,c),0.95,1);
%     if(Y(c) > 0)
%         NewPot(:,c) = NewPot(:,c) / Y(c);
%     end
% end

for p = 1 : length(NewPot)
    NewPot(p,:) = NewPot(p,:) / sum(NewPot(p,:));
end


%NewPot = NewPot .* (OP_mtx);
%[junk init] = max(NewPot(:,1:end)');