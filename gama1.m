function Clase=gama1(x,xf,xc,y,yc,p,patxclase,nclases)
% close all; clear all; clc;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Clasificador Gamma Mejorado
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% x=conjunto fundamental
% xf= numero de filas del conjunto fundamental
% xc= numero de columnas del conjunto fundamental
% y= patron a clasificar
% patxclase= numero de patrones por clase
% nclases= numero de clases en el conjunto fundamental
% % % % % % % % % % % % % % % % % % % % %
% Solo se escalan los patrones del conjunto fundamental hasta que sean
% enteros positivos.
% Teta se puede tomar como el numero de diferencias permitidas entre el 
% patron que se clasifica y los del conjunto fundamental, cuyo limite
% es el parametro de paro p.
% El parametro de paro p se puede ampliar para reducir ambiguedad, el
% efecto que tiene es ampliar el espacio "de prueba"
% Se hace una resta para reducir el tiempo de operacion.

% format long;
% % % confun=csvread('basehu.csv');
% % % patclas=csvread('basehu.csv');
% % % x=confun(:,1:size(confun,2)-1);
% % % y=patclas(4,1:size(patclas,2)-1);
% % % nclases=102;
% % % ndec=6;
% % % patxclase=1;

% dimensiones, elementos minimos del conjunto fundamental
% xf=size(x,1);
% xc=size(x,2);
% m=min(x);

% dimensiones del vector a clasificar
% yf=size(y,1);
% yc=size(y,2);

% Clase=zeros(1,1);

% %% convertir los patrones a numeros enteros
% % % [X]= dec2ent(xf,xc,m,x,ndec);
% % % [Y]= dec2ent(1,yc,m,y,ndec);
% % % p=min(max(X));

%% comparar vectoresClase=zeros(1,fy);

teta=0;

while(teta<p)
    C=zeros(1,xf); %almacena numero de elementos iguales entre x y y
    maxunico=0;
    for fxf=1:xf            
        for cxc=1:xc
%                 [abs(y(1,cxc)-x(fxf,cxc)) teta fxf]
            if (abs(y(1,cxc)-x(fxf,cxc))<=teta)                    
                C(1,fxf)=C(1,fxf)+1;
            end
        end
    end
%%  sumas ponderadas
    Sumpon=zeros(1,nclases);
%             Cardclase=zeros(1,nclases);
    for npatxclases=0:patxclase-1
        for fx=1:xf
            for clase=1:nclases                
                if (fx-(nclases*npatxclases)==clase)
%                     [fx clase*npatxclases]
                    Sumpon(1,clase)=Sumpon(1,clase)+C(1,fx);
    %                         Cardclase(1,clase)=Cardclase(1,clase)+1
                end
            end
        end
    end
%   for clase=1:nclases
    Sumpon=Sumpon/patxclase;
%   end
%%  Clasificar
    [M,ind]=max(Sumpon);
    if M==0
        teta=teta+1;
% %         return
    else
        for clase=1:nclases
            if (Sumpon(1,clase)==M)
                maxunico=maxunico+1;
            end
        end
        if (maxunico==1)
            Clase=ind;
%             teta=0;
            return;
%         end
        elseif (maxunico>1)
            teta=p;
            Clase=ind;
%             Clase=10000;
%             return; 
        end
    end
% else (teta>=p)
%     teta=teta+1;
%     Clase=3000;
end
end