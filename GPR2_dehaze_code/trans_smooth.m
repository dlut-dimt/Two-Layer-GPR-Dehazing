%缩放版本
function [local_stru local_var]=trans_smooth(I0,pre_y1,seg,variance_y1)
trans_value=pre_y1;
trans_value=min(1.0,trans_value);
[h w dim]=size(I0);
trans=zeros(h,w);
trans_var1=zeros(h,w);
% trans_var1=zeros(533*400);
%读取粗分割的学习后透射率
max_vector=max(max(seg));
for i=1:max_vector
        [rs ss vs]=find(seg==i);
        trans(sub2ind(size(trans),rs,ss))=trans_value(i);%-minus;
        trans_var1(sub2ind(size(trans_var1),rs,ss))=variance_y1(i);
end
I=trans;
% I=uint8(I*255);
% trans_var1=trans_var1*255;
% figure,imshow(I);
s_I=imresize(I,0.06);
I_var=imresize(trans_var1,0.06);
[h w]=size(s_I);
h=floor((h-1)/2)*2+1;
w=floor((w-1)/2)*2+1;
count=(h-1)*(w-1)/4;
local_stru=ones(count,9);
local_var=zeros(count,1);
%save('Strans_test.mat','s_I');
cou=1;
for j=1:2:h-2
    for k=1:2:w-2
        local_stru(cou,:)=[s_I(j,k),s_I(j,k+1),s_I(j,k+2),...
                           s_I(j+1,k),s_I(j+1,k+2),s_I(j+2,k),...
                           s_I(j+2,k+1),s_I(j+2,k+2),s_I(j+1,k+1)];
         local_var(cou,1)=I_var(j+1,k+1)
         cou=cou+1;         
    end
end
% save(['learn_Strans_test.mat'],'local_stru');
% save('var_local.mat','local_var');
end