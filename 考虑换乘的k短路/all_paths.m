
%% 小算例邻接矩阵
clear;clc;

n=13;
A=[
     0     2   Inf     3   Inf   Inf   Inf   Inf   Inf   Inf   Inf   Inf   Inf
     2     0     4   Inf     4   Inf   Inf   Inf   Inf   Inf   Inf     3   Inf
   Inf     4     0   Inf   Inf     3   Inf   Inf   Inf   Inf   Inf   Inf   Inf
     3   Inf   Inf     0     8   Inf     2   Inf   Inf     4   Inf   Inf   Inf
   Inf     4   Inf     8     0     9   Inf     2   Inf   Inf   Inf   Inf   Inf
   Inf   Inf     3   Inf     9     0   Inf   Inf     4   Inf     5   Inf   Inf
   Inf   Inf   Inf     2   Inf   Inf     0     3   Inf   Inf   Inf   Inf   Inf
   Inf   Inf   Inf   Inf     2   Inf     3     0     6   Inf   Inf   Inf     3
   Inf   Inf   Inf   Inf   Inf     4   Inf     6     0   Inf   Inf   Inf   Inf
   Inf   Inf   Inf     4   Inf   Inf   Inf   Inf   Inf     0   Inf   Inf   Inf
   Inf   Inf   Inf   Inf   Inf     5   Inf   Inf   Inf   Inf     0   Inf   Inf
   Inf     2   Inf   Inf   Inf   Inf   Inf   Inf   Inf   Inf   Inf     0   Inf
   Inf   Inf   Inf   Inf   Inf   Inf   Inf     3   Inf   Inf   Inf   Inf     0];

% 线_站信息及数据准备
Three_St=[];             %换乘站的前中后三个站
huan_cheng=[2 4 5 6 8];  %换乘站信息
HC_temp=0;               %单OD换乘次数
HC_k1=[];                   %总换乘次数矩阵
Judge=[];                %判断逻辑
Total_T_k1=[];              %考虑换乘的总出行时间
xian_zhan={[1 2 3 6 9 8 7 4],[10 4 5 6 11],[12 2 5 8 13]};      %线路站点包含关系
zhan=[1 2 3 4 5 6 7 8 9 10 11 12 13];                           %站数据
xian=[1 2 3];                                                   %线路数据
    
%% 全网邻接矩阵-缺线路站点间运行时间
tic

clear
clc

n=343;
a=zeros(n);
A=xlsread('F:\北交事宜\科研\数据表\Beijinghalf.xlsx','2019');

for m = 1:length(A)         %邻接矩阵
    a(A(m,1),A(m,2))=A(m,5);
end

A=a+a'; A(A==0)=inf; A([1:n+1:n^2])=0;

% 线_站信息及数据准备-站数据343个-线路数据24条
Three_St=[];             %换乘站的前中后三个站
huan_cheng=[8	9	12	13	17	18	20	21	23	305	39	24	26	28	29	31	33	36	42	46	49	52	55	57	59	77	74	72	67	65	63	61	259	82	84	87	89	90	120	285	137	317	97	101	107	109	287	118	117	112	280	122	151	146	140	132	130	160	125	164	172
];  %换乘站信息
HC_temp=0;               %单OD换乘次数
HC=zeros(n);                   %总换乘次数矩阵
Judge=[];                %判断逻辑
Total_T=[];              %考虑换乘的总出行时间
xian_zhan={
    [1	2	3	4	5	6	7	8	9	10	11	12	13	14	15	16	17	18	19	20	21	22	23];
    [23	183	184	185	186	187	188	189	190	191	192	193	305];
    [25	24	39	38	12	37	36	35	34	33	32	18	31	30	29	28	27	26];
    [40	41	42	43	44	45	46	47	48	49	50	24	51	52	53	54	13	36	55	56	57	58	59	60	223	224	225	226	227	228	229	230	231	232	233];
    [80	79	78	77	76	75	74	73	72	71	70	28	69	68	67	66	17	33	65	64	63	62	61];
    [259	1	260	261	262	263	81	82	83	84	85	39	52	86	87	67	31	88	89	90	91	92	93	94	95	96	264	265	266	267	268	269	270	271];
    [120	323	324	325	55	326	285	327	65	328	329	137	317	330	331	332	333	334	335	336	337	338	339	340	341	342	343	306	305];
    [284	87	111	26	283	110	109	108	107	106	105	104	103	102	101	100	99	98	97];
    [296	295	294	293	292	291	290	289	288	287	286	285];
    [49	84	121	9	120	119	118	117	116	115	114	113	112];
    [139	138	137	20	136	89	135	134	133	132	131	130	72	129	109	128	127	126	125	124	46	123	122	156	155	154	82	153	8	152	118	151	150	149	148	147	146	59	145	144	143	61	142	141	140];
    [24	157	125	158	159	297	160	161	162	101	77	163	164	130	165	166	29];
    [307	308	309	172	310	311	312	313	314	315	316	90	21	317	318	319	140	320	63	321	287	322	57];
    [151	117	171	170	169	168	167];
    [182	181	180	179	178	177	176	175	174	173	303	172	164	302	74	301	107	300	299	298];
    [239	240	241	242	243	244	245	246	247	42];
    [112	211	212	213	214	215	216	217	218	219	220	280];
    [160	198	97	197	196	195	194	238	237	236	235	234];
    [61	199	200	201	202	203	204	205	206	207	208	209	210	304];
    [280	279	278	277	276	275	274	273	272];
    [122	252	251	250	249	248];
    [259	258	257	256	255	254	253];
    [29	132	222	221];
    [146	281	282]}';      %线路站点包含关系

%% 客流矩阵
Volume=zeros(n);
v=xlsread('C:\Users\hp\Desktop\20200106全天客流','0-24');
for m = 1:length(v)
    Volume(v(m,1),v(m,2))=v(m,3);
end 

%% 任意两点间最短路径Path及运行时间
[Running_T_k1,R] = all_shortest_paths(sparse(A));  

%减去首个停站时间
for i = 1:n;
    for j = 1:n
        if i~=j;
         Running_T_k1(i,j)=Running_T_k1(i,j)-40;
        end
    end
end

%all_shortest_paths回溯
Path_k1=cell(n,n);
p=[]; 
for i=1:n
  for j=1:n
    t=j; 
    while t~=0
      p(end+1)=t; 
       t=R(i,t); 
    end
      p=fliplr(p);
      Path_k1{i,j}=p;
      p=[];
  end
end

%% 寻找换乘次数

for i = 1:n
    for j = 1:n
       B=Path_k1{i,j};                                %临时存储路径
%       if length(B)>2
        for k =2:length(Path_k1{i,j})-1               %不考虑首尾车站
             if ismember(B(k),huan_cheng)==1       %是否是换乘站
                 Three_St=[B(k-1),B(k),B(k+1)];    %记录换乘站及前后的站点
                 for t =1:length(xian_zhan)
                     Judge=ismember(Three_St,cell2mat(xian_zhan(1,t)));
                     if sum(Judge)==2 && Judge(2)~=0  %是否发生换乘行为
                            HC_temp=HC_temp+0.5;   %三个站每两个站属于一条线，一次换乘两条线路满足
                     end
                 end
             end
        end
        HC_k1(i,j)=HC_temp; HC_temp=0;  %记录换乘次数，初始化临时换乘
%       end
    end
end

%% k短路的路径、时间

%k=2
Path_k2=cell(n,n);
Running_T_k2=zeros(n);

for i=1:n
   for j= 1:n
       [DIST,PATH]=graphkshortestpaths(sparse(A),i,j,2);
       Path_k2{i,j}=PATH{end};
       Running_T_k2(i,j)=DIST(end);
   end
end

%减去首个停站时间
for i = 1:n;
    for j = 1:n
        if i~=j;
         Running_T_k2(i,j)=Running_T_k2(i,j)-40;
        end
    end
end

%k=3
Path_k3=cell(n,n);
Running_T_k3=zeros(n);

for i=1:n
   for j= 1:n
       [DIST,PATH]=graphkshortestpaths(sparse(A),i,j,3);
       Path_k3{i,j}=PATH{end};
       Running_T_k3(i,j)=DIST(end);
   end
end

%减去首个停站时间
for i = 1:n;
    for j = 1:n
        if i~=j;
         Running_T_k3(i,j)=Running_T_k3(i,j)-40;
        end
    end
end

%% 超过1.5倍最短路径长度的予以删除
n=343;
%k=2
for i = 1:n
    for j = 1:n
        if Running_T_k2(i,j) > 1.5*Running_T_k1(i,j)
           Running_T_k2(i,j) = Running_T_k1(i,j);
                Path_k2(i,j) = Path_k1(i,j);
        end
    end
end

%k=3
for i = 1:n
    for j = 1:n
        if Running_T_k3(i,j) > 1.5*Running_T_k1(i,j)
           Running_T_k3(i,j) = Running_T_k1(i,j);
                Path_k3(i,j) = Path_k1(i,j);
        end
    end
end

%严格遵守时间1《=2《=3
for i = 1:n
    for j = 1:n
        if Running_T_k2(i,j) > Running_T_k3(i,j)
           Running_T_k2(i,j) = Running_T_k3(i,j);
                Path_k2(i,j) = Path_k3(i,j);
        end
    end
end

for i = 1:n
    for j = 1:n
        if Running_T_k1(i,j) > Running_T_k2(i,j)
           Running_T_k1(i,j) = Running_T_k2(i,j);
                Path_k1(i,j) = Path_k2(i,j);
        end
    end
end

%% 求k短路的换乘次数
%k=2
HC_k2=zeros(n);
for i = 1:n
    for j = 1:n
       B=Path_k2{i,j};                                %临时存储路径
%       if length(B)>2
        for k =2:length(Path_k2{i,j})-1               %不考虑首尾车站
             if ismember(B(k),huan_cheng)==1       %是否是换乘站
                 Three_St=[B(k-1),B(k),B(k+1)];    %记录换乘站及前后的站点
                 for t =1:length(xian_zhan)
                     Judge=ismember(Three_St,cell2mat(xian_zhan(1,t)));
                     if sum(Judge)==2 && Judge(2)~=0  %是否发生换乘行为
                            HC_temp=HC_temp+0.5;   %三个站每两个站属于一条线，一次换乘两条线路满足
                     end
                 end
             end
        end
        HC_k2(i,j)=HC_temp; HC_temp=0;  %记录换乘次数，初始化临时换乘
%       end
    end
end

%k=3
HC_k3=zeros(n);
for i = 1:n
    for j = 1:n
       B=Path_k3{i,j};                                %临时存储路径
%       if length(B)>2
        for k =2:length(Path_k3{i,j})-1               %不考虑首尾车站
             if ismember(B(k),huan_cheng)==1       %是否是换乘站
                 Three_St=[B(k-1),B(k),B(k+1)];    %记录换乘站及前后的站点
                 for t =1:length(xian_zhan)
                     Judge=ismember(Three_St,cell2mat(xian_zhan(1,t)));
                     if sum(Judge)==2 && Judge(2)~=0  %是否发生换乘行为
                            HC_temp=HC_temp+0.5;   %三个站每两个站属于一条线，一次换乘两条线路满足
                     end
                 end
             end
        end
        HC_k3(i,j)=HC_temp; HC_temp=0;  %记录换乘次数，初始化临时换乘
%       end
    end
end

%% 计算k短路平均出行时间和平均换乘时间

HC_T_k1=120*HC_k1;             %换乘等待时间   
Total_T_k1=HC_T_k1+Running_T_k1;          %运行时间+换乘时间
ave_total_T_k1=sum(sum(Volume.*Total_T_k1))/sum(sum(Volume));   %人均出行时间
ave_HC_T_k1=sum(sum(Volume.*HC_T_k1))/sum(sum(Volume)); %人均换乘等待时间

HC_T_k2=120*HC_k2;             %换乘等待时间   
Total_T_k2=HC_T_k2+Running_T_k2;          %运行时间+换乘时间
ave_total_T_k2=sum(sum(Volume.*Total_T_k2))/sum(sum(Volume));   %人均出行时间
ave_HC_T_k2=sum(sum(Volume.*HC_T_k2))/sum(sum(Volume)); %人均换乘等待时间

HC_T_k3=120*HC_k3;             %换乘等待时间   
Total_T_k3=HC_T_k3+Running_T_k3;          %运行时间+换乘时间
ave_total_T_k3=sum(sum(Volume.*Total_T_k3))/sum(sum(Volume));   %人均出行时间
ave_HC_T_k3=sum(sum(Volume.*HC_T_k3))/sum(sum(Volume)); %人均换乘等待时间

%% 叠加停站时间
% n=343;
% 
% waiting_T_k1=zeros(n); waiting_T_k2=zeros(n); waiting_T_k3=zeros(n);
% 
% wait_Time=40;
% 
% for i = 1:n
%     for j =1:n
%        
%         if length(Path_k1{i,j})>3
%             waiting_T_k1(i,j)=(length(Path_k1{i,j})-2)*wait_Time;
%         end
%        
%         if length(Path_k2{i,j})>3
%             waiting_T_k2(i,j)=(length(Path_k2{i,j})-2)*wait_Time;
%         end
%         
%         if length(Path_k1{i,j})>3
%             waiting_T_k3(i,j)=(length(Path_k3{i,j})-2)*wait_Time;
%         end
%         
%     end
% end
%  
% Running_T_k1=waiting_T_k1+Running_T_k1; Running_T_k2=waiting_T_k2+Running_T_k2; Running_T_k3=waiting_T_k3+Running_T_k3;

%% 按照出行距离比例分配客流

TP1=zeros(n); TP2=zeros(n); TP3=zeros(n); %求客流分配比例
theta=2;   %设置参数

Running_T_k1=Running_T_k1.*0.0001;
Running_T_k2=Running_T_k2.*0.0001;
Running_T_k3=Running_T_k3.*0.0001;

for i =1:n
    for j =1:n
        TP1(i,j)=(1/exp(theta*Running_T_k1(i,j)))/((1/exp(theta*Running_T_k1(i,j)))+(1/exp(theta*Running_T_k2(i,j)))+(1/exp(theta*Running_T_k3(i,j)))); 
        TP2(i,j)=(1/exp(theta*Running_T_k2(i,j)))/((1/exp(theta*Running_T_k1(i,j)))+(1/exp(theta*Running_T_k2(i,j)))+(1/exp(theta*Running_T_k3(i,j)))); 
        TP3(i,j)=(1/exp(theta*Running_T_k3(i,j)))/((1/exp(theta*Running_T_k1(i,j)))+(1/exp(theta*Running_T_k2(i,j)))+(1/exp(theta*Running_T_k3(i,j)))); 
    end
end

for i =1:n
    for j = i
        TP1(i,j)=0; 
        TP2(i,j)=0;
        TP3(i,j)=0;
    end
end

%人均出行时间
ave_total_T=...
(sum(sum(Volume.*Total_T_k1.*TP1))+sum(sum(Volume.*Total_T_k2.*TP2))+sum(sum(Volume.*Total_T_k3.*TP3)))/sum(sum(Volume));
%人均换乘等待时间
ave_HC_T=...
(sum(sum(Volume.*HC_T_k1.*TP1))+sum(sum(Volume.*HC_T_k2.*TP2))+sum(sum(Volume.*HC_T_k3.*TP3)))/sum(sum(Volume));


toc