clear
clc
%% ===============================================================
% K短路算法+换乘算法
% 运算调用huanchengcishu.m
% 主要运算结果【KPaths KCosts Mxf】
%==========================================================================

%% 1. 输入并处理相关的路网数据
%==========================================================================
luwangshuju;
shujuchuli;
k=1;
n=0;
%==========================================================================

%% 2. K短路算和换乘算法结合，求出有效路径
%==========================================================================
if ismember([O D],zhan) & O~=D
    %% 2.1 调用Dijkstra算法求出最短路路径及费用
    [path costs]=dijkstra(Road_Net, O, D);
    if isempty(path)
        KPaths=[];
        KCosts=[];
    else
        %% 2.2 初始化
        path_number = 1;                %路径从1开始编号
        P{path_number,1}= path;         %单元数组P第一行表示路径
        P{path_number,2}= costs;        %单元数组P第二行表示路径阻抗
        current_P = path_number;
        size_X=1;
        X{size_X}={path_number; path; costs};%1-编号，2-路径，3-阻抗值
        S(path_number)= path(1);        %路径的开始站点
        KPaths{k}= path;
        KCosts{k}= costs;
        
        %% 2.3 调用换乘次数函数
        while (k<Kmax && size_X ~=0)
            huanchengcishu;                                %求出路径k的换乘次数
            KHc_n{k}=KHc_cishu;
            KCosts{k}=KCosts{k}+KHc_cishu*Cost_of_Transfer;%求出考虑换乘后的总费用
            costs=min(cell2mat(KCosts));                   %更新最小费用

            %% 2.4 删除非有效路径
            if  KCosts{k}>(H+1)*costs
                k=k-1;
                KCosts=KCosts(1:k);
                KPaths=KPaths(1:k);
                KHc_n=KHc_n(1:k);
                KHc_hcd=KHc_hcd(1:k);
                KHc_hcqj=KHc_hcqj(1:k);
                KHc_hcld_a=KHc_hcld_a(1:k);
                break
            end
            %% 2.5 关闭已搜索的路径
            for i=1:length(X)
                if  X{i}{1}== current_P
                    size_X = size_X - 1;
                    X(i)=[];
                    break;
                end
            end
            P_= P{current_P,1};
            w = S(current_P);
            for i=1:length(P_)
                if w==P_(i)
                    w_index_in_path=i;                           %找到w在路径中的位置
                end
            end
            %% 2.6 更新路网矩阵
            for index_dev_vertex= w_index_in_path:length(P_)- 1
                temp_luwangjuzhen = Road_Net;
                for i = 1: index_dev_vertex-1
                    v = P_(i);
                    temp_luwangjuzhen(v,:)=inf;
                    temp_luwangjuzhen(:,v)=inf;
                end
                SP_sameSubPath=[];
                index =1;
                SP_sameSubPath{index}=P_;
                for i=1:length(KPaths)
                    if length(KPaths{i})>= index_dev_vertex     %如果路径长度大于index_dev_vertex，即还没有完成搜索
                        if P_(1:index_dev_vertex)== KPaths{i}(1:index_dev_vertex)   %对比当前路径和K路径的前index_dev_vertex个点，如果匹配，继续对比，否则为不匹配
                            index = index+1;                    %匹配成功则自动进入下一个节点对比
                            SP_sameSubPath{index}=KPaths{i};
                        end
                    end
                end
                v_ = P_(index_dev_vertex);
                for j = 1: length(SP_sameSubPath)
                    next=SP_sameSubPath{j}(index_dev_vertex+1);
                    temp_luwangjuzhen(v_,next)=inf;
                end
                sub_P=P_(1:index_dev_vertex);
                costs_sub_P=0;
                for i=1:length(sub_P)-1
                    costs_sub_P=costs_sub_P+Road_Net(sub_P(i),sub_P(i+1));
                end
                [dev_p c]= dijkstra(temp_luwangjuzhen, P_(index_dev_vertex), D);
                if ~isempty(dev_p)
                    path_number=path_number+1;
                    P{path_number,1}=[sub_P(1:end-1) dev_p];     %连接起点到终点的路径
                    P{path_number,2}= costs_sub_P + c ;          %计算子路径及偏差定点到终点费用的和（最终费用）
                    S(path_number)= P_(index_dev_vertex);
                    size_X = size_X + 1;
                    X{size_X}={path_number; P{path_number,1};P{path_number,2}};
                    %                                             更新当前数据（路径编号，路径，路径费用）
                end
            end
            %% 2.7 防错处理，如果指定路径数目大于路网穷举数目，防错，否则最后的结果会发生重复,也可能进入死循环。
            if size_X > 0
                shortestXCosts= X{1}{3};                         %路径费用
                shortestX= X{1}{1};                              %判定路径
                for i=2:size_X
                    if  X{i}{3}< shortestXCosts
                        shortestX= X{i}{1};
                        shortestXCosts= X{i}{3};
                    end
                end
                current_P=shortestX;
                k=k+1;
                KPaths{k}= P{current_P,1};
                KCosts{k}= P{current_P,2};
            else
                k=k+1;
            end
        end
    end
else
    warning('起点或终点不在指定路网中！按任意键请重新输入。。。');
    pause
    KSP
end
%==========================================================================
%% 3.有效路径
%% 3.1 保留有效路径并排序
%==========================================================================
KCosts=cell2mat(KCosts);
yxlj=find(KCosts<min(KCosts)*(1+H));
KCosts=KCosts(yxlj);
[KCosts,yxlj]=sort(KCosts);
KPaths=KPaths(yxlj);
KHc_n=KHc_n(yxlj);
KHc_hcd=KHc_hcd(yxlj);
KHc_hcqj=KHc_hcqj(yxlj);
KHc_hcld_a=KHc_hcld_a(yxlj);
%==========================================================================

%% 3.2 根据有效路径求得路径-路段的01矩阵
%==========================================================================
Mxf=zeros(length(KPaths),length(luduan_zhan));
m=1;
while m<=length(KPaths)
    for i=2:length(KPaths{m})
        for k=1:length(luduan_zhan)
            if isequal(cell2mat(luduan_zhan{k}),KPaths{m}([i-1 i]))
                Mxf(m,k)=1;
            end
        end
    end
    m=m+1;
end
%==========================================================================

%% 3.3 有效路径路径-换乘路段的01矩阵
%==========================================================================
if ~isempty(KHc_hcld_a)
    M=zeros(size(Mxf));
    for k=1:length(KPaths)
        M(k,[cell2mat(KHc_hcld_a{k})])=Cost_of_Transfer;
    end
end
%==========================================================================

%% 4. 主要计算结果
%==========================================================================
KPaths             %有效路径
KCosts             %有效路径的费用（本文指时间）
KHc_n              %换乘次数
KHc_hcd=KHc_hcd    %换乘点
KHc_hcqj=KHc_hcqj  %换乘区间
KHc_hcld_a         %换乘路段
% Mxf                %有效路径与路段的0-1矩阵（为Frank Wolfe算法调用）
% M                  %路径-换乘路段的01矩阵（为Frank Wolfe算法调用）
%==========================================================================