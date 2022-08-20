clear
clc
%% ===============================================================
% K��·�㷨+�����㷨
% �������huanchengcishu.m
% ��Ҫ��������KPaths KCosts Mxf��
%==========================================================================

%% 1. ���벢������ص�·������
%==========================================================================
luwangshuju;
shujuchuli;
k=1;
n=0;
%==========================================================================

%% 2. K��·��ͻ����㷨��ϣ������Ч·��
%==========================================================================
if ismember([O D],zhan) & O~=D
    %% 2.1 ����Dijkstra�㷨������··��������
    [path costs]=dijkstra(Road_Net, O, D);
    if isempty(path)
        KPaths=[];
        KCosts=[];
    else
        %% 2.2 ��ʼ��
        path_number = 1;                %·����1��ʼ���
        P{path_number,1}= path;         %��Ԫ����P��һ�б�ʾ·��
        P{path_number,2}= costs;        %��Ԫ����P�ڶ��б�ʾ·���迹
        current_P = path_number;
        size_X=1;
        X{size_X}={path_number; path; costs};%1-��ţ�2-·����3-�迹ֵ
        S(path_number)= path(1);        %·���Ŀ�ʼվ��
        KPaths{k}= path;
        KCosts{k}= costs;
        
        %% 2.3 ���û��˴�������
        while (k<Kmax && size_X ~=0)
            huanchengcishu;                                %���·��k�Ļ��˴���
            KHc_n{k}=KHc_cishu;
            KCosts{k}=KCosts{k}+KHc_cishu*Cost_of_Transfer;%������ǻ��˺���ܷ���
            costs=min(cell2mat(KCosts));                   %������С����

            %% 2.4 ɾ������Ч·��
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
            %% 2.5 �ر���������·��
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
                    w_index_in_path=i;                           %�ҵ�w��·���е�λ��
                end
            end
            %% 2.6 ����·������
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
                    if length(KPaths{i})>= index_dev_vertex     %���·�����ȴ���index_dev_vertex������û���������
                        if P_(1:index_dev_vertex)== KPaths{i}(1:index_dev_vertex)   %�Աȵ�ǰ·����K·����ǰindex_dev_vertex���㣬���ƥ�䣬�����Աȣ�����Ϊ��ƥ��
                            index = index+1;                    %ƥ��ɹ����Զ�������һ���ڵ�Ա�
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
                    P{path_number,1}=[sub_P(1:end-1) dev_p];     %������㵽�յ��·��
                    P{path_number,2}= costs_sub_P + c ;          %������·����ƫ��㵽�յ���õĺͣ����շ��ã�
                    S(path_number)= P_(index_dev_vertex);
                    size_X = size_X + 1;
                    X{size_X}={path_number; P{path_number,1};P{path_number,2}};
                    %                                             ���µ�ǰ���ݣ�·����ţ�·����·�����ã�
                end
            end
            %% 2.7 ���������ָ��·����Ŀ����·�������Ŀ�������������Ľ���ᷢ���ظ�,Ҳ���ܽ�����ѭ����
            if size_X > 0
                shortestXCosts= X{1}{3};                         %·������
                shortestX= X{1}{1};                              %�ж�·��
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
    warning('�����յ㲻��ָ��·���У�����������������롣����');
    pause
    KSP
end
%==========================================================================
%% 3.��Ч·��
%% 3.1 ������Ч·��������
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

%% 3.2 ������Ч·�����·��-·�ε�01����
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

%% 3.3 ��Ч·��·��-����·�ε�01����
%==========================================================================
if ~isempty(KHc_hcld_a)
    M=zeros(size(Mxf));
    for k=1:length(KPaths)
        M(k,[cell2mat(KHc_hcld_a{k})])=Cost_of_Transfer;
    end
end
%==========================================================================

%% 4. ��Ҫ������
%==========================================================================
KPaths             %��Ч·��
KCosts             %��Ч·���ķ��ã�����ָʱ�䣩
KHc_n              %���˴���
KHc_hcd=KHc_hcd    %���˵�
KHc_hcqj=KHc_hcqj  %��������
KHc_hcld_a         %����·��
% Mxf                %��Ч·����·�ε�0-1����ΪFrank Wolfe�㷨���ã�
% M                  %·��-����·�ε�01����ΪFrank Wolfe�㷨���ã�
%==========================================================================