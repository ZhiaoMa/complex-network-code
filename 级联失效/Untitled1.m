
% �����ط���ģ��
%�ڵ��ʼ����F
%�ڵ�����C
%����ڵ�i��  ��ʼ����F_i  ��  �ڵ㱾��Ķ�k_i  ��أ�F_i = rho * k_i^tau
%�����еĽڵ� ����C_i  ���ʼ����F_i  �����ȣ�C_i=(1+alpha)*F_i
%�ڵ�iʧЧ��ʧЧ�ڵ�ĸ��ط��䵽��ýڵ�j�ϣ���һ������
%���ظ���
%ʣ��ڵ�ĸ��º���F_j;             if   F_j>C_j   �ڵ�jʧЧ������end
%���������нڵ�ĸ��ز������䱾���������������Ϲ��̽���

%����
%�����������Ͻ�����������ʧЧ�ڵ����CF_i
%CFN=sum(CF_i)/(N*(N-1))

rho=4;
tau=1.6;  %���ز�����0.1,2��
beta=1.6; %�Ͷ��йصĸ��ط����������
theta=1;   %�;����йصĸ��ط����������
alpha=0.1;  %��������

F = rho * DeD.^tau;%��ʼ���أ�1*N

C = (1+alpha).*F;%������1*N,һ�о���Ĭ��Ϊ�̶�ֵ

f = (D.^theta) .* ( DeD.^beta)./sum(sum((D.^theta) .*  (DeD.^beta)));%���ط������������
% F_Temp = F_Temp + F_Remove * f;  %���º����ʱ���ɾ���1*��N-1��
% Fail=F_Temp > C_First;   %�ж�ʣ��ڵ���º�ĸ����Ƿ���ڽڵ���������=1����=0��1*��N-1��,��������Ҫɾ���Ľڵ�λ��

%%���ɾ��ĳһ�ڵ㣬ɾ���ڵ������к��У������µ��ڱ߾���A_Temp
A_Temp=A;
% aver_D_Temp=aver_D;
% aver_DeD_Temp=aver_DeD;

NodesToRemove=[];
% DeD_average=aver_DeD;
% D_average=aver_D;

Fail_All=[];    %ʧЧ�ڵ㼯�ϣ�1*50����.
NodesToRemove_Free=[];

step1=0;    %���forѭ������.
step2=0;    %����һ��ifѭ������.
step3=0;    %���ڶ���ifѭ������.
step4=0;    %���while�е�ifѭ������.

NodesToRemovePerStep =1;    %ÿ���Ƴ��ڵ���.
RemainingNodes=1:NumberOfNodes; %ʣ��ڵ�����1��N������.
NumberOfNodes_Temp=NumberOfNodes;   %��ʱ�ڵ�������ֵ.
for i=1:50
        F_Temp=F;   %����F_Temp;
        C_Temp=C;   %����C_Temp��
        f_Temp=f;   %����f_Temp��
        
        NodeIndecesToRemove=randperm(numel(RemainingNodes),NodesToRemovePerStep); %�����ȡ�Ƴ��ڵ㣬���.
        NodesToRemove_Temp1 = RemainingNodes(:,NodeIndecesToRemove);  %�Ƴ��ڵ�ĳ�ʼ��ţ�1*1.
        NodesToRemove_Free=[NodesToRemove_Free,NodesToRemove_Temp1];    %�����ȡ��50���ڵ�ĳ�ʼ���.
        NodesToRemove=[NodesToRemove,NodesToRemove_Temp1];   %�����Ƴ��ڵ�ĳ�ʼ��ţ�����.
        step1=step1+1;

        %�Ƴ��ڵ�󣬸�������
        RemainingNodes(:,NodeIndecesToRemove)=[];       %�ܵĽڵ��е�ʣ��ڵ㣬��ÿ����������Ľڵ��޳��������ظ���ȡ.
        
        RemainingNodes_Temp=1:NumberOfNodes;            %��ʱʣ��ڵ�����Ϊ1*N.
        RemainingNodes_Temp(:,NodesToRemove_Temp1)=[];   %������ʱʣ��ڵ㣬1*��N-1��.
        NodesToRemove_If=[];        %����ÿһ��ifѭ������Ƴ��ڵ㼯��.
        NodesToRemove_If=[NodesToRemove_If,NodesToRemove_Temp1]; %���£�1*1.
        A_Temp=A;       %������ʱ�������A.
        A_Temp=A_Temp(RemainingNodes_Temp,RemainingNodes_Temp);   %������ʱ�������A��(N-1)*(N-1)��

        [DeD,aver_DeD_Temp,Fail_Temp,Fail_Num]=Degree_Distribution_Nofigure(A_Temp);    %���½ڵ�ȣ�ƽ���ȣ��������λ�ã������������
        
        Fail_Sum=0;     %����
        
        
        if ~isempty(Fail_Temp)   %�ж��Ƿ���ڹ����㣬�еĻ�������if
            step2=step2+1;
            %%���Ϲ����㣬�������Ч����ͬ���Ƴ��ڵ㣬����һǰһ����������
            
            Fail_Sum=Fail_Sum+Fail_Num; %�ܵĹ���������
            NodesToRemove_Temp2=RemainingNodes_Temp(:,Fail_Temp);     %������ĳ�ʼ��ţ�����.
            NodesToRemove=[NodesToRemove,NodesToRemove_Temp2];
            NodesToRemove_If=[NodesToRemove_If,NodesToRemove_Temp2];   %1���Ƴ��ڵ�+������ĳ�ʼ��ţ�1*��Fail_Num+1������.
            RemainingNodes_Temp(:,Fail_Temp)=[]; %ʣ��Ľڵ㣬��ʼ��ţ�����1*��N-1-Fail_Num��.
            
            
            %%ֱ���㣨�Ƴ��ڵ�+�����㣩�����ĸ���Ӱ��
            F_Remove=F_Temp(:,NodesToRemove_If); %���Ƴ��ڵ�+�����㣩�ĸ��أ�������һֱ�仯��.
            %f = (D.^theta) .* ( DeD.^beta)./sum(sum((D.^theta) .*  (DeD.^beta)));
            %%���ط�����������󣬼��������Ϊf�̶�����
            
            f_Temp=f(NodesToRemove_If,:);    %ѡ���Ƴ��ڵ�+�����㣩������.
            f_Temp(:,NodesToRemove_If)=[];         %ɾ�����Ƴ��ڵ�+�����㣩����.
            F_Temp(:,NodesToRemove_If)=[];   %��ʱ�����У����Ƴ��ڵ�+�����㣩������.
            F_Temp = F_Temp + F_Remove * f_Temp;  %����ʣ��ʣ�ฺ�ɣ�����ʱ���� ��һ�о���.
            
            %%�ж���ʱ����F_Temp �� ��Ӧ����C_Temp ��С��ϵ��if F_Temp>C_Temp���ڵ㣨������ʧЧ
            %%�ڵ㣨������ʧЧ��Ч����ͬ�� �����㣬�Ƴ��ڵ�
            C_Temp = C(:,RemainingNodes_Temp);   %ʣ��ڵ��Ӧ������.
            
            NodesFailure=F_Temp>C_Temp;     %һ���߼�����,�ҵ�F_Temp>C_Temp ����λ��.
            
        else
            %%�Ƴ��ڵ�����ĸ���Ӱ��
            F_Remove=F_Temp(:,NodesToRemove_Temp1); %�Ƴ��ڵ�ĸ��أ�������һֱ�仯��,1*1.
            
            f_Temp=f(NodesToRemove_Temp1,:);    %ѡ���Ƴ��ڵ�������,1*N.
            f_Temp(:,NodesToRemove_Temp1)=[];         %ɾ�������Ѿ��Ƴ��ڵ����,1*(N-1).
            F_Temp(:,NodesToRemove_Temp1)=[];   %��ʱ�����У�ɾ���Ƴ��ڵ������У�1*(N-1).
            F_Temp = F_Temp + F_Remove * f_Temp;  %����ʣ��ʣ�ฺ�ɣ�����ʱ���� ��һ�о���.
            C_Temp = C(:,RemainingNodes_Temp);   %ʣ��ڵ��Ӧ��������1*(N-1).
            NodesFailure=F_Temp>C_Temp;     %һ���߼�����,�ҵ�F_Temp>C_Temp ����λ��.
            
        end
        
        while sum(NodesFailure)>0   %����ʧЧ��������һ���Ľڵ�ʧЧ�����ڵ�ɾ��
            step3=step3+1;
            NodeIndecesToRemove=find(NodesFailure);  %�ҵ��߼������У��߼�ֵ1����λ�ã���Ϊ����ʧЧ�ڵ�λ��.
            %F_Remove=F_Temp(:,NodeIndecesToRemove);  %�Ƴ��ڵ�ĸ��أ�������һֱ�仯��.
            Fail_Sum=Fail_Sum+numel(NodeIndecesToRemove);
            
            NodesToRemove_Temp = RemainingNodes_Temp(:,NodeIndecesToRemove);  %����ʧЧ�ڵ�ĳ�ʼ��ţ�����.
            NodesToRemove=[NodesToRemove,NodesToRemove_Temp];
            NodesToRemove_If=[NodesToRemove_If,NodesToRemove_Temp];   %����(�Ƴ��ڵ�+������+����ʧЧ�㣩�ĳ�ʼ��ţ�����.
            
            %�Ƴ��ڵ�󣬸�������
            RemainingNodes_Temp(:,NodeIndecesToRemove)=[];   %ʣ��ڵ�ĳ�ʼ��ţ�����.
            RemainingNodes_Temp1=1:length(RemainingNodes_Temp);
            
            %C_Temp=C;   %����C_Temp��
            %f_Temp=f;   %����f_Temp��
            A_Temp=A;
            A_Temp=A_Temp(RemainingNodes_Temp,RemainingNodes_Temp);   %ʣ��ڵ���к��У�

            [DeD,aver_DeD_Temp,Fail_Temp,Fail_Num]=Degree_Distribution_Nofigure(A_Temp);    %���½ڵ�ȣ�ƽ���ȣ��������λ�ã������������
         
            %%�жϼ���ʧЧ���Ƿ������µ�  �����㣬 �Լ�  ��һ�ֵ�  ����ʧЧ.
         if ~isempty(Fail_Temp)   %�ж��Ƿ���ڹ����㣬�еĻ�������if
            step4=step4+1;
            
            %%���Ϲ�����
            Fail_Sum=Fail_Sum+Fail_Num; %�ܵĹ���������
            NodesToRemove_Temp2=RemainingNodes_Temp(:,Fail_Temp);     %������ĳ�ʼ��ţ�����.
            NodesToRemove_Temp3=RemainingNodes_Temp1(:,Fail_Temp);      %�������ǰһ�����.
            NodesToRemove=[NodesToRemove,NodesToRemove_Temp2];
            NodesToRemove_If=[NodesToRemove_If,NodesToRemove_Temp2];   
            RemainingNodes_Temp(:,Fail_Temp)=[]; %ʣ��Ľڵ㣬��ʼ���.
            
            
            %%ֱ���㣨�Ƴ��ڵ�+�����㣩�����ĸ���Ӱ��
            F_Remove=F_Temp(:,[NodeIndecesToRemove,NodesToRemove_Temp3]); %������ʧЧ�ڵ�+�����㣩�ĸ��أ�������һֱ�仯��.
            %f = (D.^theta) .* ( DeD.^beta)./sum(sum((D.^theta) .*  (DeD.^beta)));
            %%���ط�����������󣬼��������Ϊf�̶�����
            
            f_Temp=f([NodesToRemove_Temp,NodesToRemove_Temp2],:);    %ѡ�񣨼���ʧЧ�ڵ�+�����㣩������.
            f_Temp(:,NodesToRemove_If)=[];         %ɾ�����Ƴ��ڵ�+������+����ʧЧ������.
            F_Temp(:,[NodeIndecesToRemove,NodesToRemove_Temp3])=[];   %��ʱ�����У�ɾ��������ʧЧ�ڵ�+�����㣩������.
            F_Temp = F_Temp + F_Remove * f_Temp;  %����ʣ��ʣ�ฺ�ɣ�����ʱ���� ��һ�о���.
            
            %%�ж���ʱ����F_Temp �� ��Ӧ����C_Temp ��С��ϵ��if F_Temp>C_Temp���ڵ㣨������ʧЧ
            %%�ڵ㣨������ʧЧ��Ч����ͬ�� �����㣬�Ƴ��ڵ�
            C_Temp = C(:,RemainingNodes_Temp);   %ʣ��ڵ��Ӧ������.
            
            NodesFailure=F_Temp>C_Temp;     %һ���߼�����,�ҵ�F_Temp>C_Temp ����λ��.

        else
            %%�Ƴ��ڵ�����ĸ���Ӱ��
            F_Remove=F_Temp(:,NodeIndecesToRemove); %����ʧЧ�ڵ�ĸ��أ�������һֱ�仯��,1*1.
            
            f_Temp=f(NodesToRemove_Temp,:);    %ѡ����ʧЧ�ڵ�������,1*N.
            f_Temp(:,NodesToRemove_If)=[];         %ɾ�������Ѿ��Ƴ��ڵ����,1*(N-1).
            F_Temp(:,NodeIndecesToRemove)=[];   %��ʱ�����У�ɾ���Ƴ��ڵ������У�1*(N-1).
            F_Temp = F_Temp + F_Remove * f_Temp;  %����ʣ��ʣ�ฺ�ɣ�����ʱ���� ��һ�о���.
            C_Temp = C(:,RemainingNodes_Temp);   %ʣ��ڵ��Ӧ��������1*(N-1).
            NodesFailure=F_Temp>C_Temp;     %һ���߼�����,�ҵ�F_Temp>C_Temp ����λ��.

        end
            
   
        end
        Fail_All=[Fail_All,Fail_Sum];       %����ʧЧ�ڵ㼯��,1*i.
        

end
CFN=sum(Fail_All)/(50*(50-1));
fprintf('ƽ��ʧЧ��ģ: %8.6f%\n',CFN);


