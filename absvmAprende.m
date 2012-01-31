%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%APRENDIZAJE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic
a=0;
% for f=1:148 %Para el LOO
X=csvread('basehu1.csv');
X=X(240:400,:);
% X=X(:,2:183);
% X=[0 1 0 1 0 1 1 1 1; 0 1 0 1 1 1 1 1 1; ...
%    0 1 1 1 1 1 0 1 1; 1 1 0 1 0 1 1 1 1; ...
%    1 1 1 1 0 1 0 1 1; 0 1 1 1 0 1 1 1 1;
%    0 1 0 1 1 1 0 1 1];
[h, w]=size(X); %p=h  i=w
%% Vector de soporte del conjunto

S=zeros(1,w);
for i=1:w
    for j=2:2:h        
        if j>2
            minimo=beta(X(j-1,i),X(j,i));
            S(i)=min(S(i),minimo);
        else
            S(i)=beta(X(j-1,i),X(j,i));
        end
    end
end

fid = fopen('S.csv', 'w+');
fprintf(fid,'%d,',S);
fclose(fid);

%% Restriccion de los patrones por S
sigma=sum(S);
Xr=zeros(h,w-sigma);
k=1;
for i=1:w
    if S(i)==0
        Xr(:,k)=X(:,i);
        k=k+1;
    end
end

fid = fopen('Xr.csv', 'w+');
for i=1:h
    fprintf(fid,'%d,',Xr(i,:));
    fprintf(fid,'\n');
end
fclose(fid);

%% Vector de soporte del conjunto negado
Xn=not(X);
Sn=zeros(1,w);
for i=1:w
    for j=2:2:h
        if j>2
            minimo=beta(Xn(j-1,i),Xn(j,i));
            Sn(i)=min(Sn(i),minimo);
        else
            Sn(i)=beta(Xn(j-1,i),Xn(j,i));   
        end
    end
end

fid = fopen('Sn.csv', 'w+');
fprintf(fid,'%d,',Sn);
fclose(fid);

%% Restriccion de los patrones por Sn
sigma=sum(Sn);
Xrn=zeros(h,w-sigma);
k=1;
for i=1:w
    if Sn(i)==0
        Xrn(:,k)=Xn(:,i);
        k=k+1;
    end
end

fid = fopen('Xrn.csv', 'w+');
for i=1:h
    fprintf(fid,'%d,',Xrn(i,:));
    fprintf(fid,'\n');
end
fclose(fid);
toc