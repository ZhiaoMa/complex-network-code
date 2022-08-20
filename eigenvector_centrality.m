clc
clear


B=xlsread('C:\Users\hp\Desktop\数据（全）.xlsx');

%特征值和特征向量
[m,n]=eig(B);

%最大特征值
d = eigs(B,1);

%最大特征值所对列为每个节点的特征向量中心性
%%
n=287;
%介数中心性-储存在BN矩阵，调用函数，0是无向，1是有向
BN=betweenness_node(B,0);
BN=BN';

%接近中心性-CC,先求最短路,再求每个点的接近中心性
B(B==0)=inf;
B([1:n+1:n^2])=0;
for k=1:n;
    for i = 1:n;
        for j=1:n;
            if B(i,j)>B(i,k)+B(k,j);
                B(i,j)=B(i,k)+B(k,j);
            end
        end
    end
end

CC=zeros(n,1);
for i=1:n
CC(i,1)=(n-1)/sum(B(i,:));
end
