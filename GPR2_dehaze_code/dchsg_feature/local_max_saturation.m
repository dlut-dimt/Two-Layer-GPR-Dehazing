function l_max_s=local_max_saturation(I0,win_size)
[h w dim]=size(I0);
I=zeros(h,w);
l_max_s=zeros(h,w);
for i=1:h-win_size+1
    for j=1:w-win_size+1
        block=I0(i:(i+win_size-1),j:(j+win_size-1),1:3); %取以i，j为起点的一个步长区域
		min_val = min(block(:));
        max_val = max(block(:));
		l_max_s(i:(i+win_size-1),j:(j+win_size-1))=max_val-min_val;
    end
end 
l_max_s=uint8(l_max_s);
