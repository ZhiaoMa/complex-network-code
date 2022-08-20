
% 负载重分配模型
%节点初始负载F
%节点容量C
%网络节点i的  初始负载F_i  与  节点本身的度k_i  相关：F_i = rho * k_i^tau
%网络中的节点 容量C_i  与初始负载F_i  成正比：C_i=(1+alpha)*F_i
%节点i失效后，失效节点的负载分配到完好节点j上，按一定比例
%负载更新
%剩余节点的更新后负载F_j;             if   F_j>C_j   节点j失效，否则end
%网络中所有节点的负载不超过其本身容量，连锁故障过程结束

%度量
%度量连锁故障结束后网络中失效节点个数CF_i
%CFN=sum(CF_i)/(N*(N-1))

rho=4;
tau=1.6;  %负载参数（0.1,2）
beta=1.6; %和度有关的负载分配比例参数
theta=1;   %和距离有关的负载分配比例参数
alpha=0.1;  %容量参数

F = rho * DeD.^tau;%初始负载，1*N

C = (1+alpha).*F;%容量，1*N,一行矩阵，默认为固定值

f = (D.^theta) .* ( DeD.^beta)./sum(sum((D.^theta) .*  (DeD.^beta)));%负载分配比例，方阵
% F_Temp = F_Temp + F_Remove * f;  %更新后的临时负荷矩阵，1*（N-1）
% Fail=F_Temp > C_First;   %判断剩余节点更新后的负荷是否大于节点容量，是=1，否=0，1*（N-1）,即接下来要删除的节点位置

%%随机删除某一节点，删除节点所在行和列，生成新的邻边矩阵A_Temp
A_Temp=A;
% aver_D_Temp=aver_D;
% aver_DeD_Temp=aver_DeD;

NodesToRemove=[];
% DeD_average=aver_DeD;
% D_average=aver_D;

Fail_All=[];    %失效节点集合，1*50矩阵.
NodesToRemove_Free=[];

step1=0;    %监测for循环次数.
step2=0;    %监测第一个if循环次数.
step3=0;    %监测第二个if循环次数.
step4=0;    %监测while中的if循环次数.

NodesToRemovePerStep =1;    %每步移除节点数.
RemainingNodes=1:NumberOfNodes; %剩余节点数，1行N列向量.
NumberOfNodes_Temp=NumberOfNodes;   %临时节点数，数值.
for i=1:50
        F_Temp=F;   %重置F_Temp;
        C_Temp=C;   %重置C_Temp；
        f_Temp=f;   %重置f_Temp；
        
        NodeIndecesToRemove=randperm(numel(RemainingNodes),NodesToRemovePerStep); %随机抽取移除节点，序号.
        NodesToRemove_Temp1 = RemainingNodes(:,NodeIndecesToRemove);  %移除节点的初始序号，1*1.
        NodesToRemove_Free=[NodesToRemove_Free,NodesToRemove_Temp1];    %随机抽取的50个节点的初始序号.
        NodesToRemove=[NodesToRemove,NodesToRemove_Temp1];   %所有移除节点的初始序号，矩阵.
        step1=step1+1;

        %移除节点后，更新网络
        RemainingNodes(:,NodeIndecesToRemove)=[];       %总的节点中的剩余节点，将每次随机抽样的节点剔除，避免重复抽取.
        
        RemainingNodes_Temp=1:NumberOfNodes;            %临时剩余节点重置为1*N.
        RemainingNodes_Temp(:,NodesToRemove_Temp1)=[];   %更新临时剩余节点，1*（N-1）.
        NodesToRemove_If=[];        %重置每一步if循环后的移除节点集合.
        NodesToRemove_If=[NodesToRemove_If,NodesToRemove_Temp1]; %更新，1*1.
        A_Temp=A;       %重置临时网络矩阵A.
        A_Temp=A_Temp(RemainingNodes_Temp,RemainingNodes_Temp);   %更新临时网络矩阵A，(N-1)*(N-1)；

        [DeD,aver_DeD_Temp,Fail_Temp,Fail_Num]=Degree_Distribution_Nofigure(A_Temp);    %更新节点度，平均度，孤立点的位置，孤立点点数量
        
        Fail_Sum=0;     %重置
        
        
        if ~isempty(Fail_Temp)   %判断是否存在孤立点，有的话，进行if
            step2=step2+1;
            %%算上孤立点，孤立点的效果等同于移除节点，两者一前一后连续发生
            
            Fail_Sum=Fail_Sum+Fail_Num; %总的孤立点数量
            NodesToRemove_Temp2=RemainingNodes_Temp(:,Fail_Temp);     %孤立点的初始序号，矩阵.
            NodesToRemove=[NodesToRemove,NodesToRemove_Temp2];
            NodesToRemove_If=[NodesToRemove_If,NodesToRemove_Temp2];   %1个移除节点+孤立点的初始序号，1*（Fail_Num+1）矩阵.
            RemainingNodes_Temp(:,Fail_Temp)=[]; %剩余的节点，初始序号，矩阵1*（N-1-Fail_Num）.
            
            
            %%直接算（移除节点+孤立点）带来的负载影响
            F_Remove=F_Temp(:,NodesToRemove_If); %（移除节点+孤立点）的负载，负载是一直变化的.
            %f = (D.^theta) .* ( DeD.^beta)./sum(sum((D.^theta) .*  (DeD.^beta)));
            %%负载分配比例，方阵，简单起见，认为f固定不变
            
            f_Temp=f(NodesToRemove_If,:);    %选择（移除节点+孤立点）所在行.
            f_Temp(:,NodesToRemove_If)=[];         %删除（移除节点+孤立点）的列.
            F_Temp(:,NodesToRemove_If)=[];   %临时负荷中，（移除节点+孤立点）所在列.
            F_Temp = F_Temp + F_Remove * f_Temp;  %更新剩余剩余负荷，即临时负荷 ，一行矩阵.
            
            %%判断临时负荷F_Temp 和 对应容量C_Temp 大小关系，if F_Temp>C_Temp，节点（级联）失效
            %%节点（级联）失效，效果等同于 孤立点，移除节点
            C_Temp = C(:,RemainingNodes_Temp);   %剩余节点对应的容量.
            
            NodesFailure=F_Temp>C_Temp;     %一行逻辑矩阵,找到F_Temp>C_Temp 具体位置.
            
        else
            %%移除节点带来的负载影响
            F_Remove=F_Temp(:,NodesToRemove_Temp1); %移除节点的负载，负载是一直变化的,1*1.
            
            f_Temp=f(NodesToRemove_Temp1,:);    %选择移除节点所在行,1*N.
            f_Temp(:,NodesToRemove_Temp1)=[];         %删除所有已经移除节点的列,1*(N-1).
            F_Temp(:,NodesToRemove_Temp1)=[];   %临时负荷中，删除移除节点所在列，1*(N-1).
            F_Temp = F_Temp + F_Remove * f_Temp;  %更新剩余剩余负荷，即临时负荷 ，一行矩阵.
            C_Temp = C(:,RemainingNodes_Temp);   %剩余节点对应的容量，1*(N-1).
            NodesFailure=F_Temp>C_Temp;     %一行逻辑矩阵,找到F_Temp>C_Temp 具体位置.
            
        end
        
        while sum(NodesFailure)>0   %级联失效，引发进一步的节点失效，即节点删除
            step3=step3+1;
            NodeIndecesToRemove=find(NodesFailure);  %找到逻辑矩阵中，逻辑值1所在位置，即为级联失效节点位置.
            %F_Remove=F_Temp(:,NodeIndecesToRemove);  %移除节点的负载，负载是一直变化的.
            Fail_Sum=Fail_Sum+numel(NodeIndecesToRemove);
            
            NodesToRemove_Temp = RemainingNodes_Temp(:,NodeIndecesToRemove);  %级联失效节点的初始序号，矩阵.
            NodesToRemove=[NodesToRemove,NodesToRemove_Temp];
            NodesToRemove_If=[NodesToRemove_If,NodesToRemove_Temp];   %所有(移除节点+孤立点+级联失效点）的初始序号，矩阵.
            
            %移除节点后，更新网络
            RemainingNodes_Temp(:,NodeIndecesToRemove)=[];   %剩余节点的初始序号，矩阵.
            RemainingNodes_Temp1=1:length(RemainingNodes_Temp);
            
            %C_Temp=C;   %重置C_Temp；
            %f_Temp=f;   %重置f_Temp；
            A_Temp=A;
            A_Temp=A_Temp(RemainingNodes_Temp,RemainingNodes_Temp);   %剩余节点的行和列；

            [DeD,aver_DeD_Temp,Fail_Temp,Fail_Num]=Degree_Distribution_Nofigure(A_Temp);    %更新节点度，平均度，孤立点的位置，孤立点点数量
         
            %%判断级联失效，是否会带来新的  孤立点， 以及  新一轮的  级联失效.
         if ~isempty(Fail_Temp)   %判断是否存在孤立点，有的话，进行if
            step4=step4+1;
            
            %%算上孤立点
            Fail_Sum=Fail_Sum+Fail_Num; %总的孤立点数量
            NodesToRemove_Temp2=RemainingNodes_Temp(:,Fail_Temp);     %孤立点的初始序号，矩阵.
            NodesToRemove_Temp3=RemainingNodes_Temp1(:,Fail_Temp);      %孤立点的前一次序号.
            NodesToRemove=[NodesToRemove,NodesToRemove_Temp2];
            NodesToRemove_If=[NodesToRemove_If,NodesToRemove_Temp2];   
            RemainingNodes_Temp(:,Fail_Temp)=[]; %剩余的节点，初始序号.
            
            
            %%直接算（移除节点+孤立点）带来的负载影响
            F_Remove=F_Temp(:,[NodeIndecesToRemove,NodesToRemove_Temp3]); %（级联失效节点+孤立点）的负载，负载是一直变化的.
            %f = (D.^theta) .* ( DeD.^beta)./sum(sum((D.^theta) .*  (DeD.^beta)));
            %%负载分配比例，方阵，简单起见，认为f固定不变
            
            f_Temp=f([NodesToRemove_Temp,NodesToRemove_Temp2],:);    %选择（级联失效节点+孤立点）所在行.
            f_Temp(:,NodesToRemove_If)=[];         %删除（移除节点+孤立点+级联失效）的列.
            F_Temp(:,[NodeIndecesToRemove,NodesToRemove_Temp3])=[];   %临时负荷中，删除（级联失效节点+孤立点）所在列.
            F_Temp = F_Temp + F_Remove * f_Temp;  %更新剩余剩余负荷，即临时负荷 ，一行矩阵.
            
            %%判断临时负荷F_Temp 和 对应容量C_Temp 大小关系，if F_Temp>C_Temp，节点（级联）失效
            %%节点（级联）失效，效果等同于 孤立点，移除节点
            C_Temp = C(:,RemainingNodes_Temp);   %剩余节点对应的容量.
            
            NodesFailure=F_Temp>C_Temp;     %一行逻辑矩阵,找到F_Temp>C_Temp 具体位置.

        else
            %%移除节点带来的负载影响
            F_Remove=F_Temp(:,NodeIndecesToRemove); %级联失效节点的负载，负载是一直变化的,1*1.
            
            f_Temp=f(NodesToRemove_Temp,:);    %选择级联失效节点所在行,1*N.
            f_Temp(:,NodesToRemove_If)=[];         %删除所有已经移除节点的列,1*(N-1).
            F_Temp(:,NodeIndecesToRemove)=[];   %临时负荷中，删除移除节点所在列，1*(N-1).
            F_Temp = F_Temp + F_Remove * f_Temp;  %更新剩余剩余负荷，即临时负荷 ，一行矩阵.
            C_Temp = C(:,RemainingNodes_Temp);   %剩余节点对应的容量，1*(N-1).
            NodesFailure=F_Temp>C_Temp;     %一行逻辑矩阵,找到F_Temp>C_Temp 具体位置.

        end
            
   
        end
        Fail_All=[Fail_All,Fail_Sum];       %更新失效节点集合,1*i.
        

end
CFN=sum(Fail_All)/(50*(50-1));
fprintf('平均失效规模: %8.6f%\n',CFN);


