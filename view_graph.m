%https://blog.csdn.net/weixin_44771757/article/details/104610155  参考

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

G = digraph(A); %其中A是图的邻接矩阵表示，该函数返回digraph对象G
p = plot(G); %返回一个Graphplot对象p

G = digraph(EdgeTable,NodeTable) %利用边信息表和节点信息表构图
%其中，EdgeTable一般包含边所连接的两个节点以及边的权重等信息，NodeTable一般包含节点的标号以及节点的度等信息
%% 指定线条与点的颜色与类型
p=plot(H1,'-b')%指定线条的类型，'-'为线条形状，'b'为线条颜色
p.Marker = 's';%指定节点的形状为正方形
p.NodeColor = 'r';%指定节点的颜色为红色
p.MarkerSize =10;%指定节点的大小为10

%% 自定义节点标号
Labels1={'F1','F2','D1','D2','D3','D4','D6','M1','M2','M3','M4','M6','M7','G1'};
p.NodeLabel=Labels1;

%% 指定图像布局
p=plot(H1,'-b','Layout','circle')%指定Layout为circle来更改图像布局

%% 使边的粗细反映边的权重
LWidths1 = 10*H1.Edges.Weight/max(H1.Edges.Weight);
p.LineWidth = LWidths1;

%% 使节点的大小与颜色反映节点的度数
%增加节点信息重新构图
EdgeTable=H1.Edges;
NodeWeight=indegree(H1)+outdegree(H1);
Labels1={'F1','F2','F3','D1','D2','D3','D4','D5','M1','M2','M3','M4','M5','G1'}';
NodeTable=table(Labels1,NodeWeight);
H2=digraph(EdgeTable,NodeTable);
...
...
...
p.MarkerSize = log(H2.Nodes.NodeWeight+1.1)*15;%节点大小
p.NodeCData=H2.Nodes.NodeWeight;               %节点颜色
colorbar                                       %显示颜色样条

%% 添加坐标
p.XData=meanx;
p.YData=meany;
%限定坐标系范围
xlim([0 100])
ylim([0 100])
%指定坐标刻度
xticks(0:10:100); 
yticks(0:10:100); 

%% 另一种方法

w=[41 99 51 32 15 45 38 32 36 29 21];%权值向量
 
dg=sparse([6 1 2 2 3 4 4 5 5 6 1],[2 6 3 5 4 1 6 3 4 3 5],w)%构造的稀疏矩阵表示图
 
h=view(biograph(dg,[],'ShowWeights','on'))%显示图的结构
 
dist=graphallshortestpaths(dg) %显示图中每对结点之间的最短路径　