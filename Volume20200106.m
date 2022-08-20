clc
clear

n=344;
a=zeros(n);
A=xlsread('C:\Users\hp\Desktop\Volume20200106.xlsx','20.30-21.00');

for m = 1 :115684;
    a(A(m,1),A(m,2))=A(m,3);
end


a;%客流矩阵

b=zeros(n);
B=xlsread('C:\Users\hp\Desktop\Beijinghalf.xlsx','2019');

for p = 1 :388;
    b(B(p,1),B(p,2))=1;
end

b=b+b';
b(b==0)=inf;
b([1:n+1:n^2])=0;


for k=1:n;
    for i = 1:n;
        for j=1:n;
            if b(i,j)>b(i,k)+b(k,j);
                b(i,j)=b(i,k)+b(k,j);
            end
        end
    end
end

b;%最短路矩阵

D=1./b;
D(D==inf)=0;
D;%最短路倒数矩阵

e=a.*D;
E=(sum(e(:)))/(344*343*121477);
E







