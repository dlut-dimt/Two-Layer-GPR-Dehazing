function GPR2_dehaze()
clear all
I0=imread('Haze0_7.jpg');
I = im2double(I0);
[seg Sp Sp2]=super_pixels(I); %超像素分割
% Sp2=importdata('hazyimage1_Seg3.mat');
H_gabor=feature_vector(I0, Sp2); %提取特征向量
% H_gabor=importdata('hazyimage1_gabor.mat');
[pre_tran1 pre_var1]=first_regression(H_gabor);%第一层回归
[local_stru local_var]=trans_smooth(I0,pre_tran1,Sp2,pre_var1);%将透射率进行初步平滑，转化为可用作二层回归的输入向量
[pre_trans2 pre_var2]=second_regression(local_stru);%第二层回归
[pre_y1,pre_y2,variance_y1,variance_y2]=gettrans(local_stru,local_var,pre_trans2,pre_var2);
pre_trans2=product(pre_y1,pre_y2,variance_y1,variance_y2,pre_trans2);%乘积
haze_filtering(pre_trans2,I0);%除雾，雾效滤波

