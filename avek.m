clc
clear

B=zeros(233);
A=xlsread('Beijing.xlsx');
for i=1:526;
    B(A(i,1),A(i,2))=1;
end

sumk=0;

for k=1:233;
    for l=1:233;
        sumk=sumk+B(k,1);
    end
end

avek=sumk/233

C=CCM_ClusteringCoef(B)