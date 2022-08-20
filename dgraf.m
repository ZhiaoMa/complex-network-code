function P = dgraf( A )
%A为图的邻接矩阵
%P为图的可达矩阵
n=size(A,1);
P=A;
for i=2:n
    P=P+A^i;
end
P(P~=0)=1;
P;
end