B=zeros(233);
A=xlsread('Beijing.xlsx');
% A=xlsread('C:\Users\hp\Desktop\Beijing.xlsx','2019')
for i = 1 :526;
    B(A(i,1),A(i,2))=1;
end
B
