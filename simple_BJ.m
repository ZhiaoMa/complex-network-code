clc
clear

n=78;
a=zeros(n);
A=xlsread('C:\Users\hp\Desktop\2019simpleBJ.xlsx');

for m = 1:119;
    a(A(m,1),A(m,2))=A(m,3);
end

a(37,:)=0;a(:,37)=0;

a=a';   %matlab工具箱要求数据是下三角矩阵

[i,j,v]=find(a);

b=sparse(i,j,v,78,78); %构造稀疏矩阵

[x,y,z]=graphshortestpath(b,42,38,'Directed',false) % Directed是标志图为有向或无向的属性，该图是无向图，对应的属性值为false，或0。

