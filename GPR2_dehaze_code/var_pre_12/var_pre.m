function refinetrans2=var_pre()

% Load the data
% S = which('demo_regression1');
% L = strrep(S,'demo_regression1.m','demodata/dat.1');
data1=importdata('learn_Strans1.mat');
data2=importdata('learn_Strans2.mat');
data3=importdata('learn_Strans3.mat');
data4=importdata('learn_Strans4.mat');
datax=[data1;data2;data3;data4];
%save('neighbor_feature.mat','datax');
refinetrans1=importdata('H0_7_trans_dchs_3.mat');
data5=importdata('var_train.mat');
var_x=importdata('var_x.mat');

%data5=importdata('learn1_trans.mat');
[hh1 ww]=size(data1);
[hh2 ww]=size(data2);
[hh3 ww]=size(data3);
[hh4 ww]=size(data4);
[hh5 ww]=size(data5);
data=[data1;data2;data3;data4;data5];
hh_train=hh1+hh2+hh3+hh4;
hh_test=hh5;
% data=[data2;data3];
% hh_train=hh1;
% hh_test=hh2;
hh=hh_train+hh_test;
x = data(1:hh_train,1:ww-1);
y = data(1:hh_train,ww);
[n, nin] = size(x);
% Now 'x' consist of the inputs and 'y' of the output. 
% 'n' and 'nin' are the number of data points and the 
% dimensionality of 'x' (the number of inputs).

% ---------------------------
% --- Construct the model ---
% 
% First create structures for Gaussian likelihood and squared
% exponential covariance function with ARD
length_scale=ones(1,ww-1);
length_scale(1)=1;
lik = lik_gaussian('sigma2', 0.1^2);
gpcf = gpcf_sexp('lengthScale', length_scale, 'magnSigma2', 0.1^2)

% Set some priors
pn = prior_logunif();
lik = lik_gaussian(lik,'sigma2_prior', pn);
pl = prior_unif();
pm = prior_sqrtunif();
gpcf = gpcf_sexp(gpcf, 'lengthScale_prior', pl, 'magnSigma2_prior', pm);

% Following lines do the same since the default type is FULL
%gp = gp_set('type','FULL','lik',lik,'cf',gpcf);
gp = gp_set('lik', lik, 'cf', gpcf);

% Demostrate how to evaluate covariance matrices. 
% K contains the covariance matrix without noise variance 
%  at the diagonal (the prior covariance)
% C contains the covariance matrix with noise variance at 
% the diagonal (the posterior covariance)
% example_x = [-1 -1 ; 0 0 ; 1 1 ];
% [K, C] = gp_trcov(gp, example_x)

% What has happend this far is the following
% - we created structures 'gpcf' and 'lik', which describe 
%   the properties of the covariance function and Gaussian likelihood (see
%   gpcf_sexp and lik_gaussian for more details)
% - we created structures that describe the prior of the length-scale 
%   and magnitude of the squared exponential covariance function and
%   the prior of the noise variance. These structures were set into
%   'gpcf' and 'lik' (see prior_* for more details)
% - we created a GP structure 'gp', which has among others 'gpcf' 
%   and 'lik' structures.  (see gp_set for more details)

% -----------------------------
% --- Conduct the inference ---
%
% We will make the inference first by finding a maximum a posterior
% estimate for the parameters via gradient based optimization. 
% After this we will use grid integration and Markov chain Monte
% Carlo sampling to integrate over the parameters.
 

% --- MAP estimate  ---
disp(' MAP estimate for the parameters')
% Set the options for the optimization
% opt=optimset('TolFun',1e-3,'TolX',1e-3);
% % Optimize with the scaled conjugate gradient method
% gp=gp_optim(gp,x,y,'opt',opt);
% 
% % get optimized parameter values for display
% [w,s]=gp_pak(gp);
% display exp(w) and labels
%disp(s), disp(exp(w));
gp=importdata('gp_trans.mat');
% For last, make predictions of the underlying function on a dense
% grid and plot it. Below Eft_map is the predictive mean and
% Varf_map the predictive variance.
%[xt1,xt2]=meshgrid(-1.8:0.1:1.8,-1.8:0.1:1.8);
xt=data(hh_train+1:hh,1:ww-1);
[Eft_map, Varft_map] = gp_pred(gp, x, y, xt);
pre_y=reshape(Eft_map,1,hh_test);
data5(:,ww)=pre_y;
%disp(pre_y);
true_y= data(1:hh,ww);
%disp(true_y);
figure,plot(1:hh,true_y,'b');
hold on
plot(hh_train+1:hh,pre_y,'r');
for i=1:hh5
refinetrans1(var_x(i))=pre_y(i);
end


save('local_learn5.mat','refinetrans1');