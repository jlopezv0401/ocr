function [r]=ocr()
% close all; clear all; clc;
global ruta;
global texto;
 
global relacion;
global base;
global patxclase;
global nclases;
global umbralinc;
global altoinc;

global normalto;
global normancho;

relacion=str2num(relacion);
patxclase=str2num(patxclase);
nclases=str2num(nclases);
umbralinc=str2num(umbralinc);
altoinc=str2num(altoinc);
normalto=str2num(normalto);
normancho=str2num(normancho);

% tic
% ruta='arialcasanova12.bmp';
% salida='salida.txt';
% relacion=1.3;
% base='courierarial40x29.csv';
% patxclase=6;
% nclases=80;
% umbralinc=17;
% altoinc=8;
% normalto=40;
% normancho=29;

%% Lectura de la imagen
ima=imread(ruta);
% ima=ima(200:260,20:1200);
% ima=ima(145:570,150:1200);
% figure, imshow(ima);
tama=size(ima);
[tam1 tam2]=size(tama);
if tam2==3    
    gris =rgb2gray(ima);
else
    gris=ima;
end
clear tama;
clear tama1;
clear tama2;
clear ima;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Inicia entrenamiento Gamma
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
x=csvread(base);
% x=x(1:540,:);
% dimensiones, elementos minimos del conjunto fundamental
xf=size(x,1);
xc=size(x,2);
m=min(x);
X=x;
pp=1;
clear x;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Ternina entrenamiento Gamma
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% Umbralizado y Binarizacion
T=graythresh(gris)*255;
binario=gris<T+umbralinc;
clear T;
clear gris;
% binario=binario(1:56,1:250);
% figure, imshow(binario);
binario=bwmorph(binario,'clean');
binario=bwmorph(binario,'clean');
% binario=bwmorph(binario,'spur');

%% Extraccion de lineas de texto
B=strel('rectangle', [1 500]);
dilata=imdilate(binario,B);
filas=sum(dilata');
% figure, imshow(dilata);
% figure, plot(filas)
clear B;
clear dilata;

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
        end
%     end
end
lineaprom=ceil(mean(linea(2,:)));
clear k

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Division de lineas
% Se toma el alto promedio y se divide  
% al intervalo de cada linea entre dos
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
k=1;
lineatemp=linea;
linea=zeros(2,1);
if length(lineatemp(1,:))>1
    for i=1:length(lineatemp)
         if lineatemp(2,i)>(lineaprom/2) && lineatemp(2,i)<ceil(lineaprom*2.5)
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %Pendiente separa cuando hay mas de dos lineas juntas
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
else
    linea=lineatemp;
end
clear lineatemp;
clear k;

h = actxserver('word.application');
h.Document.Add;

fid = fopen('salida.txt', 'w+');
p=1;
altolinea=max(linea(2,:));
acumulador=0;
acumuladorante=0;
letrasprom=0;
% figure, imshow(binario)
%% Extraccion de Carateres
for i=1:length(linea(1,:))
    if linea(2,i)>(lineaprom/2)
        recortelinea=binario(linea(1,i):linea(1,i)+linea(2,i),:);
        B=strel('line',40,90);
        dilata=imdilate(recortelinea,B);        
        letras=sum(dilata);
%         figure, imshow(dilata);                
%         figure, plot(letras);
        clear B;
        clear dilata;
        k=1;
        letra=zeros(2,1); 
        espacio=zeros(1,1);
        promedio=0;
        suma=0;        
        for j=1:length(letras(1,:))
            if (j+1)<length(letras) 
                if letras(j)==0 && letras(j+1)~=0
                    letra(1,k)=j+1;  
                    if k>1
                        espacio(k)=letra(1,k)-(letra(1,k-1)+letra(2,k-1));
                    end
                elseif letras(j)~=0  && letras(j+1)==0 
                    letra(2,k)=j-letra(1,k);
                    k=k+1;
                end
            end
        end   
        letraprom=round(mean(letra(2,:)));
        palabra=mean(espacio);
        ancholetra=max(letra(2,:))+1;         
        clear k;
        
%         k=1;
%         letratemp=letra;
%         letra=zeros(2,1);
%         if length(letratemp(1,:))>1
%             for j=1:length(letratemp)
%     %             if letratemp(2,j)>(letraprom/2)  
%                     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                     %Pendiente separa cuando hay mas de dos letras juntas
%                     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                     if letratemp(2,j)>ceil(letraprom+(letraprom*.5))
%                         final=letratemp(1,j)+letratemp(2,j);
%                         letra(1,k)=letratemp(1,j);
%                         letra(2,k)=round(letratemp(2,j)/2)-1;
%                         k=k+1;
%                         letra(1,k)=letratemp(1,j)+round(letratemp(2,j)/2)+1;
%                         letra(2,k)=final-letra(1,k);
%                     else
%                         letra(1,k)=letratemp(1,j);
%                         letra(2,k)=letratemp(2,j); 
%                     end
%                     k=k+1;
%     %             end
%             end
%         else
%             letra=letratemp;
%         end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Recorte de caracteres y extraccion de caracteristicas
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        numeroletras=length(letra(1,:));
        lineabase=zeros(2,1);
        reccaracter=zeros(6,1);
        q=1;
        for j=1:numeroletras
            if letra(2,j)>0         
                recorte=(binario(linea(1,i):linea(1,i)+linea(2,i),letra(1,j):letra(1,j)+letra(2,j)));
%                 figure, imshow(recorte)
                caracter=sum(recorte');  
%                 figure, plot(caracter);
                [f c]=find(recorte);
                alt1=min(f);
                alt2=max(f);
                clear recorte;
                
                reccaracter(1,q)=linea(1,i)+alt1-1;         %Posicion vertical inicial caracter
                reccaracter(2,q)=reccaracter(1,q)+alt2-alt1;    %Posicion vertical final caracter   
                reccaracter(3,q)=letra(1,j);                %Posicion inicial horizontal caracter
                reccaracter(4,q)=letra(1,j)+letra(2,j);     %Posicion final horizontal caracter
                reccaracter(5,q)=letra(1,j)+letra(2,j)/2;   %Punto medio del ancho caracter
                reccaracter(6,q)=linea(1,i)+alt2;           %Base del caracter
   
                q=q+1;
            end       
        end
        clear q;
        
%             if p==7   
%                 hold on; 
                lineabase=[reccaracter(5,:);reccaracter(6,:)];
                lineaAjustada=round(ajusteLms(lineabase));   
%                 plot(reccaracter(5,:),reccaracter(6,:),'rs', 'MarkerSize',10 ,'MarkerFaceColor', 'g')
%                 line(lineabase(1,:),lineaAjustada,'Color','g','LineWidth',3);     
%             end
%             p=p+1; 
            clear lineabase;
    end
%     reccaracter
    numeroletras=length(reccaracter(1,:));
    letrasprom=letrasprom+numeroletras/i;
    if letrasprom<(letrasprom*.3)
        palabra=letraprom;
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Promediando el alto de la letra en cada linea
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%          
    altoletra=round(max(reccaracter(2,:)-reccaracter(1,:)))+altoinc;
    acumulador=acumulador+altoletra;
    promedio=acumulador/i;
    if i>1
        if promedio<acumuladorante-2 && promedio>acumuladorante+2
            altoletra=acumuladorante;
        else
            altoletra=promedio;    
        end
    end
    altoletra=round((altoletra+altolinea)/2);
    acumuladorante=altoletra;
    
    claseante=0; %corregir caracteres que confunde a menudo
    palabras='';
    exacto=0;
    for j=1:numeroletras
            recorte=binario(reccaracter(1,j):reccaracter(2,j),reccaracter(3,j):reccaracter(4,j));
            [y x]=size(recorte);            

            porcy=floor((altoletra-y)/2); %25
            ancho=floor(altoletra/relacion);
            porcx=floor((ancho-x)/2); %25
         
            if porcx<0
                porcx=0;
            end      
            
            recorte=padarray(recorte,[porcy porcx]);
%             figure, imshow(recorte)
            recorte=imresize(recorte, [normalto normancho], 'nearest'); 
%             imtool(recorte)
            
            base2=lineaAjustada(j)-(reccaracter(1,j)+y);
            distabase=(reccaracter(6,j))-(reccaracter(1,j)-base2);
            relacionbase=(porcy+distabase)*(100/altoletra);          
%             relacionnormal=round(35*round(relacionbase)/100);            

            %Relacion a Johnson-Mobius
            agrega1=zeros(1,100);
            for d=1:100
                if d<=relacionbase
                    agrega1(d)=1;
                else
                    agrega1(d)=0;
                end
            end

            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %Clasificando y escribiendo en el archivo salida.txt
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%          
%             o=1;
%             for m=1:25
%                 for n=1:35
%                    patron(o)=recorte(n,m);
%                    o=o+1;
%                 end
%             end
%             Y=[patron agrega1 0];
%             imtool(recorte)
            Y=[recorte(:)' agrega1 0];
%             Y=dec2ent(1,length(normal),m,normal,ndec); 
%             normal=[recorte(:)' 0];
%             fprintf(fid,'%s',absvm(normal));
            clases=gama1(X,xf,xc,Y,length(Y),pp,patxclase,nclases);
            reconocido=regresaLetra(clases);
%             reconocido=absvm(Y);
            if j>1                
                if claseante>=67 && claseante<=76
                    if (reconocido =='1')
                        reconocido='1';
                    end 
                    if (reconocido =='4')
                        reconocido='4';
                    end 
                else
                    if (reconocido =='1')
                        reconocido='l';
                    end
                    if claseante>=34 && claseante<=66
                        if (reconocido =='4')
                            reconocido='mb';
                        end 
                    end
                end
                                
                if (reconocido =='í')
                    reconocido ='i';
                end
                
                if claseante>=1 && claseante<=33
                    if (reconocido =='Y')
                        reconocido ='Y';
                    end
                    if (reconocido =='U')
                        reconocido ='U';
                    end
                    if (reconocido =='J')
                        reconocido ='J';
                    end
                    if (reconocido =='L')
                        reconocido ='L';
                    end
                    if (reconocido =='I')
                        reconocido='I';
                    end
                    
                else
                    if (reconocido =='Y')
                        reconocido ='l';
                    end                    
                    if (reconocido =='U')
                        reconocido ='d';
                    end
                    if (reconocido =='J')
                        reconocido ='mb';
                    end
                    if (reconocido =='L')
                        reconocido ='t';
                    end
                    if (reconocido =='I')
                        reconocido='l';
                    end
                end                                
            else
                claseante=clases;
            end 
%             fprintf(fid,'%s',reconocido); 
%             if j<numeroletras                
%                 if (letra(1,j+1)-(letra(1,j)+letra(2,j)))>(palabra)
%                     fprintf(fid,'%s',' ');
%                 end  
%             end

%____________________________________________

            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %Utilizando Activex de Word
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%          
     
            palabras=strcat(palabras,reconocido);
%             if length(palabras)>1 
                if j<numeroletras
                    if (letra(1,j+1)-(letra(1,j)+letra(2,j)))>(palabra)
                        correcto = h.CheckSpelling(palabras);
                        if correcto
                            sugerencias=0; %Si es correcto no regresa nada
                        else
                        %Si es incorrecto regresa una celda con las sugerencias
                            if h.GetSpellingSuggestions(palabras).count > 0
                                sugerencias = h.GetSpellingSuggestions(palabras).count;
                                for ii = 1:sugerencias            
                                    sugerir{ii} = h.GetSpellingSuggestions(palabras).Item(ii).get('name');
                                end
                            else
                            %Sin Sugerencias
                                sugerencias=0;
                            end
                        end
                        %Seleccionar la primera sugerencia
                        if sugerencias>0
                            for ii=1:sugerencias 
                                if length(palabras)==length(sugerir{ii})
                                    corregido=sugerir{ii};
                                    break
                                else          
                                    corregido=palabras;
                                    exacto=1;
                                end
                            end
                        else
                            corregido=palabras;
                            exacto=1;
                        end
                        
                        if exacto==0
                            preciso=0;
                            for jj=1:length(palabras)
                                if corregido(jj)==palabras(jj)
                                    preciso=preciso+1;
                                end
                            end
                            if preciso<round(length(corregido)*.8)
                                corregido=palabras;
                            end                            
                        end
                        exacto=0;
%                         corregido=palabras;
    
                        if length(corregido)==1
                            if corregido=='.'                        
                                fseek(fid,-1,'cof');
                                fprintf(fid,'%s',[corregido ' ']);
                                palabras='';
                            elseif corregido==',' 
                                fseek(fid,-1,'cof');
                                fprintf(fid,'%s',[corregido ' ']);
                                palabras='';
                            elseif corregido==';' 
                                fseek(fid,-1,'cof');
                                fprintf(fid,'%s',[corregido ' ']);
                                palabras='';
                            elseif corregido==':' 
                                fseek(fid,-1,'cof');
                                fprintf(fid,'%s',[corregido ' ']);
                                palabras='';
                            else
                                fprintf(fid,'%s',[corregido ' ']);
                                palabras='';
                            end
                        else
                            fprintf(fid,'%s',[corregido ' ']);
                            palabras='';                            
                        end
                    end

                elseif j==numeroletras
                        correcto = h.CheckSpelling(palabras);
                        if correcto
                            sugerencias=0; %Si es correcto no regresa nada
                        else
                            %Si es incorrecto regresa una celda con las sugerencias
                            if h.GetSpellingSuggestions(palabras).count > 0
                                sugerencias = h.GetSpellingSuggestions(palabras).count;
                                for ii = 1:sugerencias            
                                    sugerir{ii} = h.GetSpellingSuggestions(palabras).Item(ii).get('name');
                                end
                            else
                                %Sin Sugerencias
                                sugerencias=0;
                            end
                        end
                        %Seleccionar la primera sugerencia
                        if sugerencias>0
                            for ii=1:sugerencias 
                                if length(palabras)==length(sugerir{ii})
                                    corregido=sugerir{ii};
                                    break;
                                else          
                                    corregido=palabras;
                                    exacto=1;
                                end
                            end
                        else
                            corregido=palabras;
                            exacto=1;
                        end
                        
                        if exacto==0
                            preciso=0;
                            for jj=1:length(palabras)
                                if corregido(jj)==palabras(jj)
                                    preciso=preciso+1;
                                end
                            end
                            if preciso<round(length(corregido)*.8)
                                corregido=palabras;
                            end                            
                        end
                        exacto=0;
%                         corregido=palabras;

                        if length(corregido)==1
                            if corregido=='.'                        
                                fseek(fid,-1,'cof');
                                fprintf(fid,'%s',corregido);
                                palabras='';
                            elseif corregido==',' 
                                fseek(fid,-1,'cof');
                                fprintf(fid,'%s',corregido);
                                palabras='';
                            elseif corregido==';' 
                                fseek(fid,-1,'cof');
                                fprintf(fid,'%s',corregido);
                                palabras='';
                            elseif corregido==':' 
                                fseek(fid,-1,'cof');
                                fprintf(fid,'%s',corregido);
                                palabras='';
                            else
                                fprintf(fid,'%s',corregido);
                                palabras='';
                            end
                        else
                            fprintf(fid,'%s',corregido);
                            palabras='';                            
                        end 
                    end
                
%             elseif length(palabras)==1
%                 if clases>=77 && clases<=80
%                     fprintf(fid,'\b%s',[palabras ' ']);
%                 else
%                     fprintf(fid,'\b%s',[palabras '']);
%                 end
%                 palabras='';
%             end
            claseante=clases;
    
    end
    fprintf(fid,'\n');

end
fclose(fid);
h.Quit;
% toc
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Lee salida.txt y guarda en texto
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
texto='';
fid=fopen('salida.txt');
linea = fgetl(fid);
while ischar(linea)
    if isempty(texto)
        texto=linea;
    else        
        texto=strcat(texto,'**+**',linea);
    end
    linea = fgetl(fid);
    
end
fclose(fid);
r=0;

