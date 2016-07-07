% GP_2d.m

% 选择核函数(协方差函数)，其均值函数默认为常量0.
kernel = 1;
switch kernel
    case 1; k = @(x,y) 1*x'*y; %Linear
    case 2; k = @(x,y) exp(-100*(x-y)'*(x-y)); %squared exponential
    case 3; k = @(x,y) exp(-1*sqrt((x-y)'*(x-y))); %Ornstein-Uhlenbeck
end

% 选择需显示的点points，二维的
points = (0:0.02:1)';
[U,V] = meshgrid(points,points);
x = [U(:) V(:)]';
n = size(x,2);

% 构造协方差矩阵
C = zeros(n,n);
for i = 1:n
    for j = 1:n
        C(i,j) = k(x(:,i),x(:,j));
    end
end

% 对GP进行采样
rn = randn(n,1);%产生n个0~1之间的随机数,满足正态分布
[u,s,v] = svd(C); %svd分解rn矩阵，s为奇异值矩阵，u为奇异向量.C=usv'
z = u*sqrt(s)*rn; %z为什么这么表示,理论是？？

% 画出GP的一个sample
figure(2); clf
Z = reshape(z,sqrt(n),sqrt(n));
surf(U,V,Z);