function TestPrediction = GP_ILP(ImagesDB, train_idx, test_idx)
%%
% train_idx = [1:2:length(ImagesDB)];
% test_idx = [2:2:length(ImagesDB)];

TrainDB = ImagesDB(train_idx);
TestDB = ImagesDB(test_idx);

X = zeros(length(ImagesDB{1}.Features{1}), length(train_idx));

for i = 1 : length(ImagesDB)
    X(:, i) = ImagesDB{i}.Features{1};
end

X_train = X(:,train_idx);
X_test = X(:,test_idx);

Y_train = zeros(33, size(X_train,2));

for i = 1 : length(TrainDB)
    for l = TrainDB{i}.labels'
        Y_train(l,i) = 1;
    end
end

Y_test = zeros(33, size(X_test,2));
Y_test_gt = zeros(33, size(X_test,2));
for i = 1 : length(TestDB)
    for l = TestDB{i}.labels'
        Y_test_gt(l,i) = 1;
    end
end

%% 
%gp setup

%length = -5; % Number of iterations in minimizatino procedure (-n means that it is not more than n)
covFunc = 'covSEard'; % covariance function (kernel)
likFunc = 'likGauss'; % likelihood function
infFunc = 'infExact'; % inference function
meanFunc ='meanZero'; % mean function
hyp = [];

% Default values for GP hyperparameters
if (isempty(hyp))
    if (strcmp(covFunc,'covSEard'))
        hyp.cov = zeros(size(X,1)+1,1);
        %hyp.cov(1) = 0;
    elseif (strcmp(covFunc,'covLINard'))
        hyp.cov = zeros(size(X,1),1);
        %hyp.cov(1) = 0;
    elseif (strfind(covFunc,'iso'))
        hyp.cov = zeros(str2double(feval(covFunc)),1);
        %hyp.cov(1) = 0.1;
    else
        errormsg('Specify correct number of hyperparameters for non-isotropic covariance function');
    end   
    
    hyp.mean = zeros(str2double(feval(meanFunc)),1);
    hyp.lik = (log(0.1)/3)*ones(str2double(feval(likFunc)),1);
end


% -------------------------------------------------------------------------
% Optimization
% -------------------------------------------------------------------------


for l = 1 : 33
    
    % Hyperparameters optimization
        
%    hyp = minimize(hyp,@gp,length,infFunc, meanFunc, covFunc, likFunc, X_train', Y_train(l,:)');
    hyp.cov = hyp.cov * 0  + 1;
    [F_tmp, sig] =  gp(hyp, infFunc, meanFunc, covFunc, likFunc, X_train', Y_train(l,:)', X_test');
    
    Y_test(l,:) = F_tmp';
end

TestPrediction = Y_test';

for i = 1 : size(Y_test,2)
    TestPrediction(i,:) = Y_test(:,i)' + min(Y_test(:,i));
    TestPrediction(i,:) = TestPrediction(i,:) / sum(TestPrediction(i,:));
end
    