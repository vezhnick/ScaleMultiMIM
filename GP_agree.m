clear;
summary = REDU_MeasureAgreement('.\Results\MegaRFZombie\init_file_2f.mat', '.\Results\MegaRFZombie\output', ones(1,33));
load .\Results\MegaRFZombie\init_file_2f;

%%
grid = zeros(7,20);
idx = [];
k = 1;
for i = 1 : length(alpha)
%     if(abs(alpha{i}(1) - 0.24) < 0.005)
        grid(:,k) = alpha{i};
        idx = [idx i];
        k = k + 1;
%     end
end

%%
% finest_grid = zeros(4,20); %)
i = 1;
% 
% alpha_kernels = cover_simplex(3,[0.0:0.01:1],1);
% k = 1;
% for alpha_unary = 0.24%:0.005:0.3
%     for j = 1 : length(alpha_kernels)
%         finest_grid(:,k) = [alpha_unary alpha_kernels{j}];
%         k = k + 1;
%     end
% end

% transfer_cost_n = summary.transfer_cost + 34 * summary.miss;
% transfer_cost_n = transfer_cost_n / max(transfer_cost_n);
% transfer_cost_n = 1 - transfer_cost_n;

measurements = summary.tot_per_class_aggr * 10000;

finest_grid = grid;

grid = grid(:,[15  100]);
full_measurements = measurements;
measurements = measurements(1,[15 100 ]);
%%
iter_num = 100;
%figure;


% [rounds_vs_max measurements_new cov_evolit_is_const] = ...
%     SearchGridGP_randomized(grid, finest_grid, full_measurements, measurements,iter_num, 1);

[rounds_vs_max measurements_new cov_evolve it_is_const] = SearchGridGP(grid, finest_grid, full_measurements, measurements,iter_num, 0.01, false);
% for beta = [0.001 0.01 0.1 1 ]
%     [rounds_vs_max measurements_new] = SearchGridGP(grid, finest_grid, full_measurements, measurements,iter_num, beta);
%     plot(rounds_vs_max, 'b');
% hold on
% end
figure
plot(rounds_vs_max, 'b');
hold on
% legend('0.001', '0.01', '0.1', '1');

%%
iter_num = 100;
%figure;


% [rounds_vs_max measurements_new cov_evolit_is_const] = ...
%     SearchGridGP_randomized(grid, finest_grid, full_measurements, measurements,iter_num, 1);

[rounds_vs_max measurements_new cov_evolve it_is_const] = SearchGridGP(grid, finest_grid, full_measurements, measurements,iter_num, 0.01, true);
% for beta = [0.001 0.01 0.1 1 ]
%     [rounds_vs_max measurements_new] = SearchGridGP(grid, finest_grid, full_measurements, measurements,iter_num, beta);
%     plot(rounds_vs_max, 'b');
% hold on
% end
%figure
plot(rounds_vs_max, 'g');

% legend('0.001', '0.01', '0.1', '1');

%%
iter_num = 150
rounds_vs_max = zeros(1,iter_num + 1);
for i = 1 : 100
    [rounds_vs_max_cur measurements_cur] = SearchGridRandom(grid, finest_grid, full_measurements, measurements, iter_num);
    rounds_vs_max = rounds_vs_max + rounds_vs_max_cur;
end

plot(rounds_vs_max / 100, 'r');

title('Weakly supervised learning');
Xlabel('queried points');
Ylabel('found optimum / global optimum');