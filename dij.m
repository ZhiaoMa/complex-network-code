clc
clear

n=218;
a=zeros(n);
% A=xlsread('beijinghalf.xlsx');
% A=xlsread('C:\Users\hp\Desktop\Beijinghalf.xlsx','2019');
A=xlsread('C:\Users\hp\Desktop\qingdao.xlsx','half' );

for m = 1 :235;
    a(A(m,1),A(m,2))=1;
end

a=a+a';
a(a==0)=inf;
a([1:n+1:n^2])=0;


for k=1:n;
    for i = 1:n;
        for j=1:n;
            if a(i,j)>a(i,k)+a(k,j);
                a(i,j)=a(i,k)+a(k,j);
            end
        end
    end
end

a;

D=max(max(a))
[x,y]=find(a==D)

L=(sum(a(:)))/(218*217)

D=1./a;
D(D==inf)=0;
E=(sum(D(:)))/(217*216)

