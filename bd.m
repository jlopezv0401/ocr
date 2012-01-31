%% Base de datos
clc; clear all; close all;
tic
%% Lectura de la imagen
ima=imread('basesctimes.bmp');
fid = fopen('basehu1.csv', 'a');
relacion=1.1;
% figure, imshow(ima)
normalto=40;
normancho=29;
tama=size(ima);
% ima=imresize(ima, [tama(1)*1.2 tama(2)*1.2], 'nearest');
% figure, imshow(imresize(ima, [200 600], 'bilinear'))
%            25 30 40 45
%            18 21 29 32
% tama=size(ima)
[tam1 tam2]=size(tama);
if tam2==3
    gris =rgb2gray(ima);
else
    gris=ima;
end
% figure, imshow(gris);
% imtool(gris);
%% Umbralizado y Binarizacion
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Umbralizado utilizando el valor de luminosidad
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% [h w]= size(gris);
% for i=1:w
%     M(i)= sum(gris(:,i));
% end
% M;
% M=sum(M);
% M=M/(h*w)
% hist=imhist(gris);
% [y x]=max(hist);
% D=(x-1)-M;
% T=M-D
% binario=gris<T;
% imtool(binario)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Umbralizado utilizando Otsu
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

T=graythresh(gris)*255
binario=gris<T;
% figure, imshow(not(binario))
% imtool(binario)

%% Preprocesamiento
% imtool(binario)
% binario=bwmorph(binario,'remove');
% binario=imclearborder(binario,8);
% binario=bwmorph(binario,'clean');
% binario=bwmorph(binario,'clean');
% imtool(binario);
% binario=bwmorph(binario,'thin', Inf);
% imtool(binario);
% binario=bwmorph(binario,'spur');
% imtool(binario);
% binario=bwmorph(binario,'spur');
% imtool(binario);
% filas=sum(binario');
% figure, plot(filas);

%% Extraccion de lineas de texto
B=strel('rectangle', [4 50]);
dilata=imdilate(binario,B);
% figure, imshow(dilata)

% B=strel('rectangle', [4 1]);
% dilata2=imdilate(binario,B);
% % figure, imshow(dilata2)
% filas=sum(dilata2);
% % figure, plot(filas);
% dilata=and(dilata,dilata2);
% 
% B=strel('rectangle', [4 100]);
% dilata=imdilate(binario,B);
% imtool(dilata)

filas=sum(dilata');
% figure, plot(filas)

base=sum(binario');
% figure, plot((base))

linea=zeros(2,1);
k=1;
promedio=0;
suma=0;
for i=2:length(filas)
%     if (i+1)<length(filas)
        if filas(i-1)<=0 && filas(i)>0
           linea(1,k)=i;%+1
        elseif filas(i-1)>0 && filas(i)<=0
           linea(2,k)=i-linea(1,k);%-3
           k=k+1; 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Separacion de lineas
% Se va haciendo un promedio con la altura de cada linea si
% si la altura de la linea encortrada es mayor al promedio
% mas la mitad del promedio, la linea se divide entre el 
% promedio, considerando que el documento tienes el mismo 
% tamanio de fuente
% No sirve por que se afecta mucho con lineas provocadas por
% solitario al dilatar, ademas, si se intenta reconocer diferentes
% tamanios de texto no seria viable
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     
%                     if promedio~=0
%                         pro=(promedio*.3)+promedio;
%                         if (i-linea(1,k))<pro
%                             linea(2,k)=i-linea(1,k)-2;                            
%                         else
%                             linea(2,k)=round((i-linea(1,k))/2)-1;
%                             linea(1,k+1)=i-round((i-linea(1,k))/2)+1;
%                             linea(2,k+1)=linea(1,k+1)-(linea(1,k));
%                             k=k+1;
%                         end
%                         suma=suma+(i-linea(1,k));
%                         promedio=suma/k;
%                         k=k+1;
%                     else                        
%                         suma=suma+(i-linea(1,k));
%                         promedio=suma/k;
%                         linea(2,k)=i-linea(1,k); 
%                         k=k+1; 
%                     end
        end
%     end
end
linea;
lineaprom=ceil(mean(linea(2,:)));
% lineaprom=max(linea(2,:))+1

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Division de lineas
% Se toma el ancho promedio y se divide si 
% al intervalo de cada linea
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
k=1;
lineatemp=linea;
linea=zeros(2,1);
for i=1:length(lineatemp)
    if lineatemp(2,i)>(lineaprom/2)  
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %Pendiente separar cuando hay mas de dos lineas juntas
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        if lineatemp(2,i)>ceil(lineaprom+(lineaprom*.5))
            final=lineatemp(1,i)+lineatemp(2,i);
            linea(1,k)=lineatemp(1,i);
            linea(2,k)=round(lineatemp(2,i)/2)-1;
            k=k+1;
            linea(1,k)=lineatemp(1,i)+round(lineatemp(2,i)/2)+1;
            linea(2,k)=final-linea(1,k);
        else
            linea(1,k)=lineatemp(1,i);
            linea(2,k)=lineatemp(2,i); 
        end
        k=k+1;
    end
end

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Lineas base
% % Se toman los maximos del intervalo que corresponde
% % cada linea
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% bases=zeros(2,1);
% k=1;
% for i=1:length(linea)
%     if linea(2,i)>(lineaprom/2)
%         medio=linea(1,i)+floor(linea(2,i)/2);
%         [maximo aux]=max(base(linea(1,i):medio-floor(linea(2,i)*(.15))));
%         bases(1,k)=linea(1,i)+aux-3; %Pendiente revisar en -2
%         [maximo aux1]=max(base(medio+floor(linea(2,i)*(.15)):linea(1,i)+linea(2,i)));
%         aumento=5;
%         if i==1 || i==3 || i==5
%             aumento=6;
%         end
%         bases(2,k)=medio+aux1+aumento; %Pendiente revisar en 3
%         k=k+1;
%     end
% end
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Impresion de lineas base
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% [h w]=size(binario);
% binariobase=binario;
% for i=1:length(bases)
%     for j=1:h
%         if  j==bases(2,i) || j==bases(1,i) 
%             for k=1:w
%                if binariobase(j,k)==0
%                    binariobase(j,k)=1; 
%                else
%                    binariobase(j,k)=0; 
%                end
%             end
%         end
%     end
% end
% imtool(binariobase)

p=1;
anchomax=0;
altodef=max(linea(2,:))
anchodef=round(altodef/relacion);
figure, imshow(not(binario))
%% Extraccion de Carateres
for i=1:length(linea)
    if linea(2,i)>(lineaprom/2)
        recortelinea=binario(linea(1,i):linea(1,i)+linea(2,i),:);
        B=strel('rectangle', [40 4]);
        dilata=imdilate(recortelinea,B);
%         figure, imshow(dilata);
%         figure, imshow(recortelinea);
        letras=sum(dilata);        
%       figure, plot(letras);
        k=1;
        letra=zeros(2,1); 
        promedio=0;
        suma=0;
        for j=1:length(letras)
            if (j+1)<length(letras) 
                if letras(j)==0 && letras(j+1)~=0
                   letra(1,k)=j+2;
                elseif letras(j)~=0  && letras(j+1)==0 
                   letra(2,k)=j-letra(1,k)-2;
                   k=k+1;
                end
            end
        end 
    q=1;
    ancholetra=max(letra(2,:));
    numeroletras=length(letra(1,:));
    lineabase=zeros(2,1);
    reccaracter=zeros(6,1);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Recorte de caracteres y extraccion de caracteristicas
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        for j=1:numeroletras
            if letra(2,j)>0             
                recorte=(binario(linea(1,i):linea(1,i)+linea(2,i),letra(1,j):letra(1,j)+letra(2,j)));
                caracter=sum(recorte');  
    %             figure, plot(caracter);
    %             [p q]=size(recorte);
    %             if i==1 && j==1
    %                 anchomax=q;
    %             end
    %             if anchomax<q
    %                 anchomax=q;
    %             end

                separa1=0;
                separa2=0;
                altoletra=length(caracter);
                k=altoletra;
                for t=1:altoletra-1                
                        if caracter(t)==0 && caracter(t+1)~=0
                            if separa1==0
                                alt1=t+1;
                                separa1=1;    
                            end
                        elseif caracter(t)~=0 && caracter(t+1)==0
                            if separa1==1 && separa2==0                            
                                separa2=1; 
                                alt2=t;
                            elseif separa1==1 && separa2==1
                                alt2=t;
                            end                        
                        end
                end 
                    reccaracter(1,q)=linea(1,i)+alt1-1;         %Posicion vertical inicial caracter
                    reccaracter(2,q)=reccaracter(1,q)+alt2-alt1;    %Posicion vertical final caracter   
                    reccaracter(3,q)=letra(1,j);                %Posicion inicial horizontal caracter
                    reccaracter(4,q)=letra(1,j)+letra(2,j);     %Posicion final horizontal caracter
                    reccaracter(5,q)=letra(1,j)+letra(2,j)/2;   %Punto medio del ancho caracter
                    reccaracter(6,q)=linea(1,i)+alt2;           %Base del caracter

                    q=q+1;      
            end       
        end
        
%             if p==7   
%                 hold on; 
                lineabase=[reccaracter(5,:);reccaracter(6,:)];
                lineaAjustada=round(ajusteLms(lineabase));
%                 line(lineabase(1,:),lineaAjustada,'Color','g','LineWidth',2);     
%             end
%             p=p+1; 
    end
    numeroletras=length(reccaracter(1,:));
    
    for j=1:numeroletras
            recorte=binario(reccaracter(1,j):reccaracter(2,j),reccaracter(3,j):reccaracter(4,j));
%             figure, imshow(recorte)
            [y x]=size(recorte);          
            
%             base2=lineaAjustada(j)-(reccaracter(1,j)+y);
%             porcx=floor((25-x)/2); %25
%             recorte=padarray(recorte,[1 porcx]);
%             altofinal=floor(35*relacion); %35
%             posyinicial=35-(y+base2); %35
%             recorte=padarray(recorte,[posyinicial 1], 'pre');  
%             [y x]=size(recorte);
%             posyfinal=altofinal-y;
%             recorte=padarray(recorte,[posyfinal 1], 'post');
% %             size(recorte)
%             figure, imshow(recorte)
%             recorte=imresize(recorte, [45 25], 'bicubic'); 
% %             figure, imshow(recorte)
                                            %14 12 10 190 150 100
            porcy=floor((altodef-y)/2);     %29 25 24 33  28  20
            porcx=floor((anchodef-x)/2);    %21 18 17 24 20 14
            recorte=padarray(recorte,[porcy porcx]);
%             figure, imshow(recorte)
%             recorte=padarray(recorte,[porcy porcx],'replicate');
%             recorte=bwmorph(recorte,'thin', Inf);
            recorte=imresize(recorte, [normalto normancho], 'nearest');
%             recorte=bwmorph(recorte,'thin', Inf);
%             recorte=fft(recorte);
            figure, imshow(recorte)
%             imtool(recorte)
%            25 30 40 45
%            18 21 29 32
            
            base2=lineaAjustada(j)-(reccaracter(1,j)+y);
            distabase=(reccaracter(6,j))-(reccaracter(1,j)-base2);
            relacionbase=((porcy+distabase)*(100/altoletra));
            relacionnormal=round(35*round(relacionbase)/100);

%             %Relacion a binario
%             agrega=dec2bin(relacionnormal);
%             agrega1=zeros(1,8);            
%             for d=1:length(agrega)
%                 agrega1(d)=str2num(agrega(d));
%             end

            %Relacion a Johnson-Mobius
            agrega1=zeros(1,100);
            for d=1:100
                if d<=relacionbase
                    agrega1(d)=1;
                else
                    agrega1(d)=0;
                end
            end
%             if i==5
%                 porcy+distabase
%                 relacionbase
%                 relacionnormal
%                 figure, imshow(recortelinea);               
% %                 centro=bwlabel(recorte);
% %                 centro=regionprops(centro, 'area')
%             end                     

            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %EXTRACCION SIMPLE
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%             [h, w]=size(recorte);
%             hr=lineaprom-h;
%             wr=25-w;            
%             completo=padarray(recorte,[hr,wr],'post'); %38x25 
%             absvm([completo(:)' 0])
            
%             %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%             %EXTRACCION HU
%             %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%          
            normal=abs(log(invmoments(recorte)));
            norm='';
            for k=1:length(normal)
%                 if normal(k)<0
%                     norm=strcat(norm,'1',dec2bin(round(abs(normal(k))*1000000),25)); 
%                 else
%                     norm=strcat(norm,'0',dec2bin(round(abs(normal(k))*1000000),25)); 
%                 end
                if normal(k)==Inf
                    normal(k)=0;
                end
%                 normal(k)=normal(k)*1000000;
%                 redondo=round(normal(k)*1000);
%                 normal(k)=redondo;
%                 norm=strcat(norm,dec2bin(redondo,20)); 
            end
%             if p==42 || p==45 || p==67
%                 figure, imshow(recorte)
%                 normal
%             end
% %             if i==3
% %                 figure, imshow(recorte)
% %                 normal
% %                 centro=bwlabel(recorte);
% %                 centro=regionprops(centro, 'area')
% %             end
% %             normal=zeros(1,length(norm));
% %             for k=1:length(norm)
% %                 normal(k)=str2num(norm(k));   
% %             end

%             o=1;
%             for n=1:25
%                 for m=1:35
%                    patron(o)=recorte(m,n);
%                    o=o+1;
%                 end
%             end
%             fprintf(fid,'%d,', [patron agrega1]);

%             fprintf(fid,'%d,', [recorte(:)' agrega1]);

            fprintf(fid,'%f,',normal); 

%             for m=1:7
%                 if m==7
%                     fprintf(fid,'%f',normal(m));  
%                 else
%                     fprintf(fid,'%f,',normal(m)); 
%                 end                
%             end
       
%             normal=[normal 0]; 

%             fprintf(fid,'%s',absvm(normal));            
%             figure, imshow(recorte)
%             if p<1
%                 if r<1
% %                     figure, imshow(completo)
% %                     completo=bwmorph(completo,'thin', Inf);
%                     normal=invmoments(completo)
%                     norm='';
%                     for k=1:length(normal)
%                         if normal(k)<0
%                             norm=strcat(norm,'1',dec2bin(round(abs(normal(k))*1000000),25)); 
%                         else
%                             norm=strcat(norm,'0',dec2bin(round(abs(normal(k))*1000000),25)); 
%                         end
%                     end
%                     normal=0;
%                     for k=1:length(norm)
%                         normal(k)=str2num(norm(k));   
%                     end
%                     
% %                     c=1;
% %                     normal=0;
% %                     [a b]=size(completo)
% %                     for k=1:b
% %                         for l=1:a
% %                             normal(c)=completo(l,k);
% %                             c=c+1;
% %                         end
% %                     end
% %                     num2str(normal)
%                     figure, imshow(completo); 
        fprintf(fid,'\n');
        p=p+1; 
        end
        
    
%         if p==6
%             imtool(dilata); 
%             imtool(recortelinea);
%         end
         
end

toc
fclose(fid);
anchomax






