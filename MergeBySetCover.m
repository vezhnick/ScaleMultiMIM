covered = zeros(size(ConsModelIdx,1),1);

selected = zeros(size(ConsModelIdx,2),1);

models_in_order = [];

for i = 1 : 20
    disp(['iteration = ' num2str(i) ', covered sp = ', num2str(sum(covered))]);
    model_cover = ~covered' * ConsModelIdx;
    [max_val, max_id] = max(model_cover);
    selected(max_id) = 1;
    covered = ( ConsModelIdx * selected ) > 0;
    models_in_order = [models_in_order max_id];
end


