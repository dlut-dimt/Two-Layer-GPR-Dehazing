function l_max_c=local_max_contrast_new(I0,win_size)
[h w dim]=size(I0);
I0=double(I0);
for i=1:h-win_size+1
    for j=1:w-win_size+1
        block=I0(i:(i+win_size-1),j:(j+win_size-1),1:3); %取以i，j为起点的一个步长区域
        mean_val = mean(block(:));
        max_val = max(block(:));
		c_var(i:(i+win_size-1),j:(j+win_size-1))=sqrt(max_val^2-mean_val^2);        
    end
end
l_max_c=c_var;
%l_max_c=uint8(l_max_c);


