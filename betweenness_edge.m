
function B=betweenness_edge(A,a)
%%求网络边介数，BY QiCheng

%%思想：节点i、j间的距离等于节点i、k间距离与节点k、j间距离时，i、j间的最短路径经过k。
%%因为i、j节点的最短路径经过k时，i到k与k到j必定都是最短路，这个可以用反证法来证明。
% A————网络邻接矩阵，亦可以是赋权图

% a==0为无向网络；a==1为有向网络；
% B————边介数

N=size(A,1);
B=zeros(N,N);
[D,C,aver_D]=Distance_F(A); %C是ij间最短路径条数

for i=1:N          %****************************************
   C(i,i)=1;      %不管有没有自连接，自身到自身的最短路数为1，
end                %因为nm的其中一点可能与i或j重合，若不设为1，会算少
                   %****************************************
if a==0
    for n=1:N
       for m=1:N        %边介数没有什么记不计入端点一说 
           for i=1:N    
               for j=1+i:N    %无向网络对称,正向、反向只算一次，所以只算一半;全算就是两倍
                   if D(i,j)==D(i,n)+D(n,m)+D(m,j)&C(i,j)~=0&A(n,m)~=0  

                    %满足条件即证明ij间最短路径经过边enm
                       B(n,m)=B(n,m)+C(i,n)*C(m,j)/C(i,j);
                       B(m,n)=B(n,m);
                   end
               end
           end
       end
    end
else
    for n=1:N
       for m=1:N      %****注意：有向、无向网络的边介数算出来是一样的，
                       %因为虽然无向网络正反向只算一次，但同时nm不考虑通过顺序，二者抵消了
           for i=1:N
               for j=1:N    
                   if D(i,j)==D(i,n)+D(n,m)+D(m,j)&C(i,j)~=0&A(n,m)~=0  

                   %满足条件即证明ij间最短路径经过边eik
                       B(n,m)=B(n,m)+C(i,n)*C(m,j)/C(i,j);
                   end
               end
           end
       end
   end 
end
for i=1:N
   B(i,i)=0;   %不考虑自连接，就相当于计算节点介数时不考虑端点一样
end

end