%https://blog.csdn.net/weixin_44771757/article/details/104610155  �ο�

clc
clear

A=[ 0     1     0     1     0     0     0     0     0     0
    1     0     1     0     0     0     0     0     0     0
    0     1     0     1     0     0     0     0     0     0
    1     0     1     0     0     1     0     0     0     0
    0     0     0     0     0     1     0     0     0     0
    0     0     0     1     1     0     1     0     0     0
    0     0     0     0     0     1     0     1     0     0
    0     0     0     0     0     0     1     0     1     1
    0     0     0     0     0     0     0     1     0     1
    0     0     0     0     0     0     0     1     1     0];

G = digraph(A); %����A��ͼ���ڽӾ����ʾ���ú�������digraph����G
p = plot(G); %����һ��Graphplot����p

G = digraph(EdgeTable,NodeTable) %���ñ���Ϣ��ͽڵ���Ϣ��ͼ
%���У�EdgeTableһ������������ӵ������ڵ��Լ��ߵ�Ȩ�ص���Ϣ��NodeTableһ������ڵ�ı���Լ��ڵ�Ķȵ���Ϣ
%% ָ������������ɫ������
p=plot(H1,'-b')%ָ�����������ͣ�'-'Ϊ������״��'b'Ϊ������ɫ
p.Marker = 's';%ָ���ڵ����״Ϊ������
p.NodeColor = 'r';%ָ���ڵ����ɫΪ��ɫ
p.MarkerSize =10;%ָ���ڵ�Ĵ�СΪ10

%% �Զ���ڵ���
Labels1={'F1','F2','D1','D2','D3','D4','D6','M1','M2','M3','M4','M6','M7','G1'};
p.NodeLabel=Labels1;

%% ָ��ͼ�񲼾�
p=plot(H1,'-b','Layout','circle')%ָ��LayoutΪcircle������ͼ�񲼾�

%% ʹ�ߵĴ�ϸ��ӳ�ߵ�Ȩ��
LWidths1 = 10*H1.Edges.Weight/max(H1.Edges.Weight);
p.LineWidth = LWidths1;

%% ʹ�ڵ�Ĵ�С����ɫ��ӳ�ڵ�Ķ���
%���ӽڵ���Ϣ���¹�ͼ
EdgeTable=H1.Edges;
NodeWeight=indegree(H1)+outdegree(H1);
Labels1={'F1','F2','F3','D1','D2','D3','D4','D5','M1','M2','M3','M4','M5','G1'}';
NodeTable=table(Labels1,NodeWeight);
H2=digraph(EdgeTable,NodeTable);
...
...
...
p.MarkerSize = log(H2.Nodes.NodeWeight+1.1)*15;%�ڵ��С
p.NodeCData=H2.Nodes.NodeWeight;               %�ڵ���ɫ
colorbar                                       %��ʾ��ɫ����

%% �������
p.XData=meanx;
p.YData=meany;
%�޶�����ϵ��Χ
xlim([0 100])
ylim([0 100])
%ָ������̶�
xticks(0:10:100); 
yticks(0:10:100); 

%% ��һ�ַ���

w=[41 99 51 32 15 45 38 32 36 29 21];%Ȩֵ����
 
dg=sparse([6 1 2 2 3 4 4 5 5 6 1],[2 6 3 5 4 1 6 3 4 3 5],w)%�����ϡ������ʾͼ
 
h=view(biograph(dg,[],'ShowWeights','on'))%��ʾͼ�Ľṹ
 
dist=graphallshortestpaths(dg) %��ʾͼ��ÿ�Խ��֮������·����