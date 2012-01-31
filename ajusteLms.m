function regresion=ajusteLms(puntos)
%     puntos=[1 2 3 5 6 8 9 10; 1.5 2 4 4.6 4.7 8.5 8.8 9.9];
% 	plot(puntos(1,:),puntos(2,:),'*g')
%     hold on
      
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
% %     plot(puntos(1,:),Y)  


%     puntos=[1:20; 1 4 6 1 1 5 1 4 1 4 1 9 1 99 1 -5 1 7 1 33]
% 	plot(puntos(1,:),puntos(2,:),'*')
%     hold on

    if length(puntos(1,:))>1
        for i=1:11
            p1=0;
            p2=0;
            n=length(puntos(1,:));
            while p1==p2
                    p1=ceil(mod((rand*1000),n));
                    p2=ceil(mod((rand*1000),n));
            end  
            %Coeficientes ax+by+c=0, linea que pasa por
            %los puntos p1 y p2
            a=puntos(2,p1)-puntos(2,p2);
            b=puntos(1,p1)-puntos(1,p2);
            c=-puntos(1,p1)*a+puntos(2,p1)*b;
    %         %Testeo de la linea generada
            x=puntos(1,:);
            y=x.*(a/b)+(c/b);
    %         line(x,y,'Color','b','LineWidth',1);
            %Distancia de la recta al un punto
            errorlms=zeros(1,n);        
            for j=1:n
                x0=puntos(1,j);
                y0=puntos(2,j);
    %             errolms(j)=abs((a*x0)+(b*y0)+c)/sqrt(power(a,2)+power(b,2));
                errorlms(j)=power(abs(y(j)-puntos(2,j)),2);
            end
            mediana(1,i)=median(errorlms);
            mediana(2,i)=p1;
            mediana(3,i)=p2;

        end
        [rec I]=min(mediana(1,:));

            a=puntos(2,mediana(2,I))-puntos(2,mediana(3,I));
            b=puntos(1,mediana(2,I))-puntos(1,mediana(3,I));
            c=-puntos(1,mediana(2,I))*a+puntos(2,mediana(2,I))*b;

            x=puntos(1,:);
            Y=x.*(a/b)+(c/b);
    else
        Y=puntos(2,:);
    end
        
regresion=Y;