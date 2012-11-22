function [rounds_vs_max measurements cov_evolve it_is_const] = SearchGridGP(grid, finest_grid, full_measurements, measurements, iter_num, beta, adapt)
if(isempty(beta))
    beta = 0.1;
end

plotting = true;

noise_level = 8;

[x_new F_app sig x_ind hyp] = BayesOpt(grid', measurements', finest_grid','minimize','true','covFunc','covSEard','length',-20, 'beta', beta);

cov_evolve = hyp.cov;

x_old = x_new * 0;

rounds_vs_max = zeros(1,iter_num+1);

normalizer = (max(full_measurements) - min(full_measurements));
rounds_vs_max(1) = max(measurements);

grid_known = zeros(1, length(full_measurements)) == 1;
k = 1;
if plotting
    subplot(3,1,1)
    plot(full_measurements)
    
    hold on
    plot(x_ind, full_measurements(x_ind),  'r*')
    pause;
end
it_is_const = 0;
for i = 1 : iter_num
    
    i;
    if( sum(x_old ~= x_new) ~= 0)
        results =  full_measurements(x_ind);%MeasureAgreement(Files, features_names, ImIdxA, ImIdxB, K,L, x_new);
    end
    
    grid = [grid x_new'];
    
    measurements = [measurements results];%mean(results.F_score) * 10000];
    x_old = x_new;
    
    %hyp.cov(end) = noise_level;
    [x_new F_app sig x_ind hyp] =  BayesOpt(grid', measurements', finest_grid','minimize','true','covFunc','covSEard','length',-30, 'beta', beta);%, 'hyp', hyp);
    if plotting
        subplot(3,1,2)
        %plot(F_app);
        hold on
        %plot(F_app + sig * beta,'g');
        for k = 1 : size(cov_evolve,1)
            plot(cov_evolve(k,:), 'color',label2rgb(k)/255);
        end
        
        
        hold off
        subplot(3,1,3)
        plot(F_app);
        hold on
        plot(F_app + sig * beta,'g');
        hold off
        subplot(3,1,1)
    end
    
    cov_evolve = [cov_evolve hyp.cov];
    if plotting
        plot(x_ind, full_measurements(x_ind),  'r*')
    end
    pause(0.3);
    
    while grid_known(x_ind) == true
        %pause;
        %noise_level =  noise_level * 1.1;
        if adapt
            rounds_vs_max = ((rounds_vs_max(1:i) - min(full_measurements)) / normalizer);
            return;
        end
        hyp.cov(end) = hyp.cov(end) * 1.1;
        grid = [grid x_new'];
        results =  full_measurements(x_ind);
        measurements = [measurements results];
        if plotting
            plot(x_ind, full_measurements(x_ind),  'mo')
        end
        %hyp.cov(end) = noise_level;
        [x_new F_app sig x_ind hyp] =  BayesOpt(grid', measurements', finest_grid','minimize','true','covFunc','covSEard','length',-0, 'beta', beta, 'hyp', hyp);
        if plotting
            subplot(3,1,2)
            %plot(F_app, 'r');
            hold on
            %         plot(F_app + sig * beta,'g');
            for k = 1 : size(cov_evolve,1)
                plot(cov_evolve(k,:), 'color',label2rgb(k+10)/255);
            end
            
            hold off
            subplot(3,1,3)
            plot(F_app);
            hold on
            plot(F_app + sig * beta,'g');
            hold off
            subplot(3,1,1)
        
        
            %betta = betta * 10;
            plot(x_ind, full_measurements(x_ind),  'g*')
        end
        pause;
        cov_evolve = [cov_evolve hyp.cov];
        it_is_const(k) = 1;
        k = k+1;
    end
    
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
