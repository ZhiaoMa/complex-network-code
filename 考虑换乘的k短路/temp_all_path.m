%%һЩ����
%���㻻�˵ȴ�ʱ��ķ���Ƶ�ʹ̶�(����ֻ��߷��ڣ�
%��������ʱ�����

%% ȫ���ڽӾ�����Ϣ
clear
clc

n=343;   a=zeros(n);
A=xlsread('F:\��������\����\���ݱ�\Beijinghalf.xlsx','2019');

for m = 1:length(A)         %�ڽӾ���
    a(A(m,1),A(m,2))=A(m,5);
end

A=a+a'; A(A==0)=inf; A([1:n+1:n^2])=0;

% ��_վ��Ϣ������׼��-վ����343��-��·����24��
Three_St=[];             %����վ��ǰ�к�����վ
huan_cheng=[8	9	12	13	17	18	20	21	23	305	39	24	26	28	29	31	33	36	42	46	49	52	55	57	59	77	74	72	67	65	63	61	259	82	84	87	89	90	120	285	137	317	97	101	107	109	287	118	117	112	280	122	151	146	140	132	130	160	125	164	172
];  %����վ��Ϣ
HC_temp=0;               %��OD���˴���
HC=zeros(n);                   %�ܻ��˴�������
Judge=[];                %�ж��߼�
Total_T=[];              %���ǻ��˵��ܳ���ʱ��
load BJ2019_xian_zhan;      %��·վ�������ϵ
load xian_HC_Time  %��·�任������ʱ��
% Headway=[120	150	120	150	120	180	210	150	300	120	120	120	120	210	180	480	120	180	180	300	360	420	480	510]; %��·�������(�߷�)
% Headway=[240	360	270	180	240	360	360	360	360	210	240	210	180	360	300	480	360	480	420	480	480	600	690	600]; %��·�������(ƽ��)
Headway=[180	255	195	165	180	270	285	255	330	165	180	165	150	285	240	480	240	330	300	390	420	510	585	555]; %��·�������(ƽ��)
%% ��������
% Volume=zeros(n);
% v=xlsread('C:\Users\hp\Desktop\20200106ȫ�����','0-24');
% for m = 1:length(v)
%     Volume(v(m,1),v(m,2))=v(m,3);
% end 
load Volume
%% ������������·��Path������ʱ��
[Running_T_k1,R] = all_shortest_paths(sparse(A));  

%��ȥ�׸�ͣվʱ��
for i = 1:n
    for j = 1:n
        if i~=j
         Running_T_k1(i,j)=Running_T_k1(i,j)-40;
        end
    end
end

%all_shortest_paths����
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
%% k��·��·����ʱ��

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

%��ȥ�׸�ͣվʱ��
for i = 1:n
    for j = 1:n
        if i~=j
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

%��ȥ�׸�ͣվʱ��
for i = 1:n
    for j = 1:n
        if i~=j
         Running_T_k3(i,j)=Running_T_k3(i,j)-40;
        end
    end
end

%% Ѱ�һ��˴�����λ��

HC_k1=zeros(n);
HC_location_k1=cell(n);

%���·
for i = 1:n
    for j = 1:n
       B=Path_k1{i,j};                                %��ʱ�洢·��
        for k =2:length(B)-1               %��������β��վ
             if ismember(B(k),huan_cheng)==1       %�Ƿ��ǻ���վ
                 Three_St=[B(k-1),B(k),B(k+1)];    %��¼����վ��ǰ���վ��         
                 
                 for t =1:length(xian_zhan)   %�жϻ���ǰ����·
                     Judge=ismember(Three_St,cell2mat(xian_zhan(1,t)));       
                     if Judge == [1 1 0]
                         HC_location_k1{i,j}= [HC_location_k1{i,j} t];%��¼���˷�����λ��
                         HC_temp=HC_temp+0.5;   %��¼���˴���������վÿ����վ����һ���ߣ�һ�λ���������·����
                     end                          
                 end                        

                 for t =1:length(xian_zhan)   %�жϻ��˺����·
                     Judge=ismember(Three_St,cell2mat(xian_zhan(1,t)));                   
                     if Judge == [0 1 1]
                         HC_location_k1{i,j}= [HC_location_k1{i,j} t];%��¼���˷�����λ��
                         HC_temp=HC_temp+0.5;   %��¼���˴���������վÿ����վ����һ���ߣ�һ�λ���������·����
                     end   
                 end  
                 
             end
        end
        HC_k1(i,j)=HC_temp; HC_temp=0;  %��¼���˴�������ʼ����ʱ����
    end
end

%k=2
HC_k2=zeros(n);
HC_location_k2=cell(n);

for i = 1:n
    for j = 1:n
       B=Path_k2{i,j};                                %��ʱ�洢·��
        for k =2:length(B)-1               %��������β��վ
             if ismember(B(k),huan_cheng)==1       %�Ƿ��ǻ���վ
                 Three_St=[B(k-1),B(k),B(k+1)];    %��¼����վ��ǰ���վ��         
                 
                 for t =1:length(xian_zhan)   %�жϻ���ǰ����·
                     Judge=ismember(Three_St,cell2mat(xian_zhan(1,t)));       
                     if Judge == [1 1 0]
                         HC_location_k2{i,j}= [HC_location_k2{i,j} t];%��¼���˷�����λ��
                         HC_temp=HC_temp+0.5;   %��¼���˴���������վÿ����վ����һ���ߣ�һ�λ���������·����
                     end                          
                 end                        

                 for t =1:length(xian_zhan)   %�жϻ��˺����·
                     Judge=ismember(Three_St,cell2mat(xian_zhan(1,t)));                   
                     if Judge == [0 1 1]
                         HC_location_k2{i,j}= [HC_location_k2{i,j} t];%��¼���˷�����λ��
                         HC_temp=HC_temp+0.5;   %��¼���˴���������վÿ����վ����һ���ߣ�һ�λ���������·����
                     end   
                 end  
                 
             end
        end
        HC_k2(i,j)=HC_temp; HC_temp=0;  %��¼���˴�������ʼ����ʱ����
    end
end

%k=3
HC_k3=zeros(n);
HC_location_k3=cell(n);

for i = 1:n
    for j = 1:n
       B=Path_k3{i,j};                                %��ʱ�洢·��
        for k =2:length(B)-1               %��������β��վ
             if ismember(B(k),huan_cheng)==1       %�Ƿ��ǻ���վ
                 Three_St=[B(k-1),B(k),B(k+1)];    %��¼����վ��ǰ���վ��         
                 
                 for t =1:length(xian_zhan)   %�жϻ���ǰ����·
                     Judge=ismember(Three_St,cell2mat(xian_zhan(1,t)));       
                     if Judge == [1 1 0]
                         HC_location_k3{i,j}= [HC_location_k3{i,j} t];%��¼���˷�����λ��
                         HC_temp=HC_temp+0.5;   %��¼���˴���������վÿ����վ����һ���ߣ�һ�λ���������·����
                     end                          
                 end                        

                 for t =1:length(xian_zhan)   %�жϻ��˺����·
                     Judge=ismember(Three_St,cell2mat(xian_zhan(1,t)));                   
                     if Judge == [0 1 1]
                         HC_location_k3{i,j}= [HC_location_k3{i,j} t];%��¼���˷�����λ��
                         HC_temp=HC_temp+0.5;   %��¼���˴���������վÿ����վ����һ���ߣ�һ�λ���������·����
                     end   
                 end  
                 
             end
        end
        HC_k3(i,j)=HC_temp; HC_temp=0;  %��¼���˴�������ʼ����ʱ����
    end
end

%% �����ܳ���ʱ��=���˵ȴ�ʱ��+��������ʱ��+�г�����ʱ��

% HC_T_k1=120*HC_k1;  HC_T_k2=120*HC_k2;  HC_T_k3=120*HC_k3;   %���˵ȴ�ʱ��               

HC_wait_k1=zeros(n);   HC_walk_k1=zeros(n); 
for i = 1:n
    for j = 1:n
        tempHC = HC_location_k1{i,j};
        for k = 1:2:length(tempHC)-1
            HC_walk_k1(i,j) = HC_walk_k1(i,j)+xian_HC_Time(tempHC(k),tempHC(k+1)); %��������ʱ��
            HC_wait_k1(i,j) = HC_wait_k1(i,j)+0.5*Headway(tempHC(k+1)); %�������һ��ĵȴ�ʱ��
        end
    end
end

HC_wait_k2=zeros(n);   HC_walk_k2=zeros(n); 
for i = 1:n
    for j = 1:n
        tempHC = HC_location_k2{i,j};
        for k = 1:2:length(tempHC)-1
            HC_walk_k2(i,j) = HC_walk_k2(i,j)+xian_HC_Time(tempHC(k),tempHC(k+1)); %��������ʱ��
            HC_wait_k2(i,j) = HC_wait_k2(i,j)+0.5*Headway(tempHC(k+1)); %�������һ��ĵȴ�ʱ��
        end
    end
end

HC_wait_k3=zeros(n);   HC_walk_k3=zeros(n); 
for i = 1:n
    for j = 1:n
        tempHC = HC_location_k1{i,j};
        for k = 1:2:length(tempHC)-1
            HC_walk_k3(i,j) = HC_walk_k3(i,j)+xian_HC_Time(tempHC(k),tempHC(k+1)); %��������ʱ��
            HC_wait_k3(i,j) = HC_wait_k3(i,j)+0.5*Headway(tempHC(k+1)); %�������һ��ĵȴ�ʱ��
        end
    end
end

HC_T_k1 = HC_walk_k1 + HC_wait_k1;  %������ʱ��
HC_T_k2 = HC_walk_k2 + HC_wait_k2;
HC_T_k3 = HC_walk_k3 + HC_wait_k3;

Total_T_k1 = HC_T_k1 + Running_T_k1 - 40*HC_k1;     %����ʱ��+��������ʱ��+���˵ȴ�ʱ��-������Ļ��˴���*ͣվʱ��
Total_T_k2 = HC_T_k2 + Running_T_k2 - 40*HC_k2;
Total_T_k3 = HC_T_k3 + Running_T_k3 - 40*HC_k3;  

%% ����1.5�����·�����ȵ�����ɾ��

%�ϸ�����ʱ��1��=2��=3
temp_Total_T=0;
temp_HC=0;
temp_HC_T=0;
temp_HC_walk=0;
temp_HC_wait=0;
temp_Path=0;
temp_Running_T=0;


for i = 1:n
    for j = 1:n
        if Total_T_k1(i,j) > Total_T_k2(i,j)
          
            temp_Total_T=Total_T_k1(i,j);
           Total_T_k1(i,j)=Total_T_k2(i,j);
           Total_T_k2(i,j)=temp_Total_T;
           
            temp_HC=HC_k1(i,j);
           HC_k1(i,j)=HC_k2(i,j);
           HC_k2(i,j)=temp_HC;
                     
            temp_HC_T=HC_T_k1(i,j);
           HC_T_k1(i,j)=HC_T_k2(i,j);
           HC_T_k2(i,j)=temp_HC_T;
           
            temp_HC_walk=HC_walk_k1(i,j);
           HC_walk_k1(i,j)=HC_walk_k2(i,j);
           HC_walk_k2(i,j)=temp_HC_walk;
           
            temp_HC_wait=HC_wait_k1(i,j);
           HC_wait_k1(i,j)=HC_wait_k2(i,j);
           HC_wait_k2(i,j)=temp_HC_wait;
                           
            temp_Path=Path_k1(i,j);
           Path_k1(i,j)=Path_k2(i,j);
           Path_k2(i,j)=temp_Path;
                       
            temp_Running_T=Running_T_k1(i,j);
           Running_T_k1(i,j)=Running_T_k2(i,j);
           Running_T_k2(i,j)=temp_Running_T;
           
        end
    end
end

for i = 1:n
    for j = 1:n
        if Total_T_k2(i,j) > Total_T_k3(i,j)
          
            temp_Total_T=Total_T_k2(i,j);
           Total_T_k2(i,j)=Total_T_k3(i,j);
           Total_T_k3(i,j)=temp_Total_T;
           
            temp_HC=HC_k2(i,j);
           HC_k2(i,j)=HC_k3(i,j);
           HC_k3(i,j)=temp_HC;
                     
            temp_HC_T=HC_T_k2(i,j);
           HC_T_k2(i,j)=HC_T_k3(i,j);
           HC_T_k3(i,j)=temp_HC_T;
           
            temp_HC_walk=HC_walk_k2(i,j);
           HC_walk_k2(i,j)=HC_walk_k3(i,j);
           HC_walk_k3(i,j)=temp_HC_walk;
           
            temp_HC_wait=HC_wait_k2(i,j);
           HC_wait_k2(i,j)=HC_wait_k3(i,j);
           HC_wait_k3(i,j)=temp_HC_wait;
                      
            temp_Path=Path_k2(i,j);
           Path_k2(i,j)=Path_k3(i,j);
           Path_k3(i,j)=temp_Path;
                       
            temp_Running_T=Running_T_k2(i,j);
           Running_T_k2(i,j)=Running_T_k3(i,j);
           Running_T_k3(i,j)=temp_Running_T;
           
        end
    end
end

for i = 1:n
    for j = 1:n
        if Total_T_k1(i,j) > Total_T_k2(i,j)
          
            temp_Total_T=Total_T_k1(i,j);
           Total_T_k1(i,j)=Total_T_k2(i,j);
           Total_T_k2(i,j)=temp_Total_T;
           
            temp_HC=HC_k1(i,j);
           HC_k1(i,j)=HC_k2(i,j);
           HC_k2(i,j)=temp_HC;
                     
            temp_HC_T=HC_T_k1(i,j);
           HC_T_k1(i,j)=HC_T_k2(i,j);
           HC_T_k2(i,j)=temp_HC_T;
             
           temp_HC_walk=HC_walk_k1(i,j);
           HC_walk_k1(i,j)=HC_walk_k2(i,j);
           HC_walk_k2(i,j)=temp_HC_walk;
                       
           temp_HC_wait=HC_wait_k1(i,j);
           HC_wait_k1(i,j)=HC_wait_k2(i,j);
           HC_wait_k2(i,j)=temp_HC_wait;
                      
            temp_Path=Path_k1(i,j);
           Path_k1(i,j)=Path_k2(i,j);
           Path_k2(i,j)=temp_Path;
                       
            temp_Running_T=Running_T_k1(i,j);
           Running_T_k1(i,j)=Running_T_k2(i,j);
           Running_T_k2(i,j)=temp_Running_T;
           
        end
    end
end

%k=2
for i = 1:n
    for j = 1:n
        if Total_T_k2(i,j) > 1.5*Total_T_k1(i,j)
           
            Total_T_k2(i,j) = Total_T_k1(i,j);
            HC_k2(i,j)=HC_k1(i,j);
            HC_T_k2(i,j)=HC_T_k1(i,j);
            HC_walk_k2(i,j)=HC_walk_k1(i,j);
            HC_wait_k2(i,j)=HC_wait_k1(i,j);
            Path_k2(i,j)=Path_k1(i,j);
            Running_T_k2(i,j)=Running_T_k1(i,j);
            
        end
    end
end

%k=3
for i = 1:n
    for j = 1:n
        if Total_T_k3(i,j) > 1.5*Total_T_k1(i,j)
           
            Total_T_k3(i,j) = Total_T_k2(i,j);
            HC_k3(i,j)=HC_k2(i,j);
            HC_T_k3(i,j)=HC_T_k2(i,j);
            HC_walk_k3(i,j)=HC_walk_k2(i,j);
            HC_wait_k3(i,j)=HC_wait_k2(i,j);
            Path_k3(i,j)=Path_k2(i,j);
            Running_T_k3(i,j)=Running_T_k2(i,j);
            
        end
    end
end

%% ����k��·ƽ������ʱ��+ƽ������ʱ��+ƽ�����˴���

ave_total_T_k1=sum(sum(Volume.*Total_T_k1))/sum(sum(Volume));   %�˾�����ʱ��
ave_HC_walk_k1=sum(sum(Volume.*HC_walk_k1))/sum(sum(Volume)); %�˾���������ʱ��
ave_HC_wait_k1=sum(sum(Volume.*HC_wait_k1))/sum(sum(Volume)); %�˾����˵ȴ�ʱ��
ave_HC_T_k1=sum(sum(Volume.*HC_T_k1))/sum(sum(Volume)); %�˾�����ʱ��
ave_HC_k1 = sum(sum(Volume.*HC_k1))/sum(sum(Volume)); %�˾����˴���

ave_total_T_k2=sum(sum(Volume.*Total_T_k2))/sum(sum(Volume));   %�˾�����ʱ��
ave_HC_walk_k2=sum(sum(Volume.*HC_walk_k2))/sum(sum(Volume)); %�˾���������ʱ��
ave_HC_wait_k2=sum(sum(Volume.*HC_wait_k2))/sum(sum(Volume)); %�˾����˵ȴ�ʱ��
ave_HC_T_k2=sum(sum(Volume.*HC_T_k2))/sum(sum(Volume)); %�˾�����ʱ��
ave_HC_k2 = sum(sum(Volume.*HC_k2))/sum(sum(Volume)); %�˾����˴���

ave_total_T_k3=sum(sum(Volume.*Total_T_k3))/sum(sum(Volume));   %�˾�����ʱ��
ave_HC_walk_k3=sum(sum(Volume.*HC_walk_k3))/sum(sum(Volume)); %�˾���������ʱ��
ave_HC_wait_k3=sum(sum(Volume.*HC_wait_k3))/sum(sum(Volume)); %�˾����˵ȴ�ʱ��
ave_HC_T_k3=sum(sum(Volume.*HC_T_k3))/sum(sum(Volume)); %�˾�����ʱ��
ave_HC_k3 = sum(sum(Volume.*HC_k3))/sum(sum(Volume)); %�˾����˴���

%% ���ճ�����ʱ������������

TP1=zeros(n); TP2=zeros(n); TP3=zeros(n); %������������
theta=2;   %���ò���

small_Total_T_k1=Total_T_k1.*0.0001;
small_Total_T_k2=Total_T_k2.*0.0001;
small_Total_T_k3=Total_T_k3.*0.0001;


for i =1:n
    for j =1:n
        TP1(i,j)=(1/exp(theta*small_Total_T_k1(i,j)))/((1/exp(theta*small_Total_T_k1(i,j)))+(1/exp(theta*small_Total_T_k2(i,j)))+(1/exp(theta*small_Total_T_k3(i,j)))); 
        TP2(i,j)=(1/exp(theta*small_Total_T_k1(i,j)))/((1/exp(theta*small_Total_T_k1(i,j)))+(1/exp(theta*small_Total_T_k2(i,j)))+(1/exp(theta*small_Total_T_k3(i,j)))); 
        TP3(i,j)=(1/exp(theta*small_Total_T_k1(i,j)))/((1/exp(theta*small_Total_T_k1(i,j)))+(1/exp(theta*small_Total_T_k2(i,j)))+(1/exp(theta*small_Total_T_k3(i,j)))); 
    end
end

for i =1:n
    for j = i
        TP1(i,j)=0; 
        TP2(i,j)=0;
        TP3(i,j)=0;
    end
end

%�˾�����ʱ��
ave_total_T=...
(sum(sum(Volume.*Total_T_k1.*TP1))+sum(sum(Volume.*Total_T_k2.*TP2))+sum(sum(Volume.*Total_T_k3.*TP3)))/sum(sum(Volume));
%�˾���������ʱ��
ave_HC_walk=...
(sum(sum(Volume.*HC_walk_k1.*TP1))+sum(sum(Volume.*HC_walk_k2.*TP2))+sum(sum(Volume.*HC_walk_k3.*TP3)))/sum(sum(Volume));
%�˾����˵ȴ�ʱ��
ave_HC_wait=...
(sum(sum(Volume.*HC_wait_k1.*TP1))+sum(sum(Volume.*HC_wait_k2.*TP2))+sum(sum(Volume.*HC_wait_k3.*TP3)))/sum(sum(Volume));
%�˾�����ʱ��
ave_HC_T=...
(sum(sum(Volume.*HC_T_k1.*TP1))+sum(sum(Volume.*HC_T_k2.*TP2))+sum(sum(Volume.*HC_T_k3.*TP3)))/sum(sum(Volume));
%�˾����˴���
ave_HC=...
(sum(sum(Volume.*HC_k1.*TP1))+sum(sum(Volume.*HC_k2.*TP2))+sum(sum(Volume.*HC_k3.*TP3)))/sum(sum(Volume));

%% ��ͼ

%�������������·��
Volume_k1=Volume.*TP1; Volume_k2=Volume.*TP2; Volume_k3=Volume.*TP3;
%ת������
Volume_k1=Volume_k1(:); Volume_k2=Volume_k2(:); Volume_k3=Volume_k3(:);
Total_T_k1=Total_T_k1(:); Total_T_k2=Total_T_k2(:); Total_T_k3=Total_T_k3(:);
HC_k1=HC_k1(:); HC_k2=HC_k2(:); HC_k3=HC_k3(:);
HC_T_k1=HC_T_k1(:); HC_T_k2=HC_T_k2(:); HC_T_k3=HC_T_k3(:);

%�����ֲ�
x=4:0.25:23.75;
y=[0.0011	0.0008	0.0124	0.0859	0.4136	0.6964	1.3728	2.2283	3.5746	5.5461	8.3503	12.0685	16.1151	20.0955	24.2713	27.9375	27.6352	25.0781	21.4375	18.3254	15.8668	13.4512	10.7985	8.505	6.9326	6.2426	5.6253	5.3512	5.1841	5.1739	5.2822	5.2988	5.4788	5.5733	5.3728	5.4495	5.3202	5.3266	5.2904	5.2658	5.196	5.242	5.1817	5.1291	5.3737	5.6418	5.9687	6.2394	6.7325	7.1221	7.9964	8.8233	13.8926	16.12	18.2735	20.136	19.1963	21.3019	16.6469	14.6748	12.3918	11.3493	9.4009	8.0707	7.768	7.4313	6.845	5.97	6.1777	6.0154	4.9795	4.0858	3.9583	2.9136	1.6674	0.8964	0.4401	0.1947	0.0721	0.0264
];
plot(x,y)

%���˴���
A=xlsread('C:\Users\HP\Desktop\�������.xlsx','���˴���');
index=0; t=0;d=[];
for i =1:length(A)
 if A(i,1) == index
     t=t+A(i,2);
     d(index+1)=t;
 else
     index = index +1;
     t=A(i,2);
 end
end

x = 0:6;
y1= [1.803151519	1.111430261	0.954889751	1.014203683	0.636406285	0.275030251	0.189731853];
y2 = [0.301286322	0.486993808	0.646545137	0.816007157	0.922343484	0.968297943	1];
yyaxis left
b = bar(x,y1);
yyaxis right
p = plot(x,y2);

%����ʱ��
A=xlsread('C:\Users\HP\Desktop\�������.xlsx','���˵ȴ�ʱ��');
index=0; t=0;d=[];
for i =1:length(A)
 if A(i,1) == index
     t=t+A(i,2);
     d(index+1)=t;
 else
     index = index +1;
     t=A(i,2);
 end
end

X = [2914575.341 954889.7507	1014203.683	636406.2852	275030.2513	189731.8531];
pie(X)

%����ʱ����ʷֲ�
A=xlsread('C:\Users\HP\Desktop\�������.xlsx','�ܳ���ʱ��');

index=5; t=0;d=[];
for i =1:length(A)
 if A(i,1) <= index
     t=t+A(i,2);
     d(index+1)=t;
 else
     index = index +5;
     t=A(i,2);
 end
end
dd=[];
for m = 1:37
    mm=5*m+1;
    dd(end+1)=d(mm);
end

X=[27.85594839	50.82517878	55.64215678	58.73125792	57.11958817	54.3668698	55.74257237	49.68781886	44.45846912	37.13209027	29.49194123	22.65910001	17.11294837	12.38483006	8.697646285	6.017273955	3.917014601	2.318021479	1.461768948	0.947073013	1.914791902
];
bar(X)

%����ʱ���ۼƸ���
A=xlsread('C:\Users\HP\Desktop\�������.xlsx');
x=A(:,1)'; y=A(:,2)'; 
plot(x,y)

%��������ʱ����ά�ֲ�
Z=xian_HC_Time;
width = 1;
b = bar3(Z,width);
colorbar
for k = 1:length(b)
    zdata = b(k).ZData;
    b(k).CData = zdata;
    b(k).FaceColor = 'interp';
end
