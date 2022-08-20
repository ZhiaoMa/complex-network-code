%Cascad_Failure
clear all
close all
clc
tic
%% ԭʼ���ݣ�����ĸ��غ�����ֱ�Ӹ������кฺܶ������ģ�Ϳ��Լ޽��޸�
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

%% ��������
N=length(A);                        % �ܵĽڵ���
node_index=[];                      % �ڵ��ţ�������ǽڵ��λ��
new_failure=[];                     % �������𻵵�
fail_node_temp=[];                  % ��ʱ��Ż��Ľڵ�
fail_nodes=[];                      % �����𻵵Ľڵ㼯��
isolated_node=[];                   % �����㼯��
total_failure=[];                   % �ܵ��𻵵㣬��������ʧЧ+�����ĵ�
good_isolated_nodes=[];             % ��õĹ����ڵ�ļ���
A_temp=A;                           % ��ԭʼ���󱣴�Ϊ��ʱ�ڽӾ���
A_change=A_temp;                    % ��ʱ����ɱ��С�ľ���
Node_load_temp=[];                  % ��ʱ��Žڵ㸺��
i=0;                                % �����Ĳ���
%% ׼������
node_index=1:N;                     % �������
%% ����ʧЧ������

new_failure=[1 6];
% Ԥ��ָ���������Ľڵ�

total_failure=new_failure;
fail_nodes=new_failure;
Node_load_temp = Node_load;         % �ݴ�ڵ�ĸ���

while ~isempty(new_failure) && length(total_failure)~=N   % �жϵ���ֹͣ������
    %% ��0���ж��ǲ����й����ڵ�
    if i==0
        [new_isolated, new_isolated_node_num ] = find_isolated(A_temp);
        for m=1:new_isolated_node_num
            A_temp(new_isolated(m),:)=0;
            A_temp(:,new_isolated(m))=0;              % ��A_temp�����й����ڵ�����߹�ϵ�Ƴ�
            
            index=find(node_index==new_isolated(m));
            node_index(index)=[];       % ���ڵ���������Ĺ����ڵ��Ƴ�
            A_change(index,:)=[];
            A_change(:,index)=[];       % ��A_change�����й����ڵ��Ƴ�
        end
        isolated_node = [isolated_node, new_isolated];
        total_failure = [total_failure, isolated_node];
    end
    
    %% ��1��ʧЧ�ڵ㵼�¼���ʧЧ��Ѱ����һ��ʧЧ�ڵ�
    for m=1:length(new_failure)
        % ����ʧЧ�ڵ���ھӽڵ�ı��
        neiber=find(A_temp(new_failure(m),:)==1);
        delta=[];
        % ����������ӵĸ��أ���������кܶ�Ĺ�ʽ����
        delta(neiber) = deal(Node_load_temp(new_failure(m)) .* Node_load(neiber)/sum(Node_load(neiber)));
        Node_load_temp(neiber) = deal(Node_load_temp(neiber) + delta(neiber)); % �����ط���
        
        k = new_failure(m);
        A_temp(k,:)=0;
        A_temp(:,k)=0;                     % ��A_temp�����м���ʧЧ�ڵ�����߹�ϵ�Ƴ�
        
        index=find(node_index==k);
        node_index(index)=[];              % ���ڵ���������ļ���ʧЧ�ڵ��Ƴ�
        A_change(index,:)=[];
        A_change(:,index)=[];              % ��A_change�����м���ʧЧ�ڵ��Ƴ�
    end
    
    Node_load_temp(new_failure(:))=0;  %��ʧЧ�Ľڵ�ĸ�������
    
    fail_node_temp=[];                     % ����ʧЧ���µ���һ��ʧЧ�Ľڵ㼯�ϴ洢����
    for k=1:length(node_index)
        kk = node_index(k);
        if Node_load_temp(kk)>Node_Capacity(kk)
            fail_node_temp = [fail_node_temp, kk]; % �õ����������ʧЧ�ڵ㼯��
        end
    end
    
%     fprintf('������ʧЧΪ: ');
%     if isempty(fail_node_temp)
%         disp('��')
%     else
%         disp(fail_node_temp);
%     end
    new_failure = fail_node_temp;
    
    %% ��2��Ѱ�����ɴ��Ĺ����ڵ�
    [isolated_node, ~ ] = find_isolated(A_change);
    new_isolated_node=node_index(isolated_node);
    
    for m=1:length(isolated_node)
        k=new_isolated_node(m);
        A_temp(k,:)=0;
        A_temp(:,k)=0;                          % ��A_temp�����м���ʧЧ�ڵ�����߹�ϵ�Ƴ�
        
        index=find(node_index==k);              % ���ڵ���������ļ���ʧЧ�ڵ��Ƴ�
        node_index(index)=[];
        A_change(index,:)=[];
        A_change(:,index)=[];                   % ��A_change�����м���ʧЧ�ڵ��Ƴ�
        %         Node_load_temp(index)=0;                % ����õĹ�����ĸ�������
    end
    
    good_isolated_nodes=unique([good_isolated_nodes, new_isolated_node]); % ͳ���ۼƵ���ù�����
%     fprintf('������õĹ����ڵ�: ');
%     if isempty(new_isolated_node)
%         disp('��')
%     else
%         disp(new_isolated_node)
%     end
    %% ��3��ͳ��ʧЧ�ڵ�
    fail_nodes = [fail_nodes,new_failure];
    total_failure = unique([total_failure, new_isolated_node, new_failure]);
    i=i+1;
%         figure
%         plot(graph(A_change));
end
good_isolated_nodes
fail_nodes
total_failure
i-1  % ��ʾ����ʧЧ�Ĵ���
toc
