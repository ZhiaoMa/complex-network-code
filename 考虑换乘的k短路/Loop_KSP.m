clear
clc

%建立全网成本矩阵
Tcosts=cell(13,13);

Tcishu=cell(13,13);

%寻找全网最低换乘成本
for O=1:13;
    for D=O+1:13;
        
luwangshuju;
shujuchuli;
k=1;
n=0;

    [path costs]=dijkstra(Road_Net, O, D);
    if isempty(path)
        KPaths=[];
        KCosts=[];
    else

        path_number = 1;                %路径从1开始编号
        P{path_number,1}= path;         %单元数组P第一行表示路径
        P{path_number,2}= costs;        %单元数组P第二行表示路径阻抗
        current_P = path_number;
        size_X=1;
        X{size_X}={path_number; path; costs};%1-编号，2-路径，3-阻抗值
        S(path_number)= path(1);        %路径的开始站点
        KPaths{k}= path;
        KCosts{k}= costs;
        

        while (k<Kmax && size_X ~=0)
            huanchengcishu;                                %求出路径k的换乘次数
            KHc_n{k}=KHc_cishu;
            KCosts{k}=KCosts{k}+KHc_cishu*Cost_of_Transfer;%求出考虑换乘后的总费用
            costs=min(cell2mat(KCosts));                   %更新最小费用


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


KCosts=cell2mat(KCosts);
yxlj=find(KCosts<min(KCosts)*(1+H));
KCosts=KCosts(yxlj);
[KCosts,yxlj]=sort(KCosts);
KPaths=KPaths(yxlj);
KHc_n=KHc_n(yxlj);
KHc_hcd=KHc_hcd(yxlj);
KHc_hcqj=KHc_hcqj(yxlj);
KHc_hcld_a=KHc_hcld_a(yxlj);


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

if ~isempty(KHc_hcld_a)
    M=zeros(size(Mxf));
    for k=1:length(KPaths)
        M(k,[cell2mat(KHc_hcld_a{k})])=Cost_of_Transfer;
    end
end

Tcosts{O,D}=KCosts;
Tcishu{O,D}=cell2mat(KHc_n);
clearvars -except Tcosts luwangshuju shujuchuli O Tcishu

    end
end

