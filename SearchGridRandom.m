function [rounds_vs_max measurements] = SearchGridRandom(grid, finest_grid, full_measurements, measurements, iter_num)
%close all;

x_ind = randi(length(finest_grid));
x_new = finest_grid(:,x_ind);

%%
rounds_vs_max = zeros(1,iter_num);

normalizer = (max(full_measurements) - min(full_measurements));
rounds_vs_max(1) = max(measurements);
for i = 1 : iter_num
    
    results =  full_measurements(x_ind);%MeasureAgreement(Files, features_names, ImIdxA, ImIdxB, K,L, x_new);
    
    grid = [grid x_new];
    
    measurements = [measurements results];%mean(results.F_score) * 10000];
    x_old = x_new;
    x_ind = randi(length(finest_grid));
    x_new = finest_grid(:,x_ind);
    
    %disp(['current max = ' num2str(max(measurements))]);
    rounds_vs_max(i+1) = max(measurements);
%     if ( (max(measurements )- min(full_measurements)) / normalizer  > 0.99)
%         break;
%     end
end

rounds_vs_max = (rounds_vs_max(1:i+1) - min(full_measurements)) / normalizer;