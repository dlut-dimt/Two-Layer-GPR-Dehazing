function J=haze_filtering(pre_y,I0)
I = im2double(I0);
st=clock;
disp('Haze filtering...');
see1=1000; 
see2=5000;
t0=0.01;
trans_value=pre_y;%pre_y;
trans_value=double(trans_value);
% trans_value=trans_value/255;
trans_value=min(1.0,trans_value);
trans_value=max(0,trans_value);
figure,imshow(I0);
[h w dim]=size(I0);
[row1 coloumn1 dim]=size(imresize(I0,0.06));
row1=floor((row1-1)/2)*2+1;
coloumn1=floor((coloumn1-1)/2)*2+1;
count=(row1-1)*(coloumn1-1)/4;
trans=zeros(row1,coloumn1);
cou=1;
%将预测透射率还原为透射率图
for i=1:2:row1-2
   for j=1:2:coloumn1-2
       trans(i,j)=trans_value(cou,1);
       trans(i,j+1)=trans_value(cou,2);
       trans(i,j+2)=trans_value(cou,3);
       trans(i+1,j)=trans_value(cou,4);
       trans(i+1,j+1)=trans_value(cou,9);
       trans(i+1,j+2)=trans_value(cou,5);
       trans(i+2,j)=trans_value(cou,6);
       trans(i+2,j+1)=trans_value(cou,7);
       trans(i+2,j+2)=trans_value(cou,8);
       cou=cou+1;
   end
end
trans=imresize(trans,[h,w]);%diferent
H= fspecial('gaussian',[30 30],0.9);
trans=imfilter(trans,H,'replicate');
%Estimation of atmosphere light
min_dark_val=sort(trans(:),'ascend');     
[max_x,max_y]=find(trans<=min_dark_val(uint8(h*w*0.001)));
x_size=uint8(h*w*0.001);
I_max=0.0;
I_max1=0.0;
I_max2=0.0;
I_max3=0.0;

for i=1:x_size
    I_max1=max(I_max1,max(I0(max_x(i),max_y(i),1)));
    I_max2=max(I_max2,max(I0(max_x(i),max_y(i),2)));
    I_max3=max(I_max3,max(I0(max_x(i),max_y(i),3)));
end
I_max1=I_max1*0.98;
I_max2=I_max2*1.00;
I_max3=I_max3*1.00;

I_max=max(max(I_max1,I_max2),I_max3);
I_max=double(I_max);
I_max1=double(I_max1);
I_max2=double(I_max2);
I_max3=double(I_max3);
%guided filtering
ps=double(trans);
r =35;
eps =10^-3;

I_g=double(rgb2gray(I0));
Ts= guidedfilter(I_g, ps, r, eps);

T=imresize(Ts,[h w]);
H= fspecial('gaussian',[30 30],0.9);
T=imfilter(T,H,'replicate');
figure,imshow(uint8(T*255));
imwrite(uint8(T*255),strcat('final_trans_','res.jpg'));


%sky compensation
sc=0.2;
[XX,YY]=find(T<=t0);
XY=size(XX);
for i=1:h
    for j=1:w
       if(T(i,j)<=sc)
           T(i,j)=sc*2-T(i,j);
       end
    end
end
%haze filtering


bilv=see1/see2;
T0=T.^bilv;
T=max(T,t0);
Tx=double(T);
%
T0=max(T0,t0);
T0x=double(T0);
%
I0=double(I0);
J=zeros(h,w,dim);
J=double(J);
J(:,:,1)=(I0(:,:,1).*T0x-I_max1*T0x)./Tx+I_max1;
J(:,:,2)=(I0(:,:,2).*T0x-I_max2*T0x)./Tx+I_max2;
J(:,:,3)=(I0(:,:,3).*T0x-I_max3*T0x)./Tx+I_max3;
J=uint8(J);
figure,imshow(J);
imwrite(uint8(J),strcat('Light1_','res.jpg'));
%Exposure 
% x=(sum(I0(:))/sum(J(:)))*0.95;%
% disp(x);
% J=uint8(min(J*x,255));
% J1 = imadjust(J,[.1 .1 .1; .9 .9 0.9]);%
% J2 = imadjust(J,[.0 .0 .0; .8 .8 0.8]);%
% J=J1*0.1+J2*0.9;
% % figure,imshow(J);
% imwrite(uint8(J),strcat('Light2_','res.jpg'));
% fprintf(' took %.2f seconds\n',etime(clock,st));
end
