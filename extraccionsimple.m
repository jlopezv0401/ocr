
clc; clear all; close all;
tic
ima=imread('parrafo.bmp');
%figure, imshow(ima);
gris =rgb2gray(ima);


%%Metodo Otsu para umbralizar;
% T=0.5*(double(min(gris(:)))+double(max(gris(:))));
% done=false;
% while -done
% 	g=f>=T;
% 	Tnext=0.5*(mean(gris(g))+mean(gris(-g)));
% 	done=abs(T-Tnext)<0.5;
% 	T=Tnext;
% end

T=graythresh(gris)*255
binario=gris<T;
figure, imshow(binario);

filas=sum(binario');
figure, plot(filas);

% ruido=imnoise(gris,'salt & pepper', 0.01);
% ruido=not(ruido<150);
% 
% figure, imshow(ruido);
% B=strel('disk', 4);
% B=strel([0 0 0 0 0 0 0 0 0 0;1 1 1 1 1 1 1 1 1 1;0 0 0 0 0 0 0 0 0 0]);
B1=strel([0 0 0 0 0 0 0 0; 0 0 0 0 0 0 0 0 ; 0 0 0 0 0 0 0 0; 0 0 0 1 1 0 0 0; ...
    0 0 0 1 1 0 0 0; 0 0 0 0 0 0 0 0; 0 0 0 0 0 0 0 0; 0 0 0 0 0 0 0 0 ]);
% fe=imerode(binario,ones(51,1));
% fo=imreconstruct(fe,binario)
% binario=imfill(binario,'holes');
binario=imclearborder(binario,8);
figure, imshow(binario);
B=strel('line',500,0);
% sinruido=bwhitmiss(ruido,B1,B2);
% figure, imshow(sinruido)

dilata=imdilate(binario,B);
% erosiona=imerode(dilata,B);
% abre=imopen(binario,B);
% cierra=imclose(binario,B);

figure, imshow(dilata);
% figure, imshow(erosiona);
% figure, imshow(abre);
% figure, imshow(cierra);

filas=sum(dilata');
figure, plot(filas);
% linea=zeros(2,45)
k=1;
for i=1:length(filas)
    if (i+1)<length(filas)
        if filas(i)==0 && filas(i+1)~=0
           linea(1,k)=i+1;
        elseif filas(i)~=0 && filas(i+1)==0
           linea(2,k)=i;
           k=k+1;
        end
    end
end

for i=1:length(linea)    
    recorte=not(binario(linea(1,i):linea(2,i),:));
    B=strel('line',50,90);
    dilata=imdilate(not(recorte),B);
%     figure, imshow(dilata);
    letras=sum(dilata);
%     figure, plot(letras);
    k=1;
    for i=1:length(letras)
        if (i+1)<length(letras)
            if letras(i)==0 && letras(i+1)~=0
               letra(1,k)=i+1;
            elseif letras(i)~=0 && letras(i+1)==0
               letra(2,k)=i;
               k=k+1;
            end
        end
    end
end
k=0;
% linea
% letra
% for i=11:11
%     for j=1:length(letra) 
%         recorte=not(binario(linea(1,i):linea(2,i),letra(1,j):letra(2,j)));
%         if k<10
%         figure, imshow(recorte);
%         k=k+1;
%         end
%     end
% end
toc

