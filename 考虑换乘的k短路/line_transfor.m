clear
clc

n=22;

a=xlsread('C:\Users\hp\Desktop\ÏßÂ·¾ØÕó.xlsx');
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