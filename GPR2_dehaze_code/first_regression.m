%DEMO_REGRESSION1  Regression problem demonstration for 2-input 
%                  function with Gaussian process
%
%  Description
%    The regression problem consist of a data with two input
%    variables and one output variable with Gaussian noise. The
%    model constructed is following:
%
%    The observations y are assumed to satisfy
%
%         y = f + e,    where e ~ N(0, s^2)
%
%    where f is an underlying function, which we are interested in. 
%    We place a zero mean Gaussian process prior for f, which
%    implies that at the observed input locations latent values
%    have prior
%
%         f ~ N(0, K),
%
%    where K is the covariance matrix, whose elements are given as
%    K_ij = k(x_i, x_j | th). The function k(x_i, x_j | th) is
%    covariance function and th its parameters.
%
%    Since both likelihood and prior are Gaussian, we obtain a
%    Gaussian marginal likelihood
%
%        p(y|th) = N(0, K + I*s^2).
%    
%   By placing a prior for parameters, p(th), we can find
%   the maximum a posterior (MAP) estimate for them by maximizing
%
%       argmax   log p(y|th) + log p(th).
%         th
%   
%   An approximation for the posterior of the parameters, can be
%   found using Markov chain Monte Carlo (MCMC) methods. We can
%   integrate over the parameters also with other integration
%   approximations such as grid integration.
%
%   After finding MAP estimate or posterior samples of
%   parameters, we can use them to make predictions for f_new:
%
%       p(f_new | y, th) = N(m, S),
%
%          m = K_nt*(K + I*s^2)^(-1)*y
%          S = K_new - K_nt*(K + I*s^2)^(-1)*K_tn
%   
%   where K_new is the covariance matrix of new f, and K_nt between
%   new f and training f.
%
%   For more detailed discussion of Gaussian process regression see,
%   for example, Rasmussen and Williams (2006) or Vanhatalo and
%   Vehtari (2008)
%
%   The demo is organised in three parts:
%     1) data analysis with MAP estimate for the parameters
%     2) data analysis with grid integration over the parameters
%     3) data analysis with MCMC integration over the parameters
%
%  See also DEMO_*
%
%  References:
%    Rasmussen, C. E. and Williams, C. K. I. (2006). Gaussian
%    Processes for Machine Learning. The MIT Press.
%
%    Vanhatalo, J. and Vehtari, A. (2008). Modelling local and global
%    phenomena with sparse Gaussian processes. Proceedings of the 24th
%    Conference on Uncertainty in Artificial Intelligence,

% Copyright (c) 2008-2010 Jarno Vanhatalo
% Copyright (c) 2010 Aki Vehtari

% This software is distributed under the GNU General Public 
% License (version 3 or later); please refer to the file 
% License.txt, included with the software, for details.

%========================================================
% PART 1 data analysis with full GP model
%========================================================
function [pre_y variance_y]=first_regression(H_gabor)

st=clock;
disp('GP1 with Gaussian noise model...');
data1=importdata('train_dcsh.mat'); %训练数据
data1=data1(1:4000,:);
data0=H_gabor; %测试数据
[hh1 ww]=size(data1);
[hh0 ww0]=size(data0);
data00(1:hh0,1:ww0)=data0;
data00(1:hh0,ww)=0;
data=[data1;data00];
hh_train=hh1;
hh_test=hh0;
hh=hh_train+hh_test;
x = data(1:hh_train,1:ww-1);
y = data(1:hh_train,ww);


% --- MAP estimate  ---

gp=importdata('gp_dchs14710_gabor.mat'); %gp模型

xt=data(hh_train+1:hh,1:ww-1);
[Eft_map, Varft_map] = gp_pred(gp, x, y, xt); %gp预测
variance_y=reshape(Varft_map,1,hh_test); %方差计算
times_var=1/max(variance_y);
variance_y=variance_y*times_var;
pre_y=reshape(Eft_map,1,hh_test);
fprintf(' took %.2f seconds\n',etime(clock,st));
