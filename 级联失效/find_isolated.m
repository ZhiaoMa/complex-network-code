function [isolated_node,isolated_node_num] = find_isolated(A)
%% ��������ڵĹ����ڵ�
%A-------------------------����ͼ���ڽӾ���
%isolated_node-------------�������λ��
%isolated_node_num---------������ĸ���

N=size(A,2);
isolated_node=[];

for i=1:N
    if sum(A(i,:))==0         %�ж��Ƿ�Ϊ������.
        isolated_node(end+1)=i;
    end
end
isolated_node_num=length(isolated_node);
if isolated_node_num==N
    disp('������ͼȫ���ɹ��������');
    return;
end
