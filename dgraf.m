function P = dgraf( A )
%AΪͼ���ڽӾ���
%PΪͼ�Ŀɴ����
n=size(A,1);
P=A;
for i=2:n
    P=P+A^i;
end
P(P~=0)=1;
P;
end