function darkc=dark_channel(I0,win_size)
[h w dim]=size(I0);
I=zeros(h,w);
I(:,:)=min(I0(:,:,1),min(I0(:,:,2),I0(:,:,3)));
darkc=zeros(h,w);
for i=1:h-win_size+1
    for j=1:w-win_size+1
        block=I(i:(i+win_size-1),j:(j+win_size-1)); %取以i，j为起点的一个步长区域
		min_val = min(block(:));
		darkc(i:(i+win_size-1),j:(j+win_size-1))=min_val;
    end
end 
darkc=uint8(darkc);