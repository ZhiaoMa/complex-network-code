%==========================================================================
% 换乘次数
% 被KSP.m调用才可计算
% 主要运算结果【换乘次数、换乘点、换乘区间、换乘路段】
%==========================================================================
KHc_hcd{k}=[];
KHc_hcqj{k}=[];
KHc_hcld_a{k}=[];

%% 直达线路
%==========================================================================
KHc_cishu=2;                              %最大换乘次数
m1=1;
m2=length(KPaths{k});
for j1=1:length(xian_zhan)
    if all(ismember(KPaths{k}(m1:m2),xian_zhan{j1}))
        if find(O==xian_zhan{j1})<find(D==xian_zhan{j1})
            KHc_cishu=0;
            KHc_hcd{k}={[]};
            KHc_hcqj{k}={[]};
            KHc_hcld_a{k}={[]};
        end
    end
end
%==========================================================================

%% 一次换乘
%==========================================================================
for i=2:length(KPaths{k})-1
    for j1=1:length(xian_zhan)
        for j2=1:length(xian_zhan)
            if KHc_cishu~=0
                if all(ismember(KPaths{k}(1:i),xian_zhan{j1})) & all(ismember(KPaths{k}(i:length(KPaths{k})),xian_zhan{j2}))& j1~=j2
                    if find(O==xian_zhan{j1})<find(KPaths{k}(i)==xian_zhan{j1})& find(D==xian_zhan{j2})>find(KPaths{k}(i)==xian_zhan{j1})
                        KHc_cishu=1;
                        KHc_hcd{k}={KPaths{k}(i)};
                        KHc_hcqj{k}={[KPaths{k}(i) KPaths{k}(i+1)]};
                        for a=1:length(luduan_zhan)
                            if [KPaths{k}(i) KPaths{k}(i+1)]==cell2mat(luduan_zhan{a})
                                KHc_hcld_a{k}={a};
                            end
                        end
                    end
                end
            end
        end
    end
end
%==========================================================================

%% 二次换乘
%==========================================================================
for i1=2:length(KPaths{k})-1
    for i2=i1:length(KPaths{k})-1
        for j1=1:length(xian_zhan)
            for j2=1:length(xian_zhan)
                for j3=1:length(xian_zhan)
                    if KHc_cishu~=0&KHc_cishu~=1
                        if all(ismember(KPaths{k}(1:i1),xian_zhan{j1})) & all(ismember(KPaths{k}(i1:i2),xian_zhan{j2}))& all(ismember(KPaths{k}(i2:length(KPaths{k})),xian_zhan{j3}))
                            if j1~=j2 &j2~=j3 &j1~=j3&KPaths{k}(i1)~=KPaths{k}(i2)
                                if(find(O==xian_zhan{j1})<find(KPaths{k}(i1)==xian_zhan{j1}))  & find(KPaths{k}(i1)==xian_zhan{j2})<find(KPaths{k}(i2)==xian_zhan{j2}) &  find(D==xian_zhan{j3})>find(KPaths{k}(i2)==xian_zhan{j3})
                                    KHc_cishu=2;
                                    KHc_hcd{k}={KPaths{k}(i1) KPaths{k}(i2)};
                                    KHc_hcqj{k}={[KPaths{k}(i1) KPaths{k}(i1+1)];[KPaths{k}(i2) KPaths{k}(i2+1)]};
                                    for a1=1:length(luduan_zhan)
                                        for a2=1:length(luduan_zhan)
                                            if [KPaths{k}(i1) KPaths{k}(i1+1)]==cell2mat(luduan_zhan{a1})&[KPaths{k}(i2) KPaths{k}(i2+1)]==cell2mat(luduan_zhan{a2})
                                                KHc_hcld_a{k}={a1 a2};
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end
%==========================================================================