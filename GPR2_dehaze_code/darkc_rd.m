function darkchannel=darkc_rd(I0,win_size)
%
win_size=7;  %求暗原色时的计算步长（设置时:win_size=步长-1）
filename='1.bmp';
[h,w,dim]=size(I0);         
darkchannel=zeros(h,w);
I1=zeros(h,w);
I1(:,:)=min(min(I0(:,:,1),I0(:,:,2)),I0(:,:,3));
imwrite(uint8(I1),['E:\CT\',strcat('sdarkchannel_',filename)]);
wins=2*win_size+1;
h_min=floor(h/wins)*wins+wins;
w_min=floor(w/wins)*wins+wins;
min1=ones(h_min,w_min)*255;
min2=ones(h_min,w_min)*255;
min3=ones(h_min,w_min)*255;
min4=ones(h_min,w_min)*255;
%第一个最小阵
for i=wins:wins:h_min
    for j=wins:wins:w_min
        for a=i:-1:i-wins+1        
            for b=j:-1:j-wins+1
                if(a>h||b>w)
                    min1(a,b)=255;
                else if  a==i&b==j
                    min1(a,b)=I1(a,b);
                else if a==i
                        min1(a,b)=min(I1(a,b),min1(a,b+1));
                    else if b==j
                            min1(a,b)=min(I1(a,b),min1(a+1,b));
                        else
                             min1(a,b)=min(I1(a,b),min(min1(a,b+1),min1(a+1,b)));
                        end
                    end
                end
            end
            end
        end
    end
end
%第二个最小阵
for i=wins:wins:h_min
    for j=1:wins:w_min-wins+1
        for a=i:-1:i-wins+1        
            for b=j:j+wins-1
                if(a>h||b>w)
                    min2(a,b)=255;
                else if  a==i&b==j
                    min2(a,b)=I1(a,b);
                else if a==i
                        min2(a,b)=min(I1(a,b),min2(a,b-1));
                    else if b==j
                            min2(a,b)=min(I1(a,b),min2(a+1,b));
                        else
                             min2(a,b)=min(I1(a,b),min(min2(a,b-1),min2(a+1,b)));
                        end
                    end
                end
            end
            end
        end
    end
end
%第三个最小阵
for i=1:wins:h_min-wins+1
    for j=wins:wins:w_min
        for a=i:i+wins-1        
            for b=j:-1:j-wins+1
                if(a>h||b>w)
                    min3(a,b)=255;
                else if  a==i&b==j
                    min3(a,b)=I1(a,b);
                else if a==i
                        min3(a,b)=min(I1(a,b),min3(a,b+1));
                    else if b==j
                            min3(a,b)=min(I1(a,b),min3(a-1,b));
                        else
                             min3(a,b)=min(I1(a,b),min(min3(a,b+1),min3(a-1,b)));
                        end
                    end
                end
            end
            end
        end
    end
end
%第四个最小阵
for i=1:wins:h_min-wins+1
    for j=1:wins:w_min-wins+1
        for a=i:i+wins-1        
            for b=j:j+wins-1
                if(a>h||b>w)
                    min4(a,b)=255;
                else if  a==i&b==j
                    min4(a,b)=I1(a,b);
                else if a==i
                        min4(a,b)=min(I1(a,b),min4(a,b-1));
                    else if b==j
                            min4(a,b)=min(I1(a,b),min4(a-1,b));
                        else
                             min4(a,b)=min(I1(a,b),min(min4(a,b-1),min4(a-1,b)));
                        end
                    end
                end
            end
            end
        end
    end
end
min1=uint8(min1);
min2=uint8(min2);
min3=uint8(min3);
min4=uint8(min4);
hh=h-win_size-1;
ww=w-win_size;
for i=1+win_size:hh
    for j=1+win_size:ww
        min12=min(min1(i-win_size,j-win_size),min2(i-win_size,j+win_size));
        min34=min(min3(i+win_size,j-win_size),min4(i+win_size,j+win_size));
        darkchannel(i-win_size,j-win_size)=min(min12,min34);
    end
        darkchannel(i-win_size,(j-win_size):(j+win_size))=min(min12,min34);
end
i=hh+1;
for j= 1+win_size:ww
        min12=min(min1(i-win_size,j-win_size),min2(i-win_size,j+win_size));
        min34=min(min3(i+win_size,j-win_size),min4(i+win_size,j+win_size));
        darkchannel((i-win_size):(i+win_size),j-win_size)=min(min12,min34);
end
darkchannel(i-win_size:i+win_size,j-win_size:j+win_size)=min(min12,min34);
darkchannel=uint8(darkchannel);         
% darkchannel1=zeros(h,w);
%求暗原色
% tic
% for i=1+win_size:h-win_size
%     for j=1+win_size:w-win_size
%         block=I0((i-win_size):(i+win_size),(j-win_size):(j+win_size),:); %取以i，j为起点的一个步长区域
% 		min_val = min(block(:));
% 		darkchannel1((i-win_size):(i+win_size),(j-win_size):(j+win_size))=min_val;
%     end
% end 
% toc
% darkchannel2=uint8(darkchannel1)-uint8(darkchannel);
% figure,imshow(uint8(darkchannel2)),title('输出图像');
% imwrite(uint8(darkchannel1),['E:\CT\',strcat('darkchannel2_',filename)]);
% imwrite(uint8(darkchannel),['E:\CT\',strcat('darkchannel1_',filename)]);