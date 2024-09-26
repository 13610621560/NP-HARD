%%����ת���㷨������,�޸���2024��8��7��
clear
SolarData=xlsread('Solar Data.xls','sheet1');%������
SolarData(SolarData>1)=1;
weizhi_PV=[8,30,14,25];%%PV����ڵ�λ��
weizhi_LP=[18 2;19 3;20 4;21 5;22 6; 23 17;24 18;25 10;26 25;27 12;28 13;29 15;30 16;...
    31 19;32 30;33 21;34 22;35 23;36 25;37 31;38 27; 39 28;40 29];%%����ڵ�λ��
weizhi_ES=[18,30,14];%ES����ڵ�λ��
%%����Դ�ɴ��ֶ�״̬��
duan_PV=2;%%ÿ�����״̬�ֶ�������MW
duan_ES=0.5;%%ÿ������״̬�ֶ�������MW
duan_LP=1;%%ÿ������״̬�ֶ�������MW

ES_pingheng=5;
PV00=[8 10 6 2]; 
ES00=[1 1 1];
t=10;%%������ʼʱ��
TTR=4;%%���ϳ���ʱ��
RX=xlsread('RX.xlsx');
%%���ɴ�С
shu_fangan0=10;
mubiao=zeros(1,shu_fangan0);
fengxian=zeros(5,shu_fangan0);
simulation=zeros(1,shu_fangan0);
shoulian=0;
bushoulian=0;
 xxx=[];
 for   fangan=1:shu_fangan0  
     
 
 %%��ƽ��ڵ㴢������
ES=ES00;
PV=PV00; 
LP=xlsread('L24')*2;%%*24
%%��ʼ�����з����ĸ���״̬
fangan_chushihua
%%��ʼ������״̬��ϵĳ���
state_zuhe
%%��ʼ�������ǩ

MPS=zeros(shu_NP,shu_pingheng,TTR,size(QL,1),size(QG,1));
MSOC=zeros(shu_NP,shu_pingheng,TTR,size(QL,1),size(QG,1));
state_fengxian=zeros(shu_NP,shu_pingheng,TTR,size(QL,1),size(QG,1));
for i=1:size(QL,1)-1%%��ʼ����ͬԴ����������µĳ�����������ȫ�в�����
    for j=1:size(QG,1)-1%%��ʼ����ͬԴ����������µĳ�����������ȫ�в�����
      LP0=QL_neirong(QL(i,:),LP);
      PV0=QG_neirong(QG(j,:),PV);
     [MPS(:,:,:,i,j),MSOC(:,:,:,i,j),state_fengxian(:,:,:,i,j)]=chushihua_qiantui(shu_NP,state_GP,state_ES,PV0,ES,Pr...
    ,LP0,weizhi_PV,weizhi_LP,weizhi_ES,shu_PV,shu_ES,shu_LP,t,TTR,RX,shu_pingheng,ES_pingheng,Pr_pingheng,duan_ES);
    end
end

qie_L=zeros(shu_NP,shu_pingheng,TTR,length(QL00)-sum(QL00),length(QG00)-sum(QG00));
qie_G=zeros(shu_NP,shu_pingheng,TTR,length(QL00)-sum(QL00),length(QG00)-sum(QG00));
for i=1:size(QL,1)%%�����������״̬�µ�ϵͳ�ȶ�����״̬
 for j=1:size(QG,1)
    [qie_L(:,:,:,i,j),qie_G(:,:,:,i,j)]=wendingzhuangtai(MPS,shu_pingheng,shu_NP,t,TTR,i,j,QL,QG);
 end
end

%��������״̬����
   [pv_state]=changjinggailv(SolarData,PV,shu_PV,duan_PV,t,TTR);
    %%��ʼϵͳ������SOC    
            for kk=1:shu_pingheng
              if  sum(abs(state_ES(:,kk)-[ceil(ES_pingheng/duan_ES)/2,ceil(ES/duan_ES)/2+1]'))==0
                     soc=kk;
              end
            end
 %%ͳ�Ʒ���ʱ��1   
 haoshi1=clock;
 [mubiao(fangan),fengxian(:,fangan),xxx]=diguijisuan(ES,soc,TTR,shu_pingheng,MSOC...
     ,pv_state,state_GP,QL,QG,qie_L,qie_G,fuheshu,PV,PV00,ES_pingheng,duan_ES,state_ES,xxx);
%%ͳ�Ʒ���ʱ��
xxx=[xxx;zeros(1,TTR+1)];
haoshi2=clock;
simulation(fangan)=etime(haoshi2,haoshi1);
 end
 jieguo=[simulation; roundn(mubiao,-2); roundn(fengxian*100,-2)];
 