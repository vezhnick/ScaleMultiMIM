function [x_new, F_tmp, sig, x_ind, hyp]  = BayesBayesOpt(X, F, G, varargin)

% Interface:
%   x_new = BayesOpt(X, F, G, varargin)
%
% Function which takes set of points and grid (which specifies the search
% space) and returns the point with highest Expectation Utility.
% Arguments
%   X: EXAMPLES x FEATURES - known points
%   F: EXAMPLES x 1 - function values of known points
%   G: NumberOfGridPoints x FEATURES - Grid
%   varargin: various parameters described in Paramters section below
%
% Output
%   x_new: FEATURES x 1 - new data point
%   F_tmp: NumberOfGridPoints x 1 - mean of gp on the grid

% -------------------------------------------------------------------------
% Parameters
% -------------------------------------------------------------------------

% Default values of the paramteres
defaults.function = []; %'Real' function (only for visualization)
defaults.visualize = 'false'; % Whether intermediate results should be visualized or not (much slower), if FEATURES > 1 uses Grid index as X argument
defaults.minimize = 'true'; % Whether hyperparamteres of GP should be adapted or not
defaults.length = -5; % Number of iterations in minimizatino procedure (-n means that it is not more than n)
defaults.beta = 0.1;

defaults.covFunc = 'covSEiso'; % covariance function (kernel)
defaults.likFunc = 'likGauss'; % likelihood function
defaults.infFunc = 'infExact'; % inference function
defaults.meanFunc ='meanZero'; % mean function
defaults.hyp = [];
args = CatArgs(defaults,varargin);
defaults.beta = args.beta;
hyp = args.hyp;

% Default values for GP hyperparameters
if (isempty(hyp))
    if (strcmp(args.covFunc,'covSEard'))
        hyp.cov = zeros(size(X,2)+1,1);
        %hyp.cov(1) = 0;
    elseif (strcmp(args.covFunc,'covLINard'))
        hyp.cov = zeros(size(X,2),1);
        %hyp.cov(1) = 0;
    elseif (strfind(args.covFunc,'iso'))
        hyp.cov = zeros(str2double(feval(args.covFunc)),1);
        %hyp.cov(1) = 0.1;
    else
        errormsg('Specify correct number of hyperparameters for non-isotropic covariance function');
    end
    
    
    hyp.mean = zeros(str2double(feval(args.meanFunc)),1);
    hyp.lik = (log(0.1)/3)*ones(str2double(feval(args.likFunc)),1);
end

% -------------------------------------------------------------------------
% Optimization
% -------------------------------------------------------------------------

% Hyperparameters optimization

if (args.minimize)
    hyp = minimize(hyp,@gp,args.length,args.infFunc, args.meanFunc, args.covFunc, args.likFunc, X, F);
end

% GP inference
[F_tmp, sig] =  gp(hyp, args.infFunc, args.meanFunc, args.covFunc, args.likFunc, X, F, G);

% Estimation of Expected utility
xsi = 0;%mean(sig)/100;
disp(num2str(xsi));
mean(sig)
%hyp.cov
Z = (F_tmp - max(F) - xsi)./sig.^2;
%EI = (F_tmp - max(F) - xsi).*cdf('norm',Z,0,1) + sig.^2.*pdf('norm',Z,0,1);
EI = (F_tmp - max(F)) + defaults.beta * sig;
[~, x_ind] = max(EI);
x_new = G(x_ind,:);
%F_tmp = EI;


% Visualization, if FEATURES > 1 uses Grid index as X 

if (strcmp(args.visualize,'true'))
    clf reset
    ind = G';
    ind_x = X;
    if (size(X,2) >1)
        ind = 1:size(G,2);
        ind_x = [];
        for i=1:length(ind)
            if (G(i,:)==X(i,:))
                ind_x = [ind_x i];
            end
        end
    end
    fill([ind ind(end:-1:1)]',[F_tmp-EI; F_tmp(end:-1:1)+EI(end:-1:1)],'cyan')
    %  fill([ind ind(end:-1:1)]',[F_tmp-sig; F_tmp(end:-1:1)+sig(end:-1:1)],'cyan')
    
    hold on
    plot(ind,F_tmp)
    if isempty(args.function)
        plot(ind_x,F,'r');
        
    else
        plot(ind,args.function(ind),'r');
        
    end
    pause(0.1)
end
end


function args = CatArgs(defaults,args)

% This function concatenates default and user arguments

assert(length(args) - 2*floor(length(args)/2)==0);

for k = 1:floor(length(args)/2)
    if (findstr(args{2*k-1},'Func'))
        try eval(['defaults.' args{2*k-1} ' = ''' args{2*k} ''';']);
        catch
            error(['No default value for ' args{2*k-1}]);
        end
    elseif (findstr(args{2*k-1},'hyp'))
        try defaults.hyp = args{2*k};
        catch
            error(['No default value for ' args{2*k-1}]);
        end
    else
        try eval(['defaults.' args{2*k-1} ' = ' num2str(args{2*k}) ';']);
        catch
            error(['No default value for ' args{2*k-1}]);
        end
    end
end
args = defaults;
end

