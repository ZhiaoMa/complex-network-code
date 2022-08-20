clear all
close all
clc
EE=[];  BB=[];  TT={};

%% WT
Node_load = [274	531	10717	435	261	52867	386	29920	3051	456	195	0	1263	996	576	546	0	273	298	699	18843	0	610	3708	610	3313	55517	24089	21477	190671	11624	181557	217494	6058	6907	4316	22162	30279	24720	219204	259231	651454	93679	166981	702	649	0	318	504	690	459	513	266782	380371	667
];
Node_Capacity = 1.25*Node_load;
A=xlsread('C:\Users\hp\Desktop\W-T network.xlsx');
P=xlsread('C:\Users\hp\Desktop\W-T network.xlsx','边级联失效');

%% RT
Node_load = [52414	20277	42690	1783395	8543	1335252	4685	440349	67482	709198	6699	865271	324358	372738	180	22563	4465	2920	2380	546083	2120	14396	32006	1274829	93780	9229	113807	208289	2060	1021046	223249	741750	30455	711895	2450	0	4310	12021	1116909	7884	100012	131	1180389	51199	0	6402452	580058	190568	63489	2750006	265491	6207	58005	874519	211799	5136	373466	632323	1030	4174	595	253445	2806537	954741	6434153	321530	34593	339619	651929	8851	2837	2251834	202309	59273	122607	227027	77555	12108	427533	60413	335003	315577	20397	4016	269128	863088	627251	580050	577453	1323589	172121	35816	3123497	663333	469929	129090	1651051	8484	0	0	9397	2921	1238214	2970	639081	11955	14083	3893	12485	2985	1986562	14057	2450	64954	256414	459431	9331	4530	413990	43748	135584	365624	223308	768885	383	979633	52974	153358	505879	34847	108046	138580	332165	30625	8688	79037	1394609	137998	46046	150480	26897	1747005	7688	2401794	351700	1334444	126293	436072	1475885	273376	491016	414685	194252	430399	1161923	71845	152305	880	105994	35756	8503
];
Node_Capacity = 3*Node_load;
A=xlsread('C:\Users\hp\Desktop\R-T network.xlsx');
P=xlsread('C:\Users\hp\Desktop\R-T network.xlsx','边级联失效');

%% COM
Node_load = [274	531	10717	435	261	52867	386	29920	3051	456	195	0	1263	996	576	546	0	273	298	699	18843	0	610	3708	610	3313	55517	24089	21477	190671	11624	181557	217494	6058	6907	4316	22162	30279	24720	219204	259231	651454	93679	166981	702	649	0	318	504	690	459	513	266782	380371	667	52414	20277	42690	1783395	8543	1335252	4685	440349	67482	709198	6699	865271	324358	372738	180	22563	4465	2920	2380	546083	2120	14396	32006	1274829	93780	9229	113807	208289	2060	1021046	223249	741750	30455	711895	2450	0	4310	12021	1116909	7884	100012	131	1180389	51199	0	6402452	580058	190568	63489	2750006	265491	6207	58005	874519	211799	5136	373466	632323	1030	4174	595	253445	2806537	954741	6434153	321530	34593	339619	651929	8851	2837	2251834	202309	59273	122607	227027	77555	12108	427533	60413	335003	315577	20397	4016	269128	863088	627251	580050	577453	1323589	172121	35816	3123497	663333	469929	129090	1651051	8484	0	0	9397	2921	1238214	2970	639081	11955	14083	3893	12485	2985	1986562	14057	2450	64954	256414	459431	9331	4530	413990	43748	135584	365624	223308	768885	383	979633	52974	153358	505879	34847	108046	138580	332165	30625	8688	79037	1394609	137998	46046	150480	26897	1747005	7688	2401794	351700	1334444	126293	436072	1475885	273376	491016	414685	194252	430399	1161923	71845	152305	880	105994	35756	8503
];
Node_Capacity = 2*Node_load;
A=xlsread('C:\Users\hp\Desktop\composite network.xlsx');
P=xlsread('C:\Users\hp\Desktop\composite network.xlsx','边级联失效');

%% 级联失效主程序
for t =1:182;
    %% 符号说明
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
    node_index=1:N;                     % 标记索引
    
    new_failure=[];                     % 预先指定被攻击的节点
    fail_nodes=new_failure;
    Node_load_temp = Node_load;         % 暂存节点的负载
         
    %%  开始攻击  
    A_temp(P(t+1,7),P(t+1,8))=0;  A_temp(P(t+1,8),P(t+1,7))=0;   %边的逐个破坏
    [new_isolated, new_isolated_node_num ] = find_isolated(A_temp);  %判断有无产生孤立点
    new_failure=[new_isolated]; 
    
    if new_isolated_node_num==0;                            %断边没有产生孤立点
        E=network_efficient(A_temp);   EE=[EE,E];
        b=largestcomponent(A_temp); B=length(b); BB=[BB,B]; %直接计算网络效率和最大连通子图
        TT{t,1}=total_failure;
        A=A_temp; Node_load=Node_load_temp;  
        clearvars -except A Node_load Node_Capacity EE BB TT P  
    else                                                     %断边产生孤立点
       while ~isempty(new_failure) % 判断迭代停止的条件
            for m=1:length(new_failure)
                % 先找失效节点的邻居节点的编号
                neiber=find(A(new_failure(m),:)==1);
                delta=[];
                % 计算额外增加的负载，这里可以有很多的公式类型
                delta(neiber) = deal(Node_load_temp(new_failure(m)) .* Node_load(neiber)/sum(Node_load(neiber)));
                Node_load_temp(neiber) = deal(Node_load_temp(neiber) + delta(neiber)); % 负载重分配
                k = new_failure(m);
                A(k,:)=0;  A(:,k)=0;                                 % 将A矩阵中级联失效节点的连边关系移除
                A_temp(k,:)=0;  A_temp(:,k)=0;                       % 将A_temp矩阵中级联失效节点的连边关系移除
                index=find(node_index==k);  node_index(index)=[];    % 将节点索引里面的级联失效节点移除
                A_change(index,:)=[]; A_change(:,index)=[];          % 将A_change矩阵中级联失效节点移除
            end
                Node_load_temp(new_failure(:))=0;      %把失效的节点的负载清零
                fail_node_temp=[];                     % 本轮失效导致的下一步失效的节点集合存储变量

            for k=1:length(node_index)
                kk = node_index(k);
                if Node_load_temp(kk)>Node_Capacity(kk)
                    fail_node_temp = [fail_node_temp, kk]; % 得到本轮引起的失效节点集合
                end
            end
            new_failure = fail_node_temp;
       end
        E=network_efficient(A_temp);   EE=[EE,E];
        b=largestcomponent(A_temp); B=length(b); BB=[BB,B]; %直接计算网络效率和最大连通子图
        TT{t,1}=total_failure;
        A=A_temp; Node_load=Node_load_temp;  
        clearvars -except A Node_load Node_Capacity EE BB TT P   
    end
    
end
BB=BB'; EE=EE';