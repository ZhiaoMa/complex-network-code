function [D,path,min1,path1]=floyd(a,start,terminal)
%D(i,j)表示i到j的最短路径，path(i,j)表示i到j之间的最短路径上顶点i的后继点。
%min1返回start和terminal之间的最短距离，path1返回start和terminal之间的最短路径
%a为带权邻接矩阵，start、terminal分别是起始点和终止点

D=a;n=size(D,1);path=zeros(n,n);
%n为顶点个数，生成D、path矩阵

%遍历一遍矩阵，初始化path矩阵，先将可以直接相连的点的path进行补充
for i=1:n
    for j=1:n
        if D(i,j)~=inf
            path(i,j)=j;
        end  
    end
end

%三重遍历，查找是否有中继点可以使得路径缩短，若有则更新D、path矩阵
for k=1:n
    for i=1:n
        for j=1:n
            if D(i,k)+D(k,j)<D(i,j)
                D(i,j)=D(i,k)+D(k,j);
                path(i,j)=path(i,k);
            end 
        end
    end
%这里演示了每一步的调整过程
% k,D,path
end

%判断输出参数是否为三个
if nargin==3
    min1=D(start,terminal);
    m(1)=start;
    i=1;
    path1=[ ];   
    %根据path路径一步一步跳转找到具体路径，返回path1
    while   path(m(i),terminal)~=terminal
        k=i+1;                                
        m(k)=path(m(i),terminal);
        i=i+1;
    end
    m(i+1)=terminal;
    path1=m;
end   


