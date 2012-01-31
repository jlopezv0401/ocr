close all; clear all; clc;

tic
x=csvread('basehu.csv');
y=csvread('basehu.csv');

x=x(:,1:size(x,2)-1);
y=y(:,1:size(y,2)-1);
patxclase=1;
nclases=102;
ndec=6;

% dimensiones, elementos minimos del conjunto fundamental
xf=size(x,1);
xc=size(x,2);
m=min(x);

% dimensiones del conjunto a clasificar
yf=size(y,1);
yc=size(y,2);

% %vector en el que se almacenan las clases a las que pertenecen
% Clase=zeros(1,yf);

%% convertir los patrones a numeros enteros
[X]= dec2ent(xf,xc,m,x,ndec);
[Y]= dec2ent(yf,yc,m,y,ndec);
p=min(max(X));

% %% contar el numero de vectores por clase
% Cardclase=zeros(1,nclases);
% for fxf=1:xf
%     for clase=1:nclases
%         if (confun(fxf,xc+1)==clase)
%             Cardclase(1,clase)=Cardclase(1,clase)+1;
%         end
%     end
% end

% tic
for f=1:yf %86,87,88. 96, 97
    clases=gama1(X,xf,xc,Y(f,:),yc,p,patxclase,nclases)
end
toc