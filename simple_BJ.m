clc
clear

n=78;
a=zeros(n);
A=xlsread('C:\Users\hp\Desktop\2019simpleBJ.xlsx');

for m = 1:119;
    a(A(m,1),A(m,2))=A(m,3);
end

a(37,:)=0;a(:,37)=0;

a=a';   %matlab������Ҫ�������������Ǿ���

[i,j,v]=find(a);

b=sparse(i,j,v,78,78); %����ϡ�����

[x,y,z]=graphshortestpath(b,42,38,'Directed',false) % Directed�Ǳ�־ͼΪ�������������ԣ���ͼ������ͼ����Ӧ������ֵΪfalse����0��

