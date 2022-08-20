%Cascad_Failure
clear all
close all
clc
tic
%% 原始数据，这里的负载和容量直接给定，有很多负载容量模型可以嫁接修改
Node_load = [3 3 3 3 3 3 3 3 3 3];
Node_Capacity = 1.5*Node_load;
A=[ 0     1     0     1     0     0     0     0     0     0
    1     0     1     0     0     0     0     0     0     0
    0     1     0     1     0     0     0     0     0     0
    1     0     1     0     0     1     0     0     0     0
    0     0     0     0     0     1     0     0     0     0
    0     0     0     1     1     0     1     0     0     0
    0     0     0     0     0     1     0     1     0     0
    0     0     0     0     0     0     1     0     1     0
    0     0     0     0     0     0     0     1     0     0
    0     0     0     0     0     0     0     0     0     0];

%% 变量设置
N=length(A);                        % 总的节点数
node_index=[];                      % 节点编号，用来标记节点的位置
new_failure=[];                     % 新增的损坏点
fail_node_temp=[];                  % 临时存放坏的节点
fail_nodes=[];                      % 级联损坏的节点集合
isolated_node=[];                   % 孤立点集合
total_failure=[];                   % 总的损坏点，包括级联失效+孤立的点
good_isolated_nodes=[];             % 完好的孤立节点的集合
A_temp=A;                           % 将原始矩阵保存为临时邻接矩阵
A_change=A_temp;                    % 临时矩阵可变大小的矩阵
Node_load_temp=[];                  % 临时存放节点负载
i=0;                                % 迭代的步数
%% 准备工作
node_index=1:N;                     % 标记索引
%% 级联失效主程序

new_failure=[1 6];
% 预先指定被攻击的节点

total_failure=new_failure;
fail_nodes=new_failure;
Node_load_temp = Node_load;         % 暂存节点的负载

while ~isempty(new_failure) && length(total_failure)~=N   % 判断迭代停止的条件
    %% 第0步判断是不是有孤立节点
    if i==0
        [new_isolated, new_isolated_node_num ] = find_isolated(A_temp);
        for m=1:new_isolated_node_num
            A_temp(new_isolated(m),:)=0;
            A_temp(:,new_isolated(m))=0;              % 将A_temp矩阵中孤立节点的连边关系移除
            
            index=find(node_index==new_isolated(m));
            node_index(index)=[];       % 将节点索引里面的孤立节点移除
            A_change(index,:)=[];
            A_change(:,index)=[];       % 将A_change矩阵中孤立节点移除
        end
        isolated_node = [isolated_node, new_isolated];
        total_failure = [total_failure, isolated_node];
    end
    
    %% 第1步失效节点导致级联失效，寻找新一轮失效节点
    for m=1:length(new_failure)
        % 先找失效节点的邻居节点的编号
        neiber=find(A_temp(new_failure(m),:)==1);
        delta=[];
        % 计算额外增加的负载，这里可以有很多的公式类型
        delta(neiber) = deal(Node_load_temp(new_failure(m)) .* Node_load(neiber)/sum(Node_load(neiber)));
        Node_load_temp(neiber) = deal(Node_load_temp(neiber) + delta(neiber)); % 负载重分配
        
        k = new_failure(m);
        A_temp(k,:)=0;
        A_temp(:,k)=0;                     % 将A_temp矩阵中级联失效节点的连边关系移除
        
        index=find(node_index==k);
        node_index(index)=[];              % 将节点索引里面的级联失效节点移除
        A_change(index,:)=[];
        A_change(:,index)=[];              % 将A_change矩阵中级联失效节点移除
    end
    
    Node_load_temp(new_failure(:))=0;  %把失效的节点的负载清零
    
    fail_node_temp=[];                     % 本轮失效导致的下一步失效的节点集合存储变量
    for k=1:length(node_index)
        kk = node_index(k);
        if Node_load_temp(kk)>Node_Capacity(kk)
            fail_node_temp = [fail_node_temp, kk]; % 得到本轮引起的失效节点集合
        end
    end
    
%     fprintf('新引起失效为: ');
%     if isempty(fail_node_temp)
%         disp('空')
%     else
%         disp(fail_node_temp);
%     end
    new_failure = fail_node_temp;
    
    %% 第2步寻找依旧存活的孤立节点
    [isolated_node, ~ ] = find_isolated(A_change);
    new_isolated_node=node_index(isolated_node);
    
    for m=1:length(isolated_node)
        k=new_isolated_node(m);
        A_temp(k,:)=0;
        A_temp(:,k)=0;                          % 将A_temp矩阵中级联失效节点的连边关系移除
        
        index=find(node_index==k);              % 将节点索引里面的级联失效节点移除
        node_index(index)=[];
        A_change(index,:)=[];
        A_change(:,index)=[];                   % 将A_change矩阵中级联失效节点移除
        %         Node_load_temp(index)=0;                % 将完好的孤立点的负载清零
    end
    
    good_isolated_nodes=unique([good_isolated_nodes, new_isolated_node]); % 统计累计的完好孤立点
%     fprintf('新增完好的孤立节点: ');
%     if isempty(new_isolated_node)
%         disp('空')
%     else
%         disp(new_isolated_node)
%     end
    %% 第3步统计失效节点
    fail_nodes = [fail_nodes,new_failure];
    total_failure = unique([total_failure, new_isolated_node, new_failure]);
    i=i+1;
%         figure
%         plot(graph(A_change));
end
good_isolated_nodes
fail_nodes
total_failure
i-1  % 显示级联失效的次数
toc
