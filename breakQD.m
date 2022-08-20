n=218;
a=zeros(n);
A=xlsread('C:\Users\hp\Desktop\qingdao.xlsx','double' );

for m = 1 :235;
    a(A(m,1),A(m,2))=1;
end

% a(6,5)=inf;a(5,6)=inf;a(6,7)=inf;a(7,6)=inf;

% a(16,15)=inf;a(16,17)=inf;a(16,59)=inf;
% a(15,16)=inf;a(17,16)=inf;a(59,16)=inf;

% a(34,35)=inf;a(34,64)=inf;a(34,80)=inf;a(34,33)=inf;a(34,63)=inf;
% a(35,34)=inf;a(64,34)=inf;a(80,34)=inf;a(33,34)=inf;a(63,34)=inf;

% a(102,103)=inf;a(102,187)=inf;a(102,188)=inf;a(102,101)=inf;
% a(103,102)=inf;a(187,102)=inf;a(188,102)=inf;a(101,102)=inf;


% 
% a(30,14)=inf;a(30,78)=inf;a(30,31)=inf;
% a(14,30)=inf;a(78,30)=inf;a(31,30)=inf;

% a(43,165)=inf;a(43,44)=inf;a(43,42)=inf;
% a(165,43)=inf;a(44,43)=inf;a(42,43)=inf;

% a(59,60)=inf;a(59,16)=inf;a(59,77)=inf;
% a(60,59)=inf;a(16,59)=inf;a(77,59)=inf;

% a(187,102)=inf;a(187,186)=inf;a(187,200)=inf;
% a(102,187)=inf;a(186,187)=inf;a(200,187)=inf;


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
    
D=1./a;
D(D==inf)=0;
E=(sum(D(:)))/(217*216);
E