function [rounds_vs_max measurements cov_evolve it_is_const] = SearchGridGP_randomized(grid, finest_grid, full_measurements, measurements, iter_num, beta)
if(isempty(beta))
    beta = 0.1;
end

[x_new F_app x_ind hyp] = BayesOpt(grid', measurements', finest_grid','minimize','true','covFunc','covSEard','length',-20, 'beta', beta);

cov_evolve = hyp.cov;

x_old = x_new * 0;

rounds_vs_max = zeros(1,iter_num+1);

normalizer = (max(full_measurements) - min(full_measurements));
rounds_vs_max(1) = max(measurements);

grid_known = zeros(1, length(full_measurements)) == 1;
k = 1;

it_is_const = 0;
for i = 1 : iter_num
    
    i;
    if( sum(x_old ~= x_new) ~= 0)
        results =  full_measurements(x_ind);%MeasureAgreement(Files, features_names, ImIdxA, ImIdxB, K,L, x_new);
    end
    
    grid = [grid x_new'];
    
    measurements = [measurements results];%mean(results.F_score) * 10000];
    x_old = x_new;
    
    [x_new F_app x_ind hyp] =  BayesOpt(grid', measurements', finest_grid','minimize','true','covFunc','covSEard','length',-30, 'beta', beta);%, 'hyp', hyp);
    
    x_ind = draw_with_prob(F_app);
    x_new = finest_grid(:,x_ind)';
    
    cov_evolve = [cov_evolve hyp.cov];

%     while grid_known(x_ind) == true
% %         rounds_vs_max(i+1:end) = max(measurements);
% %         rounds_vs_max = ((rounds_vs_max(1:i+1) - min(full_measurements)) / normalizer);
% %         return;
%         grid = [grid x_new'];
%         results =  full_measurements(x_ind);
%         measurements = [measurements results];
%         [x_new F_app x_ind hyp] =  BayesOpt(grid', measurements', finest_grid','minimize','true','covFunc','covSEard','length',-3, 'beta', beta, 'hyp', hyp);
%         %betta = betta * 10;
%         cov_evolve = [cov_evolve hyp.cov];
%         hyp.cov(end) =  hyp.cov(end) * 1.10;
%         it_is_const(k) = 1;
%         k = k+1;        
%     end
    
    grid_known(x_ind) = true;
    
    disp(['mean squared error = ' num2str(mean((F_app - full_measurements').^2)) ' , current max = ' num2str(max(measurements))]);
    rounds_vs_max(i+1) = max(measurements);
    if ( (max(measurements )- min(full_measurements)) / normalizer  > 0.9999)
        rounds_vs_max(i+1:end) = max(measurements);
        break;
    end
    it_is_const(k) = 0;
    k = k + 1;
    if( k  > iter_num*4)
        rounds_vs_max = ((rounds_vs_max(1:i+1) - min(full_measurements)) / normalizer);
        return;
    end
end
k
i
rounds_vs_max = ((rounds_vs_max(1:i+1) - min(full_measurements)) / normalizer);
