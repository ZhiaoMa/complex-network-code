clc
clear


B=xlsread('C:\Users\hp\Desktop\���ݣ�ȫ��.xlsx');

%����ֵ����������
[m,n]=eig(B);

%�������ֵ
d = eigs(B,1);

%�������ֵ������Ϊÿ���ڵ����������������
%%
n=287;
%����������-������BN���󣬵��ú�����0������1������
BN=betweenness_node(B,0);
BN=BN';

%�ӽ�������-CC,�������·,����ÿ����Ľӽ�������
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
