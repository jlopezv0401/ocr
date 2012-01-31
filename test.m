clc; clear all; close all;
% % Set up an input coordinate system so that the input image 
% % fills the unit square with vertices (0 0),(1 0),(1 1),(0 1).
% I = imread('cameraman.tif');
% udata = [0 1];  vdata = [0 1];
% 
% % Transform to a quadrilateral with vertices (-4 2),(-8 3),
% % (-3 -5),(6 3).
% tform = maketform('projective',[ 0 0;  1  0;  1  1; 0 1],...
%                                [-4 2; -8 -3; -3 -5; 6 3]);
% 
% % Fill with gray and use bicubic interpolation. 
% % Make the output size the same as the input size.
% 
% [B,xdata,ydata] = imtransform(I, tform, 'bicubic', ...
%                               'udata', udata,...
%                               'vdata', vdata,...
%                               'size', size(I),...
%                               'fill', 128);h
% subplot(1,2,1), imshow(udata,vdata,I), axis on
% subplot(1,2,2), imshow(xdata,ydata,B), axis on
% 
% %% Base de datos
% clc; clear all; close all;
% tic
% %% Lectura de la imagen
% gris =imread('basesc.bmp');
% % gris =rgb2gray(ima);
% % gris=gris(300:360,100:450);
% % gris=gris(150:400,1:280);
% % gris=gris(1:300,1:1000);
% % figure, imshow(gris);
% % imtool(gris);
% %% Umbralizado y Binarizacion
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Umbralizado utilizando el valor de luminosidad
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% % [h w]= size(gris);
% % for i=1:w
% %     M(i)= sum(gris(:,i));
% % end
% % M;
% % M=sum(M);
% % M=M/(h*w)
% % hist=imhist(gris);
% % [y x]=max(hist);
% % D=(x-1)-M;
% % T=M-D;
% % binario=gris<T;
% % imtool(binario)
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Umbralizado utilizando Otsu
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% T=graythresh(gris)*255
% binario=gris<T-30;
% imtool(binario)
% 
% %% Preprocesamiento
% % imtool(binario)
% % binario=bwmorph(binario,'remove');
% % binario=imclearborder(binario,8);
% binario=bwmorph(binario,'clean');
% % binario=bwmorph(binario,'clean');
% % imtool(binario);
% % binario=bwmorph(binario,'thin', Inf);
% % imtool(binario);
% binario=bwmorph(binario,'spur');
% % imtool(binario);
% % binario=bwmorph(binario,'spur');
% % imtool(binario);
% % filas=sum(binario');
% % figure, plot(filas);
% 
% %% Extraccion de lineas de texto
% B=strel('rectangle', [5 100]);
% dilata=imdilate(binario,B);
% % figure, imshow(dilata)
% 
% % B=strel('rectangle', [25 1]);
% % dilata2=imdilate(binario,B);
% % figure, imshow(dilata2)
% % filas=sum(dilata2);
% % figure, plot(filas);
% % dilata=and(dilata,dilata2);
% % figure, imshow(dilata)
% 
% filas=sum(dilata');
% % imtool(dilata);
% % figure, plot(filas);
% linea=zeros(2,1);
% k=1;
% promedio=0;
% suma=0;
% for i=1:length(filas)
%     if (i+1)<length(filas)
%         if filas(i)<=0 && filas(i+1)>0
%            linea(1,k)=i+1;
%         elseif filas(i)>0 && filas(i+1)<=0
%            linea(2,k)=i-linea(1,k);
%            k=k+1;           
% %                     if promedio~=0
% %                         pro=(promedio*.5)+promedio;
% %                         if (i-linea(1,k))<(pro)
% %                             linea(2,k)=i-linea(1,k);                            
% %                         else
% %                             linea(2,k)=round((i-linea(1,k))/2)-1;
% %                             linea(1,k+1)=i-round((i-linea(1,k))/2)+1;
% %                             linea(2,k+1)=linea(1,k+1)-(linea(1,k));
% %                             k=k+1;
% %                         end
% %                         suma=suma+(i-linea(1,k));
% %                         promedio=suma/k;
% %                         k=k+1;
% %                     else                        
% %                         suma=suma+(i-linea(1,k));
% %                         promedio=suma/k;
% %                         linea(2,k)=i-linea(1,k); 
% %                         k=k+1; 
% %                     end
%         end
%     end
% end
% % linea
% % length(linea(2,:));
% % mean(linea(2,:));
% lmax=max(linea(2,:))+1
% 
% p=1;
% total=1;
% %% Lectura de archivo original
% fidr=fopen('basedatos.txt', 'r');
% tline = fgetl(fidr);
% todo='';
% 
% while ischar(tline)
%     todo=strcat(todo,tline);
%     tline = fgetl(fidr);
% end
% fclose(fidr);
% todo=strrep(todo,' ', '');
% length(todo);
% todo;
% length(todo)
% %% Extraccion de Carateres y escritura de la Base de datos
% for i=1:length(linea)-1
%     if linea(2,i)>(lmax/2)
%         recortelinea=binario(linea(1,i):linea(1,i)+linea(2,i),:);
%         B=strel('line',50,90);
%         dilata=imdilate(recortelinea,B);
% %       figure, imshow(dilata);
%         letras=sum(recortelinea);
% %       figure, plot(letras);
%         k=1;
%         letra=zeros(2,100); 
%         promedio=0;
%         suma=0;
%         for j=1:length(letras)
%             if (j+1)<length(letras) 
%                 if letras(j)==0 && letras(j+1)~=0
%                    letra(1,k)=j+1;
%                 elseif letras(j)~=0  && letras(j+1)==0 
% %                    letra(2,k)=j-letra(1,k);
% %                    k=k+1;
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Separacion de caracteres conectados en base al ancho promedio
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                     if promedio~=0
%                         pro=(promedio*.5)+promedio;
%                         if (j-letra(1,k))<(pro)
%                             letra(2,k)=j-letra(1,k);                            
%                         else
%                             letra(2,k)=round((j-letra(1,k))/2)-1;
%                             letra(1,k+1)=j-round((j-letra(1,k))/2)+1;
%                             letra(2,k+1)=letra(1,k+1)-(letra(1,k));
%                             k=k+1;
%                         end
%                         suma=suma+(j-letra(1,k));
%                         promedio=suma/k;
%                         k=k+1;
%                     else                        
%                         suma=suma+(j-letra(1,k));
%                         promedio=suma/k;
%                         letra(2,k)=j-letra(1,k); 
%                         k=k+1; 
%                     end
%                     
%                 end
%             end
%         end 
%     r=1;
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Recorte de caracteres y extraccion de caracteristicas
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     for j=1:length(letra)
%         if letra(2,j)>1             
%             recorte=(binario(linea(1,i):linea(1,i)+linea(2,i),letra(1,j):letra(1,j)+letra(2,j)));
% %             figure, imshow(recorte);
%             %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%             %EXTRACCION SIMPLE
%             %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %             [h, w]=size(recorte);
% %             hr=lmax-h;
% %             wr=25-w;            
% %             completo=padarray(recorte,[hr,wr],'post'); %38x25 
% %             fprintf(fid,'%i,',completo(:)');
% % %             fprintf(fid,'%s\n',todo(total));
% %             fprintf(fid,'%s\n',['']);
%             %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%             %EXTRACCION HU
%             %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
%             if p==3
%                 if r==3
%             normal=abs(log(invmoments(recorte)))
%             norm='';
%             for k=1:length(normal)
%                 if normal(k)==Inf
%                     normal(k)=0;
%                 end
%                 redondo=round(normal(k)*10000);
%                 norm=strcat(norm,dec2bin(redondo,20));                
%             end
%             norm
%             normal=zeros(1,length(norm));
%             for k=1:length(norm)
%                 normal(k)=str2num(norm(k));   
%             end
%                            
%                 end
%             end
% %             for k=1:lmax         
% %                 [h, w]=size(recorte);
% %                 hr=lmax-h;
% %                 wr=25-w;         
% %                 completo=padarray(recorte,[hr,wr],'post'); %38x25                
% % %                 completo=(padarray(recorte,[hr,wr]));
% %                 fprintf(fid,'%s',[num2str(completo(k,:)) '  ']);                
% %             end
% 
% 
% 
% %             if p<1
% %                 if r<1
% % %                     figure, imshow(completo)
% % %                     completo=bwmorph(completo,'thin', Inf);
% %                     normal=invmoments(completo)
% %                     norm='';
% %                     for k=1:length(normal)
% %                         if normal(k)<0
% %                             norm=strcat(norm,'1',dec2bin(round(abs(normal(k))*1000000),25)); 
% %                         else
% %                             norm=strcat(norm,'0',dec2bin(round(abs(normal(k))*1000000),25)); 
% %                         end
% %                     end
% %                     normal=0;
% %                     for k=1:length(norm)
% %                         normal(k)=str2num(norm(k));   
% %                     end
% %                     
% % %                     c=1;
% % %                     normal=0;
% % %                     [a b]=size(completo)
% % %                     for k=1:b
% % %                         for l=1:a
% % %                             normal(c)=completo(l,k);
% % %                             c=c+1;
% % %                         end
% % %                     end
% % %                     num2str(normal)
% %                     figure, imshow(completo);   
% %                     
% %                     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %                     % Patron ruidoso, escalado o girado
% %                     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %                     completo=imresize(completo,2);
% % %                     completo=imrotate(completo,5);
% % %                     completo=bwmorph(completo,'thin', Inf);
% % %                     [u v]=size(completo);
% % %                     completo=xor(completo,randerr(u,v)) ; 
% % 
% %                     figure, imshow(completo);
% %                     modificado=invmoments(completo)
% %                     modi='';
% %                     for k=1:length(modificado)
% %                         if modificado(k)<0
% %                             modi=strcat(modi,'1',dec2bin(round(abs(modificado(k))*1000000),25));    
% %                         else
% %                             modi=strcat(modi,'0',dec2bin(round(abs(modificado(k))*1000000),25));   
% %                         end
% %                     end
% %                     modificado=0;
% %                     for k=1:length(modi)
% %                         modificado(k)=str2num(modi(k));   
% %                     end
% %                     
% % %                     c=1;
% % %                     modificado=0;
% % %                     [a b]=size(completo)
% % %                     for k=1:b
% % %                         for l=1:a
% % %                             modificado(c)=completo(l,k);
% % %                             c=c+1;
% % %                         end
% % %                     end
% % %                     num2str(modificado)
% % 
% %                     length(modificado)
% %                     sum(xor(normal,modificado))
% % %                     norm
% % %                     modi
% %                     errores(r)=sum(xor(normal,modificado));                    
% %                     r=r+1;
% %                 end
% % %                     mean(errores)
% %             end
%             total=total+1;            
%         end
%         r=r+1;
%     end    
% %         if p==6
% %             imtool(dilata); 
% %             imtool(recortelinea);
% %         end
%         letramax(p)=max(letra(2,:))+1;
%         p=p+1;        
%     end
% end
% toc
% total=total+1
% % % total
% % mean(letramax)
% % max(letramax)
% letramax
% % [x,y]=min(letramax)
% 
% X=csvread('basehu.csv');
% Y=csvread('basehu1.csv');
% fid = fopen('basehu2.csv', 'w+');
%     for i=1:74
%             fprintf(fid,'%f,',X(i,:));
%             fprintf(fid,'\n');
%             fprintf(fid,'%f,',Y(i,:));
%             fprintf(fid,'\n');
%     end
% fclose(fid);
% close all;
% A=imread('arial.bmp');
% size(A)
% B=rgb2gray(A);
% size(B)
% T=graythresh(A);
% T*255
% B=im2bw(A,T);
% % imhist(B)
% B=bwmorph(B,'clean');
% B=bwmorph(B,'spur')
% imshow(B)
% figure, imshow(A);
% size(A)
% B=imresize(A, [400 800], 'nearest');
% size(B)
% figure, imshow(B);

% I = imread('coins.png');
% figure, imshow(I)
% 
% bw = im2bw(I, graythresh(getimage));
% figure, imshow(bw)
% 
% bw2 = imfill(bw,'holes');
% L = bwlabel(bw2);
% s = regionprops(L, 'centroid');
% centroids = cat(1, s.Centroid);
% 
% imtool(I)
% hold(imgca,'on')
% plot(imgca,centroids(:,1), centroids(:,2), 'r*')
% hold(imgca,'off')

%     puntos=[1 2 3 5 6 8 9 10; 1.5 2 4 4.6 4.7 8.5 8.8 9.9];
%     puntos=[1:50;(rand(1,50)*10)]
%     puntos=[23.5000000000000,39,53.5000000000000,68.5000000000000,83,98,112.500000000000,143,157.500000000000,188,203,218.500000000000,233.500000000000,249,278,293.500000000000,309.500000000000,323,339.500000000000,354,369.500000000000,399,429.500000000000,444.500000000000,459.500000000000,489.500000000000,504.500000000000,519,534,549.500000000000,564.500000000000,579.500000000000,594.500000000000,624.500000000000,639,654.500000000000,670,685,700.500000000000,715.500000000000,730.500000000000;326,321,321,321,321,321,321,321,321,321,321,326,321,321,321,326,321,321,321,321,321,321,321,321,322,322,321,321,322,322,321,322,322,326,322,322,322,322,322,322,322]
%     puntos=[1:20; 1 4 1 1 1 5 1 -4 1 1 1 1 1 1 1 -5 1 1 1 1]
% 	plot(puntos(1,:),puntos(2,:),'^')
%     hold on
%     
%     for i=1:11
%         p1=0;
%         p2=0;
%         n=length(puntos(1,:));
%         while p1==p2
%                 p1=ceil(mod((rand*1000),n))
%                 p2=ceil(mod((rand*1000),n))
%         end  
%         %Coeficientes ax+by+c=0, linea que pasa por
%         %los puntos p1 y p2
%         a=puntos(2,p1)-puntos(2,p2)
%         b=puntos(1,p1)-puntos(1,p2)
%         c=-puntos(1,p1)*a+puntos(2,p1)*b
% %         %Testeo de la linea generada
%         x=puntos(1,:);
%         y=x.*(a/b)+(c/b);
% %         line(x,y,'Color','b','LineWidth',1);
%         %Distancia de la recta al un punto
%         errorlms=zeros(1,n);        
%         for j=1:n
%             x0=puntos(1,j);
%             y0=puntos(2,j);
% %             errolms(j)=abs((a*x0)+(b*y0)+c)/sqrt(power(a,2)+power(b,2));
%             errorlms(j)=power(abs(y(j)-puntos(2,j)),2);
%         end
%         mediana(1,i)=median(errorlms);
%         mediana(2,i)=p1;
%         mediana(3,i)=p2;
%         
%     end
%     mediana
%     [rec I]=min(mediana(1,:))
%     
%         a=puntos(2,mediana(2,I))-puntos(2,mediana(3,I))
%         b=puntos(1,mediana(2,I))-puntos(1,mediana(3,I))
%         c=-puntos(1,mediana(2,I))*a+puntos(2,mediana(2,I))*b
% %         %Testeo de la linea generada
%         x=puntos(1,:);
%         y=x.*(a/b)+(c/b);
%         line(x,y,'Color','black','LineWidth',1);
% %     plot(puntos(1,p1),puntos(2,p1),'*')
% %     plot(puntos(1,p2),puntos(2,p2),'*')

% palabra='Stuttgart';
% 
% h = actxserver('word.application');
% h.Document.Add;
% % h.CheckGrammar('Las cosas habian llegada lan lrjos para el')
% % h.auto
% correcto = h.CheckSpelling(palabra);
% 
% if correcto
%     sugerencias=0; %Si es correcto no regresa nada
% else
% %Si es incorrecto regresa una celda con las sugerencias
%     if h.GetSpellingSuggestions(palabra).count > 0
%         sugerencias = h.GetSpellingSuggestions(palabra).count;
%         for i = 1:sugerencias            
%             sugerir{i} = h.GetSpellingSuggestions(palabra).Item(i).get('name');
%         end
%     else
%     %Sin Sugerencias
%         sugerencias=0;
%     end
% end
% %Cerrar Word
% h.Quit
% %Seleccionar la primera sugerencia
% if sugerencias>0
%     for i = 1:sugerencias 
%         if length(palabra)==length(sugerir{i})
%             corregido=sugerir{i}
%             return
%         else          
%             corregido=palabra;
%         end
%     end
% else
%     corregido=palabra;
% end
% correcto
% sugerencias
% corregido
% 

% fid = fopen('salida.txt', 'w+');    
%     fprintf(fid,'holas ')
%     position = ftell(fid)
%     fseek(fid,-1,'cof')
%     cara=fscanf(fid,'%c',1)
%     fprintf(fid, '%s', 'cabron')
% fclose(fid)

% p=imread('circulo.bmp');
% p=rgb2gray(p);
% T=graythresh(p)*255;
% binario=p<T;
% figure, imshow(binario)
% z=invmoments((abs(binario)))
% 
% [h w]=size(binario);
% binario=imresize(binario,[h*.45 w*.45],'bicubic');
% figure, imshow(binario)
% z=invmoments((abs(binario)))

% I=[0 0 0 0 0 0; 0 0 0 0 0 0; 0 0 1 1 0 0; 0 1 1 1 1 0 ...
%     ; 0 1 1 1 1 0;0 0 1 1 0 0;0 0 0 0 0 0; 0 0 0 0 0 0]
% Imas=[0 0 0 0 0 0; 0 0 0 0 0 0; 0 0 1 1 0 0; 0 1 1 1 1 0 ...
%     ; 0 1 1 1 1 0;0 0 1 1 1 0;0 0 1 1 0 0; 0 0 1 1 0 0]
% Imenos=[0 0 0 0 0 0; 0 0 0 0 0 0; 0 0 1 1 0 0; 0 1 0 0 1 0 ...
%     ; 0 1 0 0 1 0;0 0 1 1 0 0;0 0 0 0 0 0; 0 0 0 0 0 0]
% Ineutro=[0 0 0 0 0 0; 0 0 0 0 0 0; 0 0 1 1 0 0; 0 1 0 0 1 0 ...
%     ; 0 1 0 0 1 0;0 0 1 1 1 0;0 0 1 1 0 0; 0 0 1 1 0 0]

% figure, imshow(imresize(I,[24, 18],'nearest'))
% figure, imshow(imresize(Imas,[24, 18],'nearest'))
% figure, imshow(imresize(Imenos,[24, 18],'nearest'))
% figure, imshow(imresize(Ineutro,[24, 18],'nearest'))

% I=[1 1 1 1 0 0 0 0; 1 1 1 1 0 0 0 0; 1 1 1 1 0 0 0 0; 1 1 1 1 0 0 0 0; ...
%    0 0 0 0 0 0 0 0; 0 0 0 0 0 0 0 0; 0 0 0 0 0 0 0 0; 0 0 0 0 0 0 0 0 ];
% figure, imshow(imresize(I,[32, 32],'nearest'));
% I=[1 1 1 1 0 0 0 0; 1 1 0 1 0 0 0 0; 1 1 1 1 0 0 0 0; 1 1 1 1 0 0 0 0; ...
%    0 0 0 0 0 0 0 0; 0 0 0 0 0 0 0 0; 0 0 0 0 0 0 0 0; 0 0 0 0 0 0 0 0 ];
% figure, imshow(imresize(I,[32, 32],'nearest'));
% %desconocido c1
% I=[1 1 0 1 0 0 0 0; 1 1 1 1 0 0 0 0; 1 1 1 1 0 0 0 0; 1 1 1 1 0 0 0 0; ...
%    0 0 0 0 0 0 0 0; 0 0 0 0 0 0 0 0; 0 0 0 0 0 0 0 0; 0 0 0 0 0 0 0 0 ];
% figure, imshow(imresize(I,[32, 32],'nearest'));
% I=[1 1 1 1 0 0 0 0; 1 1 0 1 0 0 0 0; 1 1 1 1 0 0 0 0; 1 1 1 1 0 0 0 0; ...
%    0 0 0 0 0 0 0 0; 0 0 0 0 0 0 0 0; 0 0 0 0 0 0 0 0; 0 0 0 0 0 0 0 0 ];
% figure, imshow(imresize(I,[32, 32],'nearest'));
% 
% I=[0 0 0 0 1 1 1 1;0 0 0 0 1 1 1 1; 0 0 0 0 1 1 1 1; 0 0 0 0 1 1 1 1; ...
%    0 0 0 0 0 0 0 0;0 0 0 0 0 0 0 0; 0 0 0 0 0 0 0 0; 0 0 0 0 0 0 0 0];
% figure, imshow(imresize(I,[32, 32],'nearest'));
% I=[0 0 0 0 1 1 1 1;0 0 0 0 1 0 1 1; 0 0 0 0 1 1 1 1; 0 0 0 0 1 1 1 1; ...
%    0 0 0 0 0 0 0 0;0 0 0 0 0 0 0 0; 0 0 0 0 0 0 0 0; 0 0 0 0 0 0 0 0];
% figure, imshow(imresize(I,[32, 32],'nearest'));
% 
% %desconocido c2
% I=[0 0 0 0 1 1 1 1;0 0 0 0 1 0 0 1; 0 0 0 0 1 1 1 1; 0 0 0 0 1 1 1 1; ...
%    0 0 0 0 0 0 0 0;0 0 0 0 0 0 0 0; 0 0 0 0 0 0 0 0; 0 0 0 0 0 0 0 0];
% figure, imshow(imresize(I,[32, 32],'nearest'));
% 
% I=[0 0 0 0 0 0 0 0; 0 0 0 0 0 0 0 0; 0 0 0 0 0 0 0 0;0 0 0 0 0 0 0 0; ...
%    0 0 0 0 1 1 1 1; 0 0 0 0 1 1 1 1; 0 0 0 0 1 1 1 1;0 0 0 0 1 1 1 1];
% figure, imshow(imresize(I,[32, 32],'nearest'));
% I=[0 0 0 0 0 0 0 0; 0 0 0 0 0 0 0 0; 0 0 0 0 0 0 0 0;0 0 0 0 0 0 0 0; ...
%    0 0 0 0 1 1 1 1; 0 0 0 0 1 1 1 1; 0 0 0 0 1 1 1 1;0 0 0 0 1 1 1 0];
% figure, imshow(imresize(I,[32, 32],'nearest'));

% gris=imread('cada.bmp');
% T=graythresh(gris)*255;
% binario=gris<T
% figure, imshow(binario)
% 
% B=strel('rectangle', [2 2]);
% dilata=imdilate(binario,B);
% 
% erode=imerode(binario,B);
% 
% uno=or(binario,dilata)
% dos=and(binario,erode)
% figure, imshow(uno)
% figure, imshow(dos)
% 
% figure, imshow(and(uno,dos))

%     puntos=[1:20; 1 4 1 1 1 5 1 -4 1 1 1 1 1 1 1 -5 1 1 1 1]
% % 	plot(puntos(1,:),puntos(2,:),'*')
%     hold on
%       
%     mx=sum(puntos(1,:));
%     my=sum(puntos(2,:));
%     mxx=sum(puntos(1,:).*puntos(1,:));
%     myy=sum(puntos(2,:).*puntos(2,:));
%     mxy=sum(puntos(1,:).*puntos(2,:));
%     
%     N=length(puntos(1,:));
%     m=((N*mxy)-(mx*my))/((N*mxx)-(mx*mx));
%     n=((mxx*my)-(mx*mxy))/((N*mxx)-(mx*mx));
%     X=zeros(1,N);
%     Y=zeros(1,N);
%     for i=1:N
%         X(i)=(n+(m*puntos(1,i))-puntos(2,i))^2;
%         Y(i)=(m*puntos(1,i))+n;
%     end
% %     XX=median(X);    
%     plot(puntos(1,:),Y,'.-')  

% x=csvread('basehu1.csv');
% size(x)
% fid = fopen('basedatos.txt', 'r');
%     texto=fread(fid, '*char');    
%     texto=strrep(texto', ' ', '');
% fclose(fid);
% xmin=0;
% xmax=max(x(:,1));
% ymin=0;
% ymax=max(x(:,2));
% length(texto)
% axis([xmin xmax ymin ymax])
% k=1
% for i=1:80
%     text(x(i,1),x(i,2),['\fontsize{12}\color{red}' texto(i)])
%     hold on;
%     
%     text(x(80+i,1),x(80+i,2),['\fontsize{14}\color{magenta}' texto(i)])
%     hold on;
%     
% %     text(x(160+i,1),x(160+i,2),['\fontsize{16}' texto(i)])    
% %     hold on;
%     
% end

% 
palabras='eacuificioe';

h = actxserver('word.application');
h.Document.Add;
% h.CheckGrammar('Las cosas habian llegada lan lrjos para el')
% h.auto


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
                        sugerir                        
                        corregido

% 
