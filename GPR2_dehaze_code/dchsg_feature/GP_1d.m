% GP_1d.m

% 选择核函数(协方差函数)，其均值函数默认为常量0.
kernel = 6;
switch kernel
    case 1; k = @(x,y) 1*x'*y; %Linear
    case 2; k = @(x,y) 1*min(x,y); % Brownian  
    case 3; k = @(x,y) exp(-100*(x-y)'*(x-y)); %squared exponential
    case 4; k = @(x,y) exp(-1*sqrt((x-y)'*(x-y))); %Ornstein-Uhlenbeck
    case 5; k = @(x,y) exp(-1*sin(5*pi*(x-y)).^2); %A periodic GP
    case 6; k = @(x,y) exp(-100*min(abs(x-y),abs(x+y)).^2); %A symmetric GP
end

% 选择需显示的点x，即集合S的一部分
x = (-1:0.005:1);
n = length(x);

% 构造协方差矩阵
C = zeros(n,n);
for i = 1:n
    for j = 1:n
        C(i,j) = k(x(i),x(j));
    end
end

% 对GP进行采样
rn = randn(n,1);%产生n个0~1之间的随机数,满足正态分布
[u,s,v] = svd(C); %svd分解rn矩阵，s为奇异值矩阵，u为奇异向量.C=usv'
z = u*sqrt(s)*rn; %z为什么这么表示,理论是？？

% 画出GP的一个sample
figure(1);hold on; clf
plot(x,z,'.-');
% axis([0,1,-2,2]);