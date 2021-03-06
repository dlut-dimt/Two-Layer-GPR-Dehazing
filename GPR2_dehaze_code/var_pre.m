function refinetrans1=var_pre(var_x,var_train,pre_y)


st=clock;
disp('GP2 with Gaussian noise model...')
refinetrans1=pre_y;
data1=importdata('neighbor_feature.mat');
data0=var_train;
data0=min(0.99,data0);
data0=max(0.01,data0);
data0=data0*255;
[hh1 ww]=size(data1);
[hh0 ww0]=size(data0);
data=[data1;data0];
hh_train=hh1;
hh_test=hh0;
hh=hh_train+hh_test;
x = data(1:hh_train,1:ww-1);
y = data(1:hh_train,ww);

% --- MAP estimate  ---

gp=importdata('gp_trans.mat.');

xt=data(hh_train+1:hh,1:ww-1);

[Eft_map, Varft_map] = gp_pred(gp, x, y, xt);
save('pre_y.mat','Eft_map');
pre_y=reshape(Eft_map,1,hh_test);
%data0(:,ww)=pre_y;
%disp(pre_y);
true_y= data(1:hh,ww);
%disp(true_y);
figure,plot(1:hh,true_y,'b');
hold on
plot(hh_train+1:hh,pre_y,'r');

for i=1:hh_test
refinetrans1(var_x(i))=pre_y(i)/255;
end
save('local_var_refine.mat','refinetrans1');