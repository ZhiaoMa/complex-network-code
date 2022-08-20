clc
clear

n=344;

a=zeros(n);
A=xlsread('C:\Users\hp\Desktop\Beijinghalf.xlsx','2019');
for m = 1 :388
    a(A(m,1),A(m,2))=1;
end
a=a+a';        %邻接矩阵
 

b=zeros(n);
B=xlsread('C:\Users\hp\Desktop\Volume20200106.xlsx','20.30-21.00');
for m = 1 :115684
    b(B(m,1),B(m,2))=B(m,3);
end     %客流矩阵


r=randperm(344);

for i =1:n
    
   a(r(1,i),:)=0;
   a(:,r(1,i))=0; 
   
   b(r(1,i),:)=0;
   b(:,r(1,i))=0; 
   
    A=dgraf(a);
    
    C=((118336-i-sum(sum(A)))/117992)*((121477-sum(sum(b)))/121477);   
   
    disp(C)
    
    if C>0.95
break
    end 
    
end

%% 修改未用.

% 初始化矩阵
n=344;

%初始客流矩阵
original_OD=zeros(n);     
B=xlsread('C:\Users\59464\Desktop\三轮大修\数据+图表\数据\Volume20200106.xlsx','4-24');
for m = 1:length(B)
    original_OD(B(m,1),B(m,2))=B(m,3);
end
original_OD([1:n+1:n^2])=0;

%初始邻接矩阵
original_admatrix=zeros(n);
C=xlsread('C:\Users\59464\Desktop\三轮大修\数据+图表\数据\beijinghalf.xlsx','2019带环球度假区');
for p = 1:length(C)
    original_admatrix(C(p,1),C(p,2))=1;
end
original_admatrix=original_admatrix+original_admatrix';

AD=sum(sum(dgraf(original_admatrix))); %原始OD对数目（含对角线）
OD=sum(sum(original_OD));   %原始客流量

% 计算客流分配的连通率

temp__admatrix=original_admatrix;
temp_OD=original_OD;

r=randperm(344);
Con=zeros(n,1);

for i =1:n
    i
   temp__admatrix(r(1,i),:)=0;
   temp__admatrix(:,r(1,i))=0; 
   
   access=dgraf(temp__admatrix);   %可达矩阵
   temp_OD=original_OD;
   temp_OD=temp_OD.*access;   %可达客流
   temp_OD(r(1,i),:)=original_OD(r(1,i),:);
   temp_OD(r(1,i),:)=original_OD(r(1,i),:);
   
   C=((AD-sum(sum(access)))*(OD-sum(sum(temp_OD))))/(AD*OD);
   Con(i,1)=C;
  
   if C>0.95
       break
   end 
    
end