% clc; clear all; close all;
%% SVM alfa beta
function svm=absvm(xp)
% % alfa=[1 0; 2 1];
% % beta=[0 0; 0 1; 1 1];
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %APRENDIZAJE
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% a=0;
% % for f=1:148 %Para el LOO
X=csvread('basehu1.csv');
X=X(240:400,:);
% % X=X(:,2:183);
% % X=[0 1 0 1 0 1 1 1 1; 0 1 0 1 1 1 1 1 1; ...
% %    0 1 1 1 1 1 0 1 1; 1 1 0 1 0 1 1 1 1; ...
% %    1 1 1 1 0 1 0 1 1; 0 1 1 1 0 1 1 1 1;
% %    0 1 0 1 1 1 0 1 1];
[h, w]=size(X); %p=h  i=w
% % %% Patron prueba para la tasa de ruido soportada
% % xp=X(f,:);
% % strrep(num2str(xp),' ','');
% % ruido=randerr(1,length(xp),[1,50]);
% % xp=xor(xp,ruido);
% 
% % %% Para el LOO
% % for g=1:147
% %     if g==f
% %     X(g,:)=X(g,:);
% %     end
% % end
% % xp=X(f,:);
% 
% %% Vector de soporte del conjunto
% S=zeros(1,w);
% for i=1:w
%     for j=2:2:h        
%         if j>2
%             minimo=beta(X(j-1,i),X(j,i));
%             S(i)=min(S(i),minimo);
%         else
%             S(i)=beta(X(j-1,i),X(j,i));   
%         end
%     end
% end
% sum(S)
% %% Restriccion de los patrones por S
% sigma=sum(S);
% Xr=zeros(h,w-sigma);
% k=1;
% for i=1:w
%     if S(i)==0
%         Xr(:,k)=X(:,i);
%         k=k+1;
%     end
% end
% %% Vector de soporte del conjunto negado
% Xn=not(X);
% Sn=zeros(1,w);
% for i=1:w
%     for j=2:2:h
%         if j>2
%             minimo=beta(Xn(j-1,i),Xn(j,i));
%             Sn(i)=min(Sn(i),minimo);
%         else
%             Sn(i)=beta(Xn(j-1,i),Xn(j,i));   
%         end
%     end
% end
% sum(Sn)
% %% Restriccion de los patrones por Sn
% sigma=sum(Sn);
% Xrn=zeros(h,w-sigma);
% k=1;
% for i=1:w
%     if Sn(i)==0
%         Xrn(:,k)=Xn(:,i);
%         k=k+1;
%     end
% end
S=csvread('S.csv');
Xr=csvread('Xr.csv');
Sn=csvread('Sn.csv');
Xrn=csvread('Xrn.csv');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%RECUPERACION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Restriccion del patron ruidoso
sigma=sum(S);
xpr=zeros(1,w-sigma);
k=1;
for i=1:w
    if S(i)==0
        xpr(k)=xp(i);
        k=k+1;
    end
end

%% Teta de xpr,Xr 
lxpr=length(xpr);
tao1=zeros(1,lxpr);
tao2=zeros(1,lxpr);
teta=zeros(1,h);
for i=1:h    
    for j=1:lxpr
        tao1(j)=beta(xpr(j),alfa(0,Xr(i,j)));
        tao2(j)=beta(Xr(i,j),alfa(0,xpr(j)));  
    end    
    teta(i)=sum(tao1)+sum(tao2);
end
[x, y1]=min(teta);

% %% Restriccion del patron ruidoso negado
% xpn=not(xpr);
% sigma=sum(Sn);
% xprn=zeros(1,w-sigma);
% k=1;
% for i=1:w
%     if Sn(i)==0
%         xprn(k)=xpn(i);
%         k=k+1;
%     end
% end
% 
% %% Teta de xprn,Xrn
% lxprn=length(xprn);
% tao1=zeros(1,lxprn);
% tao2=zeros(1,lxprn);
% teta=zeros(1,h);
% for i=1:h
%     for j=1:lxprn
%         tao1(j)=beta(xprn(j),alfa(0,Xrn(i,j)));
%         tao2(j)=beta(Xrn(i,j),alfa(0,xprn(j)));        
%     end
%     teta(i)=sum(tao1)+sum(tao2);
% end
% [x, y2]=min(teta)
% 
% if y1<=y2
%     y=y1;
% else
%     y=y2;
% end

y=y1;
svm=regresaLetra(y);

% %% Para el LOO
%     if mod(f,2)==1
%         if y==f || y==f+1
%             a=a+1;
%         end
%     elseif mod(f,2)==0
%         if y==f || y==f-1
%         a=a+1;
%         end
%     end
% end
% a
