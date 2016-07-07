function eight_n=find_eight()
mat_seg=importdata('Haze0_7_Seg3.mat');
mat_var=importdata('H0_7_var.mat');
mat_trans=importdata('H0_7_trans_dchs_3.mat');
mat_true=importdata('true_test_y.mat');
I=imread('Haze0_7.jpg');
I=im2double(I);
[h w]=size(mat_seg);
var_x=find(mat_var>0.25);%需找阈值以上的区域
[a var_size]=size(var_x);
disp(var_size);
var_train=zeros(var_size,9);
var_train_ind=zeros(var_size,8);
var_test=zeros(var_size,1);

for k=1:var_size
%计算需测试块的中心点
[seg_x seg_y]=find(mat_seg==var_x(k));
seg_m_x=floor(mean(seg_x));
seg_m_y=floor(mean(seg_y));
%8邻居初始化
eight=zeros(1,8);
flag=0;
flag_s=1;
i=0;
seg_mx8=zeros(8);
seg_my8=zeros(8);
seg_mx8=repmat(seg_m_x,1,8);
seg_my8=repmat(seg_m_y,1,8);
temp_x8=[-10,-10,-10,0,0,10,10,10];
temp_y8=[-10,0,10,-10,10,110,0,10];
%寻找8邻居
while flag~=8
    for i=1:8
    seg_mx8(i)=seg_mx8(i)+temp_x8(i);
    seg_my8(i)=seg_my8(i)+temp_y8(i);
    if(seg_mx8(i)>=0 && seg_mx8(i)<=h && seg_my8(i)>0 && seg_my8(i)<=w)
        if( mat_seg(seg_mx8(i),seg_my8(i))~= var_x(1))
           %判断是否与已有的邻居重复 
             if flag>1
                 for j=1:flag
                     if( mat_seg(seg_mx8(i),seg_my8(i))== eight(j))
                         flag_s=0;
                         break;
                     end
                 end
             end
            %如果重复，继续程序
            if(flag_s==0)
                flag_s=1;
                continue;
            end
            %存储非重复邻居
            flag=flag+1;
            eight(flag)=mat_seg(seg_mx8(i),seg_my8(i));
            if(flag==8)
                break;
            end
        end
    end
    end
end
var_test(k)=mat_trans(var_x(k));
var_train(k,1:8)=mat_trans(eight);
var_train_ind(k,1:8)=eight;
end
var_train(:,9)=var_test;
%显示用
% disp(var_x(1));
% disp(eight);
I_sp=segImage(I,mat_seg);
%I_sp=uint8(I_sp);
I=imread('Haze0_7.jpg');

for k=1:var_size
[r s v]=find(mat_seg==var_x(k));
I_sp(sub2ind(size(I_sp),r,s,v))=255;
I_sp(seg_m_x,seg_m_y,1:3)=[0 0 0];
%  
 for i=1:8
 [r s v]=find(mat_seg==var_train_ind(k,i));    
 I_sp(sub2ind(size(I_sp),r,s,v))=0;
 end
end
disp(size(I));
figure,imshow(I);
figure,imshow(I_sp);
save('var_x.mat','var_x');
save('var_train.mat','var_train');
end