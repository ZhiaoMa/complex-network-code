

n=344;
a=zeros(n);
A=xlsread('C:\Users\hp\Desktop\Beijinghalf.xlsx','2019');
for m = 1 :388;
    a(A(m,1),A(m,2))=1;
end

% a(6,5)=inf;a(5,6)=inf;a(6,7)=inf;a(7,6)=inf;

% a(24,25)=inf;a(25,24)=inf;a(24,39)=inf;a(39,24)=inf;a(24,50)=inf;
% a(50,24)=inf;a(24,51)=inf;a(51,24)=inf;a(24,157)=inf;a(157,24)=inf;

% a(61,62)=inf;a(62,61)=inf;a(61,142)=inf;a(142,61)=inf;
% a(61,143)=inf;a(143,61)=inf;a(61,199)=inf;a(199,61)=inf;

% a(97,98)=inf;a(98,97)=inf;a(97,197)=inf;
% a(197,97)=inf;a(97,198)=inf;a(198,97)=inf;




% a(9,8)=inf;a(8,9)=inf;a(9,10)=inf;a(10,9)=inf;
% a(9,120)=inf;a(120,9)=inf;a(9,121)=inf;a(121,9)=inf;

% a(20,19)=inf;a(19,20)=inf;a(20,21)=inf;a(21,20)=inf;
% a(20,136)=inf;a(136,20)=inf;a(20,137)=inf;a(137,20)=inf;

% a(36,35)=inf;a(35,36)=inf;a(36,37)=inf;a(37,36)=inf;
% a(36,13)=inf;a(13,36)=inf;a(36,55)=inf;a(55,36)=inf;

% a(118,117)=inf;a(117,118)=inf;a(118,119)=inf;a(119,118)=inf;
% a(118,151)=inf;a(151,118)=inf;a(118,152)=inf;a(152,118)=inf;



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
E=(sum(D(:)))/(343*342);
E