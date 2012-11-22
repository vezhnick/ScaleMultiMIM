FeatWeight = sparse(size(Features,1), TotalLabels);

L_weights = freq / sum(freq);

L_table = zeros(33, size(Features,2));

for l =  1 : 33
    %L_table(l,:) = p_per_sp .* (new_labels == l)  + 1;% / freq(l);% L_weights(l);  %freq;
    L_table(l,:) = (new_labels == l)  + 10;
end

L_table = sparse(L_table');


% inv_mass = 1 ./ sum(FeatWeight');
% inv_mass(isinf(inv_mass)) = 0;
% Proxy = sparse(length(inv_mass),length(inv_mass));
% Proxy = spdiags(inv_mass',0, Proxy);
% 
% 
% NewPot = Features'* Proxy * FeatWeight;
% NewPot = full(NewPot);

% Proxy = sparse(length(p_per_sp),length(p_per_sp));
% Proxy = spdiags(p_per_sp,0, Proxy);

FeatWeight = Features * L_table;


for c = 1 : size(FeatWeight,2)
    if(sum(FeatWeight(:,c)) > 0)
        FeatWeight(:,c) = FeatWeight(:,c) / sum(FeatWeight(:,c)) / freq(c);
    end
end

NewPot = Features' * FeatWeight;
%NewPot = Proxy *Features' *  FeatWeight;
NewPot = full(NewPot);

for p = 1 : length(NewPot)
    NewPot(p,:) = NewPot(p,:) / sum(NewPot(p,:));
end

