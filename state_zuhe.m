shu_PV=ceil(PV/duan_PV)+ones(1,length(PV));%%每个光伏状态总数,状态含0
if PV(4)~=0
  shu_PV(4)=2;
end
shu_pingheng=ceil(ES_pingheng/duan_ES);%% 平衡节点储能状态总数
shu_ES=ceil(ES/duan_ES)+ones(1,length(ES));%%每个储能状态总数
for i=1:length(LP)
    for j=1:24
duan_LP(i,j)=LP(i,j)*duanLPshu;
    end
end
for i=1:length(weizhi_LP(:,1))
    if LP(weizhi_LP(i,1),1)~=0
        if i~=QF_LP
         shu_LP(i)=ceil(LP(weizhi_LP(i,1),1)/duan_LP(weizhi_LP(i,1),1))+ones;
        else
            shu_LP(i)=2;
        end
    else
        shu_LP(i)=1;
end
end
 fuhehao = find(shu_LP == 2);
Pr_pingheng=ES_pingheng/2;
Pr=ES/2;
shu_NP=1;
for i=1:length(weizhi_LP(:,1))
shu_NP=shu_NP*shu_LP(i);
end
for i=1:length(weizhi_PV)
shu_NP=shu_NP*shu_PV(i);
end
state_GP=zeros(length(weizhi_PV)+length(weizhi_LP(:,1)),shu_NP);%%考虑源荷不确定性时

for i=1:length(weizhi_ES)
shu_pingheng=shu_pingheng*shu_ES(i);
end
state_ES=zeros(1+length(weizhi_ES),shu_pingheng);%%考虑储能不确定性时
for i=1:shu_NP%%将每个组合转化各个源荷状态
           yushu=i;    
           chushu=shu_NP;
    for j=1:length(weizhi_PV)
        chushu=chushu/shu_PV(j);
         state_GP(j,i)=ceil(yushu/chushu);
         if mod(yushu,chushu)~=0
         yushu=mod(yushu,chushu);
         else
         yushu=chushu;
         end
    end
    for j=1:length(weizhi_LP(:,1))
        chushu=chushu/shu_LP(j);
         state_GP(j+length(weizhi_PV),i)=ceil(yushu/chushu);
          if mod(yushu,chushu)~=0
         yushu=mod(yushu,chushu);
         else
         yushu=chushu;
         end
         if any(j == QF_LP)&&shu_LP(j)~=1
            state_GP(j+length(weizhi_PV),i)= state_GP(j+length(weizhi_PV),i)+1;%QF直控负荷只有2，3两个状态，无切除状态
        end
    end
end
for i=1:shu_pingheng%%将每个组合转化各个储能状态
               yushu=i;    
          chushu=shu_pingheng/ceil(ES_pingheng/duan_ES);
         state_ES(1,i)=ceil(yushu/chushu);
          if mod(yushu,chushu)~=0
         yushu=mod(yushu,chushu);
         else
         yushu=chushu;
         end
    for j=1:length(weizhi_ES)
        chushu=chushu/shu_ES(j);
         state_ES(j+1,i)=ceil(yushu/chushu);
          if mod(yushu,chushu)~=0
         yushu=mod(yushu,chushu);
         else
         yushu=chushu;
         end
    end
end