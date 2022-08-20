function [isolated_node,isolated_node_num] = find_isolated(A)
%% 求解网络内的孤立节点
%A-------------------------网络图的邻接矩阵
%isolated_node-------------孤立点的位置
%isolated_node_num---------孤立点的个数

N=size(A,2);
isolated_node=[];

for i=1:N
    if sum(A(i,:))==0         %判断是否为孤立点.
        isolated_node(end+1)=i;
    end
end
isolated_node_num=length(isolated_node);
if isolated_node_num==N
    disp('该网络图全部由孤立点组成');
    return;
end
