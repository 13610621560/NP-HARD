function  [mubiao,fengxian,xxx]=bianlijisuan1(TTR,ES_pingheng,duan_ES,MSOC,pv_state,state_GP,...
    QL,QG,qie_L,qie_G,fuheshu,PV,PV00,es,es1,es2,es3,shu_NP,state_ES,ES,xxx,fuhehao,LPgailv)
            es0=es;
              es10=es1;
              es20=es2;
              es30=es3;
                    for kk=1:size(state_ES,2)
                    ma=sum(abs(state_ES(:,kk)-[es0,es10,es20,es30]'));
                        if  ma==0
                     soc0=kk;
                        end
                    end
 zong=shu_NP^TTR;  
 zong1=0;
jishu=0;
jishu1=0;
               for ii=1:zong %%TTR=1�ĳ�ʼʱ��
           yushu=ii;    
           chushu=zong;
    for j=1:TTR
        chushu=chushu/shu_NP;
         state_zuhe(j)=ceil(yushu/chushu);
         if mod(yushu,chushu)~=0
         yushu=mod(yushu,chushu);
         else
         yushu=chushu;
         end
    end
                 xulie_qiguang=zeros(1,TTR+1);
                 xulie_qiefuhe=zeros(1,TTR+1);              
            soc=soc0;
             xulie_qiefuhe(1)=1;
             xulie_qiguang(1)=1;   
                 E_f=zeros(1,TTR);
                 p_h1=zeros(1,TTR);
                 p_h2=zeros(1,TTR);
                 p_h3=zeros(1,TTR);
                 p_h4=zeros(1,TTR);
                 p_g1=zeros(1,TTR);
                   gailvJI=1;
             for tt=1:TTR  %%һСʱһСʱ�ж�                
                  T=state_zuhe(tt);
                 for i=1:length(PV)-1%%һ��ע����PV=0�Ŀ�������
                      if QG(xulie_qiguang(tt),i+1)==0
                  if state_GP(i,T)>1
                      gailvJI=gailvJI*pv_state(i,state_GP(i,T),tt);
                  else
                      gailvJI=0;
                  end
                      elseif QG(xulie_qiguang(tt),i+1)==1
                          if state_GP(i,T)~=1
                           gailvJI=0; 
                          end                 
                      end
                  end
                  if QG(xulie_qiguang(tt),5)==1
                        if  state_GP(4,T)~=1
                             gailvJI=0;
                        end
                  elseif QG(xulie_qiguang(tt),5)==0
                        if  state_GP(4,T)~=2
                             gailvJI=0;
                        end
                  end 

 %%新增判断负荷状态是否匹配 QL1、4、2、3
                      if QL(xulie_qiefuhe(tt),2)==0
                  if state_GP(6+length(PV),T)>1 %23号负荷
                      gailvJI=gailvJI*LPgailv;
                  else
                      gailvJI=0;
                  end
                      elseif QL(xulie_qiefuhe(tt),2)==1
                          if state_GP(6+length(PV),T)~=1
                           gailvJI=0; 
                          end                 
                      end
                  
                      if QL(xulie_qiefuhe(tt),3)==0
                  if state_GP(16+length(PV),T)>1 && state_GP(17+length(PV),T)>1 && state_GP(18+length(PV),T)>1 %33、34、35负荷
                      gailvJI=gailvJI*LPgailv*LPgailv*LPgailv;
                  else
                      gailvJI=0;
                  end
                      elseif QL(xulie_qiefuhe(tt),3)==1
                          if state_GP(16+length(PV),T)==1 && state_GP(17+length(PV),T)==1 && state_GP(18+length(PV),T)==1
                            gailvJI=gailvJI;
                          else 
                              gailvJI=0; 
                          end                 
                      end
             
                      if QL(xulie_qiefuhe(tt),4)==0
                  if state_GP(12+length(PV),T)>1 && state_GP(13+length(PV),T)>1 %29、30负荷 放入main
                      gailvJI=gailvJI*LPgailv*LPgailv;
                  else
                      gailvJI=0;
                  end
                      elseif QL(xulie_qiefuhe(tt),4)==1
                          if state_GP(12+length(PV),T)==1 && state_GP(13+length(PV),T)==1
                            gailvJI=gailvJI;
                          else 
                              gailvJI=0; 
                          end                 
                      end
                      
                      if QL(xulie_qiefuhe(tt),5)==0
                  if state_GP(22+length(PV),T)>1 && state_GP(23+length(PV),T)>1 %39、40负荷
                      gailvJI=gailvJI*LPgailv*LPgailv;
                  else
                      gailvJI=0;
                  end
                      elseif QL(xulie_qiefuhe(tt),5)==1
                          if state_GP(22+length(PV),T)==1 && state_GP(23+length(PV),T)==1
                            gailvJI=gailvJI;
                          else 
                              gailvJI=0; 
                          end                 
                      end
                if QL(xulie_qiefuhe(tt),1)==0                
                       gailvJI = gailvJI*LPgailv^length(fuhehao);
                       
                   else
                       gailvJI=0;
                end

                  if soc>0
                for i=1:size(state_ES,1)-1
                     if ES(i)==0&&state_ES(i+1,soc)~=1
                        gailvJI=0;
                     elseif ES(i)~=0&&state_ES(i+1,soc)==1
                        gailvJI=0;
                     end
                end
                  end
             if xulie_qiefuhe(tt)<size(QL,1)
           xulie_qiefuhe(tt+1)=qie_L(T,soc,tt,xulie_qiefuhe(tt),xulie_qiguang(tt));
           xulie_qiguang(tt+1)=qie_G(T,soc,tt,xulie_qiefuhe(tt),xulie_qiguang(tt));   
                  
                 if MSOC(T,soc,tt,xulie_qiefuhe(tt+1),xulie_qiguang(tt+1))~=10^10
                    
                     if MSOC(T,soc,tt,xulie_qiefuhe(tt+1),xulie_qiguang(tt+1))~=0
                 soc=MSOC(T,soc,tt,xulie_qiefuhe(tt+1),xulie_qiguang(tt+1));  
                  paixu(tt)= state_ES(1,soc);
                      if state_ES(1,soc)/(ES_pingheng/duan_ES)>=...
                               0.8||state_ES(1,soc)/(ES_pingheng/duan_ES)<=0.2
                     p_h3(tt)= 1;        
                      end 
                     else
                  paixu(tt)= 0;
                     end
                 else
                     soc=10^10;
                     gailvJI=0;
                 end

              if   QG(xulie_qiguang(tt+1),1)==1
                   E_f(tt) =0;
              else
                  E_f(tt) = huifu(fuheshu,QL(xulie_qiefuhe(tt+1),:)-QL(1,:));
              end
 
                   if xulie_qiefuhe(tt+1)>1
                     p_h1(tt) =1;
                   end
                   if QL(xulie_qiefuhe(tt+1),1)~=1
                   if sum(QG(xulie_qiguang(tt+1),2:4).*PV00(1:3))>=0.5*sum(PV00(1:3))
                     p_h2(tt)=1;
                   end
                   else
                      p_h2(tt)=1; 
                   end
                   if QG(xulie_qiguang(tt+1),5)==0&&QL(xulie_qiefuhe(tt+1),1)~=1
                     p_h4(tt) =1;
                    end
                   if QG(xulie_qiguang(tt+1),1)==1||QL(xulie_qiefuhe(tt+1),1)==1
                     p_g1(tt) =1;
                   end

           else
           xulie_qiefuhe(tt+1)=xulie_qiefuhe(tt);
           xulie_qiguang(tt+1)=xulie_qiguang(tt);
            E_f(tt) = 0;
            if tt>1
            p_h1(tt) =p_h1(tt-1);
            p_h2(tt) =p_h2(tt-1);
            p_h3(tt) =p_h3(tt-1);
            p_h4(tt) =p_h4(tt-1);
            p_g1(tt) =p_g1(tt-1);
            end
             end
             end
        
             if gailvJI>0
                 zong1=zong1+1;
                 gailvJI1(zong1)=gailvJI;
             paixu(TTR+1)=gailvJI;
             xxx=[xxx;paixu];
             jishu=jishu+gailvJI;
             if paixu(1)~=0
                 jishu1=jishu1+gailvJI;
             end
             E_f0(zong1)=sum(E_f);
              p_h10(zong1)=(1-prod(ones(1,TTR)-p_h1));
             p_h20(zong1)=(1-prod(ones(1,TTR)-p_h2));
             if paixu(1)~=0
             p_h30(zong1)=(1-prod(ones(1,TTR)-p_h3));
             end
             p_h40(zong1)=(1-prod(ones(1,TTR)-p_h4));
             p_g10(zong1)=(1-prod(ones(1,TTR)-p_g1));
             end
               end

       mubiao=0;
       fengxian=zeros(5,1);
               for i=1:zong1%%TTR=1�ĳ�ʼʱ��
                mubiao=mubiao+E_f0(i)*gailvJI1(i)/jishu;
                fengxian(1)=fengxian(1)+p_h10(i)*gailvJI1(i)/jishu;
                fengxian(2)=fengxian(2)+p_h20(i)*gailvJI1(i)/jishu;
                fengxian(3)=fengxian(3)+p_h30(i)*gailvJI1(i)/jishu;
                fengxian(4)=fengxian(4)+p_h40(i)*gailvJI1(i)/jishu;
                fengxian(5)=fengxian(5)+p_g10(i)*gailvJI1(i)/jishu;
               end
