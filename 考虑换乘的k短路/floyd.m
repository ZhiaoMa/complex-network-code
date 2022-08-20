function [D,path,min1,path1]=floyd(a,start,terminal)
%D(i,j)��ʾi��j�����·����path(i,j)��ʾi��j֮������·���϶���i�ĺ�̵㡣
%min1����start��terminal֮�����̾��룬path1����start��terminal֮������·��
%aΪ��Ȩ�ڽӾ���start��terminal�ֱ�����ʼ�����ֹ��

D=a;n=size(D,1);path=zeros(n,n);
%nΪ�������������D��path����

%����һ����󣬳�ʼ��path�����Ƚ�����ֱ�������ĵ��path���в���
for i=1:n
    for j=1:n
        if D(i,j)~=inf
            path(i,j)=j;
        end  
    end
end

%���ر����������Ƿ����м̵����ʹ��·�����̣����������D��path����
for k=1:n
    for i=1:n
        for j=1:n
            if D(i,k)+D(k,j)<D(i,j)
                D(i,j)=D(i,k)+D(k,j);
                path(i,j)=path(i,k);
            end 
        end
    end
%������ʾ��ÿһ���ĵ�������
% k,D,path
end

%�ж���������Ƿ�Ϊ����
if nargin==3
    min1=D(start,terminal);
    m(1)=start;
    i=1;
    path1=[ ];   
    %����path·��һ��һ����ת�ҵ�����·��������path1
    while   path(m(i),terminal)~=terminal
        k=i+1;                                
        m(k)=path(m(i),terminal);
        i=i+1;
    end
    m(i+1)=terminal;
    path1=m;
end   


