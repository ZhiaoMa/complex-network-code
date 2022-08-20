function B=betweenness_node(A,a)

%%思想：节点i、j间的距离等于节点i、k间距离与节点k、j间距离时，i、j间的最短路径经过k。

%%因为i、j节点的最短路径经过k时，i到k与k到j必定都是最短路，这个可以用反证法来证明。
% A————网络邻接矩阵，亦可以是赋权图

% a==0为无向网络；a==1为有向网络；
% B————节点介数

N=size(A,1);
B=zeros(1,N);
[D,C,aver_D]=Distance_F(A); %C是ij间最短路径条数

if a==0
    for k=1:N
       for i=1:N
           if i~=k    %两端节点不算               

               for j=i+1:N   %因为是无向的，所以正向、反向只算一次，所以只算一半；

                              %都算的话累加一起就是两倍了，也不影响         
                   if j~=k   %两端节点不算
                       if D(i,j)==D(i,k)+D(k,j)&C(i,j)~=0  %满足条件即证明ij间最短路径经过k节点
                           B(k)=B(k)+C(i,k)*C(k,j)/C(i,j);
                       end
                   end
               end
           end
       end
    end
else
    for k=1:N
       for i=1:N
           if i~=k    %两端节点不算
               for j=1:N
                   if j~=k     %两端节点不算
                       if D(i,j)==D(i,k)+D(k,j)&C(i,j)~=0   %满足条件即证明ij间最短路径经过k节点
                           B(k)=B(k)+C(i,k)*C(k,j)/C(i,j);
                       end
                   end
               end
           end
       end
    end
end
   
    for m=1:N
        B(1,m)=B(1,m)/((N-2)*(N-1));
    end
    
    end