FeatWeight = sparse(size(Features,1), TotalLabels);

%L_weights = freq / sum(freq);

L_table = zeros(33, sum(idx_train));

for l =  1 : 33
    freq_n(l) = sum(train_labels == l - 1 );
    %L_table(l,:) = p_per_sp(idx_train) .* (train_labels == l - 1) + 1;% * L_weights(l);  %freq;
    L_table(l,:) = (train_labels == l - 1) + 10;

end

L_table = sparse(L_table');

FeatWeight = Features(:,idx_train) * L_table;

for c = 1 : size(FeatWeight,2)
    if(sum(FeatWeight(:,c)) > 0)
        FeatWeight(:,c) = FeatWeight(:,c) / sum(FeatWeight(:,c));% / freq_n(c);
    end
end

NewPot = Features' * FeatWeight;
NewPot = full(NewPot);

for p = 1 : length(NewPot)
    NewPot(p,:) = NewPot(p,:) / sum(NewPot(p,:));
end


% inv_mass = 1 ./ sum(FeatWeight');
% inv_mass(isinf(inv_mass)) = 0;
% Proxy = sparse(length(inv_mass),length(inv_mass));
% Proxy = spdiags(inv_mass',0, Proxy);
% 
% 
% NewPot = Features'* Proxy * FeatWeight;
% NewPot = full(NewPot);
