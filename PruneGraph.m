function Gr_tot = PruneGraph(Gr_tot, threshold)

Gr_tot = max(Gr_tot, Gr_tot');

tst = sum(Gr_tot ~= 0);

for i = 1 : length(Gr_tot)
    disp(num2str(i))
    if(tst(i) > threshold)
        [val idx] = sort(Gr_tot(i,:), 'descend');
        %Gr_tot(i,:) = 0;
        temp = zeros(1, length(Gr_tot));
        temp(idx(1:threshold)) = val(1:threshold);
        Gr_tot(i,:) = temp;
        Gr_tot(:,i) = temp;
    end
end
