%==========================================================================
% ·������
% ���пɵû���·������
% ��Ҫ�������������������� �õ�·����վ-��-Ȩ���� ��
%==========================================================================
%% ����ʼ�����Ŀ�ĵ�
% O=input('O=');
% D=input('D=');
% O=7;
% D=12;
% %==========================================================================

%% ����for K��·�㷨
%==========================================================================
% ��1
% Road_Net =[
%     0     3     2   Inf   Inf   Inf   Inf   Inf   Inf
%     3     0   Inf     1     3   Inf   Inf   Inf     2
%     2   Inf     0   Inf     2   Inf   Inf   Inf   Inf
%     Inf     1   Inf     0   Inf     3   Inf   Inf   Inf
%     Inf     3     2   Inf     0     4     3   Inf   Inf
%     Inf   Inf   Inf     3     4     0   Inf   Inf   Inf
%     Inf   Inf   Inf   Inf     3   Inf     0     2   Inf
%     Inf   Inf   Inf   Inf   Inf   Inf     2     0   Inf
%     Inf     2   Inf   Inf   Inf   Inf   Inf   Inf     0];
% zhan=[1 2 3 4 5 6 7 8 9];                                                   %վ����
% xian=[1 2 3 4 5 6];                                                         %��·����
% xian_zhan={[1 2 4 6],[1 3 5 7 8],[9 2 5 6],[6 4 2 1],[8 7 5 3 1],[6 5 2 9]};%��·������Щվ
% ==========================================================================

% ��2
%==========================================================================
Road_Net =[
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
zhan=[1 2 3 4 5 6 7 8 9 10 11 12 13];                                       %վ����
xian=[1 2 3 4 5 6];                                                         %��·����
xian_zhan={[1 2 3 6 9 8 7 4],[10 4 5 6 11],[12 2 5 8 13],[4 7 8 9 6 3 2 1],...
    [11 6 5 4 10],[13 8 5 2 12]};                                           %��·������Щվ,ע��Ҫ��roadnet��Ӧ����,�����·��ʼ��վ���յ�վֱ����������Ϊ���ߡ�
%==========================================================================
Cost_of_Transfer=2;
H=0.0001;
a=0;
Kmax=inf;
%==========================================================================