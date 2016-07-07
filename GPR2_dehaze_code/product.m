function pre_trans2=product(pre_y1,pre_y2,variance_y1,variance_y2,pre_trans2)
pre_y1=max(pre_y1,0);
pre_y1=min(pre_y1,255);
pre_y2=max(pre_y2,0);
pre_y2=min(pre_y2,255);
[h,w]=size(pre_y1);
for i=1:h,
    for j=1:w,
        s=pre_y1(i,j)*variance_y2(i,j)+pre_y2(i,j)*variance_y1(i,j);
        n=variance_y2(i,j)+variance_y1(i,j);
        pre_y(i,j)=s/n;
    end    
end;
variance_y2=variance_y2./(255*255);
for i=1:h,
    for j=1:w,
        s=variance_y1(i,j)*variance_y2(i,j);
        n=variance_y2(i,j)+variance_y1(i,j);
        variance_y(i,j)=s/n;
%         variance_y(i,j)=sqrt(variance_y(i,j));
    end    
end;
pre_trans2(:,9)=pre_y;
